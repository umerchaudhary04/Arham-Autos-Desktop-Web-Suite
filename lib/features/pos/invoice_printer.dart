import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/db/app_database.dart';

class InvoicePrinter {
  static Future<void> printInvoice(Sale sale, List<SaleItem> items, List<Part> parts, Customer? customer) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.copyWith(
          // For 2-up A5 layout on A4, we use half page dimensions for the content
          // Or we can just print A5 landscape directly
        ),
        margin: const pw.EdgeInsets.all(10 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Arham Autos', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Bagobhar Road Kotsmaba', style: const pw.TextStyle(fontSize: 12)),
                    pw.Text('Phone: 0300-6748837', style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              
              // Metadata
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer: ${customer?.name ?? 'Walk-in'}'),
                      if (customer?.phone != null) pw.Text('Phone: ${customer?.phone}'),
                      pw.Text('Sale Type: ${sale.saleType}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Bill No: ${sale.billNumber}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Date: ${sale.createdAt.toIso8601String().split('T').first}'),
                      pw.Text('Status: ${sale.paymentStatus}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              
              // Items Table
              pw.TableHelper.fromTextArray(
                headers: ['S.No', 'Description', 'Qty', 'Rate', 'Total'],
                data: List.generate(items.length, (index) {
                  final item = items[index];
                  final part = parts.firstWhere((p) => p.id == item.partId);
                  return [
                    (index + 1).toString(),
                    part.nameEn,
                    item.qty.toString(),
                    (item.unitRatePaisa / 100).toStringAsFixed(2),
                    (item.lineTotalPaisa / 100).toStringAsFixed(2),
                  ];
                }),
              ),
              pw.SizedBox(height: 10),
              
              // Footer Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Gross Amount: Rs ${(sale.grossAmountPaisa / 100).toStringAsFixed(2)}'),
                      if (sale.discountAmountPaisa > 0)
                        pw.Text('Discount: Rs ${(sale.discountAmountPaisa / 100).toStringAsFixed(2)}'),
                      pw.Text('Net Amount: Rs ${(sale.netAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      if (customer != null) ...[
                        pw.SizedBox(height: 5),
                        pw.Text('Previous Balance: Rs ${(sale.previousBalancePaisa / 100).toStringAsFixed(2)}'),
                        pw.Text('Paid Amount: Rs ${(sale.paidAmountPaisa / 100).toStringAsFixed(2)}'),
                        pw.Text('Total Outstanding: Rs ${((sale.previousBalancePaisa + sale.netAmountPaisa - sale.paidAmountPaisa) / 100).toStringAsFixed(2)}'),
                      ]
                    ],
                  ),
                ],
              ),
              
              pw.Spacer(),
              
              // Attribution
              pw.Center(
                child: pw.Text(
                  'For Account Solution Contact AlphaSync Systems: 03140486627',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${sale.billNumber}',
    );
  }
}
