import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../core/db/app_database.dart';

class InvoicePrinter {
  /// Builds the PDF Document for the invoice according to [printMode].
  /// Supported print modes:
  /// - 'A5_2UP' or 'LASER_A5': 2-Up Half-Page A4 Laser layout (Default)
  /// - 'THERMAL_80MM': 80mm Continuous Thermal Receipt Roll
  /// - 'THERMAL_58MM': 58mm Compact Continuous Thermal Receipt Roll
  static Future<pw.Document> generateInvoiceDocument(
    Sale sale,
    List<SaleItem> items,
    List<Part> parts,
    Customer? customer, {
    Route? route,
    Employee? salesman,
    String? printMode, // 'A5_2UP', 'LASER_A5', 'THERMAL_80MM', 'THERMAL_58MM'
    pw.Font? fallbackFont,
  }) async {
    pw.Font? urduFont = fallbackFont;
    if (urduFont == null) {
      try {
        urduFont = await PdfGoogleFonts.notoNastaliqUrduRegular();
      } catch (_) {
        // Fallback gracefully in offline or test environments
      }
    }
    final pdf = pw.Document();

    final mode = (printMode ?? 'A5_2UP').toUpperCase();
    final is58mm = mode == 'THERMAL_58MM';
    final is80mm = mode == 'THERMAL_80MM';
    final isThermal = is58mm || is80mm;

    if (isThermal) {
      // Thermal Continuous Receipt (58mm or 80mm)
      final pageFormat = is58mm ? PdfPageFormat.roll57 : PdfPageFormat.roll80;
      final margin = is58mm ? 4.0 : 8.0;
      final titleSize = is58mm ? 13.0 : 16.0;
      final bodySize = is58mm ? 7.0 : 8.0;
      final smallSize = is58mm ? 6.5 : 7.5;
      final tableCellSize = is58mm ? 6.5 : 7.5;

      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: pw.EdgeInsets.all(margin),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Store Header
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'ARHAM AUTOS',
                        style: pw.TextStyle(
                          fontSize: titleSize,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Bagobhar Road Kotsmaba',
                        style: pw.TextStyle(fontSize: smallSize),
                      ),
                      pw.Text(
                        'Ph: 0300-6748837',
                        style: pw.TextStyle(fontSize: smallSize),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        '*** CASH INVOICE ***',
                        style: pw.TextStyle(
                          fontSize: bodySize,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Divider(thickness: 0.8),

                // Bill & Customer Metadata
                pw.Text(
                  'Bill No: #${sale.billNumber}',
                  style: pw.TextStyle(fontSize: bodySize, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  'Date: ${sale.createdAt.toIso8601String().split('T').first}',
                  style: pw.TextStyle(fontSize: smallSize),
                ),
                pw.Text(
                  'Customer: ${customer?.name ?? "Walk-in Counter"}',
                  style: pw.TextStyle(fontSize: smallSize),
                ),
                if (customer?.phone != null && customer!.phone!.isNotEmpty)
                  pw.Text('Phone: ${customer.phone}', style: pw.TextStyle(fontSize: smallSize)),
                if (route != null)
                  pw.Text('Route: ${route.name}', style: pw.TextStyle(fontSize: smallSize)),
                if (salesman != null)
                  pw.Text('Booker/DSO: ${salesman.name}', style: pw.TextStyle(fontSize: smallSize)),
                pw.Divider(thickness: 0.8),

                // Itemized Table
                pw.TableHelper.fromTextArray(
                  headers: ['Item', 'Qty', 'Rate', 'Total'],
                  headerStyle: pw.TextStyle(fontSize: smallSize, fontWeight: pw.FontWeight.bold),
                  cellStyle: pw.TextStyle(fontSize: tableCellSize, fontFallback: urduFont != null ? [urduFont] : const []),
                  columnWidths: is58mm
                      ? {
                          0: const pw.FlexColumnWidth(2.6),
                          1: const pw.FixedColumnWidth(16),
                          2: const pw.FixedColumnWidth(26),
                          3: const pw.FixedColumnWidth(30),
                        }
                      : {
                          0: const pw.FlexColumnWidth(3),
                          1: const pw.FixedColumnWidth(24),
                          2: const pw.FixedColumnWidth(36),
                          3: const pw.FixedColumnWidth(42),
                        },
                  data: List.generate(items.length, (index) {
                    final item = items[index];
                    final part = parts.firstWhere((p) => p.id == item.partId);
                    final desc = part.nameUr != null && part.nameUr!.isNotEmpty
                        ? '${part.nameEn} / ${part.nameUr}'
                        : part.nameEn;
                    return [
                      desc,
                      '${item.qty}',
                      (item.unitRatePaisa / 100).toStringAsFixed(0),
                      (item.lineTotalPaisa / 100).toStringAsFixed(0),
                    ];
                  }),
                ),
                pw.Divider(thickness: 0.8),

                // Financial Summary
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Gross Amount:', style: pw.TextStyle(fontSize: bodySize)),
                    pw.Text('Rs ${(sale.grossAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: bodySize)),
                  ],
                ),
                if (sale.discountAmountPaisa > 0)
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Discount:', style: pw.TextStyle(fontSize: bodySize)),
                      pw.Text('- Rs ${(sale.discountAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: bodySize)),
                    ],
                  ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Net Payable:', style: pw.TextStyle(fontSize: bodySize + 1, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rs ${(sale.netAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: bodySize + 1, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                if (customer != null) ...[
                  pw.SizedBox(height: 2),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Previous Balance:', style: pw.TextStyle(fontSize: smallSize)),
                      pw.Text('Rs ${(sale.previousBalancePaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: smallSize)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Paid Amount:', style: pw.TextStyle(fontSize: smallSize)),
                      pw.Text('Rs ${(sale.paidAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontSize: smallSize)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total Due:', style: pw.TextStyle(fontSize: bodySize, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        'Rs ${((sale.previousBalancePaisa + sale.netAmountPaisa - sale.paidAmountPaisa) / 100).toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: bodySize, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ],
                pw.Divider(thickness: 0.8),

                // Mandatory AlphaSync Systems Footer
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text('Thank you for your business!', style: pw.TextStyle(fontSize: smallSize)),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'For Account Solution Contact AlphaSync Systems: 03140486627',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: smallSize - 0.5, fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      // Standard 2-Up Half-Page A4 Laser Layout (A5_2UP / LASER_A5)
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
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Arham Autos', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Bagobhar Road Kotsmaba', style: const pw.TextStyle(fontSize: 11)),
                    pw.Text('Phone: 0300-6748837', style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

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
                            pw.Text('Customer: ${customer?.name ?? 'Walk-in Counter'}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                            if (customer?.phone != null && customer!.phone!.isNotEmpty)
                              pw.Text('Phone: ${customer.phone}', style: const pw.TextStyle(fontSize: 8.5)),
                            pw.Text('Route: ${route?.name ?? '-'}', style: const pw.TextStyle(fontSize: 8.5)),
                            pw.Text('Booker/DSO: ${salesman?.name ?? '-'}', style: const pw.TextStyle(fontSize: 8.5)),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Bill No: #${sale.billNumber}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                            pw.Text('Date: ${sale.createdAt.toIso8601String().split('T').first}', style: const pw.TextStyle(fontSize: 8.5)),
                            pw.Text('Sale Type: ${sale.saleType}', style: const pw.TextStyle(fontSize: 8.5)),
                            pw.Text('Status: ${sale.paymentStatus}', style: const pw.TextStyle(fontSize: 8.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),

              pw.TableHelper.fromTextArray(
                headers: ['S.No', 'Description', 'Qty', 'Rate (Rs)', 'Total (Rs)'],
                headerStyle: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(fontSize: 8, fontFallback: urduFont != null ? [urduFont] : const []),
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
              pw.SizedBox(height: 8),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Gross Amount: Rs ${(sale.grossAmountPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                      if (sale.discountAmountPaisa > 0)
                        pw.Text('Discount: Rs ${(sale.discountAmountPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('Net Payable: Rs ${(sale.netAmountPaisa / 100).toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                      if (customer != null) ...[
                        pw.SizedBox(height: 3),
                        pw.Text('Previous Khata Balance: Rs ${(sale.previousBalancePaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
                        pw.Text('Paid Amount: Rs ${(sale.paidAmountPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 8.5)),
                        pw.Text(
                          'Total Outstanding: Rs ${((sale.previousBalancePaisa + sale.netAmountPaisa - sale.paidAmountPaisa) / 100).toStringAsFixed(2)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                  'For Account Solution Contact AlphaSync Systems: 03140486627',
                  style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
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
    }

    return pdf;
  }

  /// Sends the formatted invoice directly to the printing spooler.
  static Future<void> printInvoice(
    Sale sale,
    List<SaleItem> items,
    List<Part> parts,
    Customer? customer, {
    Route? route,
    Employee? salesman,
    String? printMode, // 'A5_2UP', 'LASER_A5', 'THERMAL_80MM', 'THERMAL_58MM'
  }) async {
    final pdf = await generateInvoiceDocument(
      sale,
      items,
      parts,
      customer,
      route: route,
      salesman: salesman,
      printMode: printMode,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${sale.billNumber}',
    );
  }
}
