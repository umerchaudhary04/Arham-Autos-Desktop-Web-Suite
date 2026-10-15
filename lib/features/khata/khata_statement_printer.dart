import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../core/db/app_database.dart';

class KhataStatementPrinter {
  static Future<void> printCustomerStatement({
    required Customer customer,
    required List<CustomerLedgerEntry> entries,
    String? routeName,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final nowFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    int totalDebitPaisa = entries.fold(0, (s, e) => s + e.debitAmountPaisa);
    int totalCreditPaisa = entries.fold(0, (s, e) => s + e.creditAmountPaisa);
    double curBal = customer.currentBalancePaisa / 100;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ARHAM AUTOS', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                      pw.Text('Bagobhar Road, Kot Samaba | Phone: 0300-6748837', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.Text('CUSTOMER KHATA ACCOUNT STATEMENT', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date Printed: $nowFormatted', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('Account ID: #${customer.id}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Customer: ${customer.name} ${customer.shopName != null ? "(${customer.shopName})" : ""}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.Text('Phone: ${customer.phone ?? "N/A"} | Route: ${routeName ?? "General / Counter"}', style: const pw.TextStyle(fontSize: 9)),
                        if (customer.address != null) pw.Text('Address: ${customer.address}', style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Tier: ${customer.customerType}', style: const pw.TextStyle(fontSize: 9)),
                        if (customer.creditLimitPaisa != null)
                          pw.Text('Credit Limit: Rs ${(customer.creditLimitPaisa! / 100).toStringAsFixed(0)}', style: const pw.TextStyle(fontSize: 9)),
                        pw.Text(
                          'Net Outstanding: Rs ${curBal.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: curBal > 0 ? PdfColors.red900 : PdfColors.green900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(thickness: 0.5, color: PdfColors.grey400),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  pw.Text(
                    'For Account Solution Contact AlphaSync Systems: 03140486627 | info@alphasync.codes',
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                  ),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.TableHelper.fromTextArray(
              headers: ['S.No', 'Date', 'Type', 'Debit (Rs)', 'Credit (Rs)', 'Balance (Rs)', 'Particulars / Ref'],
              headerStyle: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              columnWidths: {
                0: const pw.FixedColumnWidth(24),
                1: const pw.FixedColumnWidth(64),
                2: const pw.FixedColumnWidth(64),
                3: const pw.FixedColumnWidth(54),
                4: const pw.FixedColumnWidth(54),
                5: const pw.FixedColumnWidth(58),
                6: const pw.FlexColumnWidth(),
              },
              data: List.generate(entries.length, (i) {
                final e = entries[i];
                final debit = e.debitAmountPaisa > 0 ? (e.debitAmountPaisa / 100).toStringAsFixed(2) : '-';
                final credit = e.creditAmountPaisa > 0 ? (e.creditAmountPaisa / 100).toStringAsFixed(2) : '-';
                final bal = (e.runningBalancePaisa / 100).toStringAsFixed(2);
                final dateStr = dateFormat.format(e.createdAt);

                return [
                  (i + 1).toString(),
                  dateStr,
                  e.entryType,
                  debit,
                  credit,
                  bal,
                  e.notes ?? (e.invoiceId != null ? 'Invoice #${e.invoiceId}' : '-'),
                ];
              }),
            ),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Total Invoiced (Debits): Rs ${(totalDebitPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('Total Paid / Credited: Rs ${(totalCreditPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                      pw.Divider(thickness: 0.5),
                      pw.Text(
                        'Closing Balance Due: Rs ${curBal.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.red900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Khata_${customer.name.replaceAll(' ', '_')}.pdf',
    );
  }

  static Future<void> printSupplierStatement({
    required Supplier supplier,
    required List<SupplierLedgerEntry> entries,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final nowFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    int totalPurchasesPaisa = entries.fold(0, (s, e) => s + e.creditAmountPaisa);
    int totalPaidPaisa = entries.fold(0, (s, e) => s + e.debitAmountPaisa);
    double curBal = supplier.currentBalancePaisa / 100;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ARHAM AUTOS', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                      pw.Text('Bagobhar Road, Kot Samaba | Phone: 0300-6748837', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                      pw.Text('SUPPLIER KHATA ACCOUNT STATEMENT', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date Printed: $nowFormatted', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('Vendor ID: #${supplier.id}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Supplier: ${supplier.name} ${supplier.company != null ? "(${supplier.company})" : ""}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.Text('Phone: ${supplier.phone ?? "N/A"} | Address: ${supplier.address ?? "N/A"}', style: const pw.TextStyle(fontSize: 9)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Current Payable Balance: Rs ${curBal.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: curBal > 0 ? PdfColors.red900 : PdfColors.green900),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(thickness: 0.5, color: PdfColors.grey400),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  pw.Text(
                    'For Account Solution Contact AlphaSync Systems: 03140486627 | info@alphasync.codes',
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                  ),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.TableHelper.fromTextArray(
              headers: ['S.No', 'Date', 'Type', 'Purchases / Credit (Rs)', 'Paid / Debit (Rs)', 'Balance (Rs)', 'Particulars / Ref'],
              headerStyle: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              columnWidths: {
                0: const pw.FixedColumnWidth(24),
                1: const pw.FixedColumnWidth(64),
                2: const pw.FixedColumnWidth(64),
                3: const pw.FixedColumnWidth(64),
                4: const pw.FixedColumnWidth(64),
                5: const pw.FixedColumnWidth(58),
                6: const pw.FlexColumnWidth(),
              },
              data: List.generate(entries.length, (i) {
                final e = entries[i];
                final purchases = e.creditAmountPaisa > 0 ? (e.creditAmountPaisa / 100).toStringAsFixed(2) : '-';
                final paid = e.debitAmountPaisa > 0 ? (e.debitAmountPaisa / 100).toStringAsFixed(2) : '-';
                final bal = (e.runningBalancePaisa / 100).toStringAsFixed(2);
                final dateStr = dateFormat.format(e.createdAt);

                return [
                  (i + 1).toString(),
                  dateStr,
                  e.entryType,
                  purchases,
                  paid,
                  bal,
                  e.notes ?? (e.grnId != null ? 'GRN #${e.grnId}' : '-'),
                ];
              }),
            ),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Total Purchases (Payables): Rs ${(totalPurchasesPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('Total Disbursements Paid: Rs ${(totalPaidPaisa / 100).toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 9)),
                      pw.Divider(thickness: 0.5),
                      pw.Text(
                        'Total Balance Payable: Rs ${curBal.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.red900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'SupplierKhata_${supplier.name.replaceAll(' ', '_')}.pdf',
    );
  }

  static Future<void> printAgingRecoverySheet({
    required String routeName,
    required String salesmanName,
    required List<Map<String, dynamic>> agingRows,
  }) async {
    final pdf = pw.Document();
    final nowFormatted = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    double totalDue = 0;
    double total0to30 = 0;
    double total31to60 = 0;
    double total60plus = 0;

    for (final row in agingRows) {
      totalDue += (row['totalBalance'] as double);
      total0to30 += (row['current30'] as double);
      total31to60 += (row['overdue60'] as double);
      total60plus += (row['overdue90plus'] as double);
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ARHAM AUTOS — SALESMAN RECOVERY & AGING SHEET', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                      pw.Text('Route: $routeName | Booker / DSO: $salesmanName | Date: $nowFormatted', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800)),
                    ],
                  ),
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 1, color: PdfColors.grey400),
              pw.SizedBox(height: 6),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Field instructions: Obtain customer sign-off upon receiving cash/cheque payments.', style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                    'For Account Solution Contact AlphaSync Systems: 03140486627 | info@alphasync.codes',
                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                  ),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.TableHelper.fromTextArray(
              headers: [
                'S.No',
                'Customer / Shop Name',
                'Phone',
                'Total Due (Rs)',
                '0-30 Days',
                '31-60 Days',
                '60+ Days',
                'Collected Amount (Rs)',
                'Customer Signature',
              ],
              headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 7.5),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
              columnWidths: {
                0: const pw.FixedColumnWidth(22),
                1: const pw.FlexColumnWidth(2.5),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(65),
                4: const pw.FixedColumnWidth(55),
                5: const pw.FixedColumnWidth(55),
                6: const pw.FixedColumnWidth(55),
                7: const pw.FixedColumnWidth(85),
                8: const pw.FixedColumnWidth(90),
              },
              data: List.generate(agingRows.length, (i) {
                final row = agingRows[i];
                final cust = row['customer'] as Customer;
                return [
                  (i + 1).toString(),
                  '${cust.name} ${cust.shopName != null ? "(${cust.shopName})" : ""}',
                  cust.phone ?? '-',
                  (row['totalBalance'] as double).toStringAsFixed(0),
                  (row['current30'] as double).toStringAsFixed(0),
                  (row['overdue60'] as double).toStringAsFixed(0),
                  (row['overdue90plus'] as double).toStringAsFixed(0),
                  '', // Blank for physical writing
                  '', // Blank for signature
                ];
              }),
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Accounts: ${agingRows.length}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                  'Totals — Due: Rs ${totalDue.toStringAsFixed(0)} | 0-30D: Rs ${total0to30.toStringAsFixed(0)} | 31-60D: Rs ${total31to60.toStringAsFixed(0)} | 60+D: Rs ${total60plus.toStringAsFixed(0)}',
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'RecoverySheet_${routeName.replaceAll(' ', '_')}.pdf',
    );
  }
}
