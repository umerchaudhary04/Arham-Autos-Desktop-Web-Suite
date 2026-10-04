import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/db/app_database.dart';

class InvoicePrinter {
  static Future<void> printInvoice(Sale sale, List<SaleItem> items, List<Part> parts, Customer? customer, {Route? route, Employee? salesman}) async {
    final urduFont = await PdfGoogleFonts.notoNastaliqUrduRegular();
    
    final pdf = pw.Document();

    pw.Widget buildInvoicePanel(pw.Context context) {
      return pw.Container(
        padding: const pw.EdgeInsets.only(
          top: 8 * PdfPageFormat.mm,
          bottom: 8 * PdfPageFormat.mm,
          left: 10 * PdfPageFormat.mm,
          right: 10 * PdfPageFormat.mm,
        ),
        child: pw.Column(
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
            pw.SizedBox(height: 10),
            
            // Metadata (Two-column table with thin borders)
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Customer: ${customer?.name ?? 'Walk-in'}'),
                          if (customer?.phone != null) pw.Text('Phone: ${customer?.phone}'),
                          pw.Text('Route: ${route?.name ?? '-'}'),
                          pw.Text('Booker/DSO: ${salesman?.name ?? '-'}'),
                        ],
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Bill No: ${sale.billNumber}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Date: ${sale.createdAt.toIso8601String().split('T').first}'),
                          pw.Text('Sale Type: ${sale.saleType}'),
                          pw.Text('Status: ${sale.paymentStatus}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            
            // Items Table
            pw.TableHelper.fromTextArray(
              headers: ['S.No', 'Description', 'Qty', 'Rate', 'Total'],
              cellStyle: pw.TextStyle(fontFallback: [urduFont]),
              data: List.generate(items.length, (index) {
                final item = items[index];
                final part = parts.firstWhere((p) => p.id == item.partId);
                final desc = part.nameUr != null && part.nameUr!.isNotEmpty 
                    ? '${part.nameEn} / ${part.nameUr}' 
                    : part.nameEn;
                return [
                  (index + 1).toString(),
                  desc,
                  '${item.qty} ${part.unit}',
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
                    pw.Text('Net Payable: Rs ${(sale.netAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    if (customer != null) ...[
                      pw.SizedBox(height: 5),
                      pw.Text('Previous Khata Balance: Rs ${(sale.previousBalancePaisa / 100).toStringAsFixed(2)}'),
                      pw.Text('Paid Amount: Rs ${(sale.paidAmountPaisa / 100).toStringAsFixed(2)}'),
                      pw.Text('Total Outstanding: Rs ${((sale.previousBalancePaisa + sale.netAmountPaisa - sale.paidAmountPaisa) / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
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
                style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero, // Margins are handled inside buildInvoicePanel
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Expanded(child: buildInvoicePanel(context)),
              pw.Divider(height: 1, thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.Expanded(child: buildInvoicePanel(context)),
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
