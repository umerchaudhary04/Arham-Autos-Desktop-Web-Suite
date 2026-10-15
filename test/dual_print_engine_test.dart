import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:arham_autos/core/db/app_database.dart';
import 'package:arham_autos/features/pos/invoice_printer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dual-Print Engine Unit Tests', () {
    final now = DateTime.now();

    final testSale = Sale(
      id: 1,
      billNumber: 10001,
      customerId: 10,
      salesmanId: 5,
      routeId: 2,
      saleType: 'RETAIL',
      grossAmountPaisa: 250000, // Rs 2500.00
      discountAmountPaisa: 10000, // Rs 100.00
      netAmountPaisa: 240000, // Rs 2400.00
      paidAmountPaisa: 200000, // Rs 2000.00
      previousBalancePaisa: 50000, // Rs 500.00
      paymentStatus: 'PARTIAL',
      createdBy: 1,
      createdAt: now,
    );

    final testPart = Part(
      id: 101,
      code: 'CD70-PIST-01',
      barcode: '896400012345',
      nameEn: 'Piston Kit Standard CD-70',
      nameUr: 'پسٹن کٹ سی ڈی ۷۰',
      brand: 'Crown',
      categoryId: 1,
      unit: 'PCS',
      avgCostPaisa: 150000,
      retailPricePaisa: 250000,
      wholesalePricePaisa: 220000,
      defectiveStock: 0,
      currentStock: 45,
      minStockAlert: 5,
      isActive: true,
      createdAt: now,
    );

    final testSaleItems = [
      const SaleItem(
        id: 1,
        saleId: 1,
        partId: 101,
        qty: 1,
        unitRatePaisa: 250000,
        lineTotalPaisa: 250000,
      ),
    ];

    final testCustomer = Customer(
      id: 10,
      name: 'Muhammad Tariq',
      shopName: 'Tariq Autos Kotsmaba',
      phone: '03001234567',
      customerType: 'RETAIL',
      currentBalancePaisa: 50000,
      createdAt: now,
    );

    final testRoute = Route(
      id: 2,
      name: 'Bagobhar Road Main Bazaar',
      city: 'Kotsmaba',
      createdAt: now,
    );

    final testSalesman = Employee(
      id: 5,
      name: 'Ali Raza DSO',
      phone: '03009876543',
      role: 'SALESMAN',
      assignedRouteId: 2,
      monthlySalaryPaisa: 3500000,
      isActive: true,
      createdAt: now,
    );

    // Provide a standard test font to avoid network calls during offline CI/unit testing
    final testFont = pw.Font.helvetica();

    test('Generates valid 2-Up Half-Page A4 Laser document (A5_2UP)', () async {
      final doc = await InvoicePrinter.generateInvoiceDocument(
        testSale,
        testSaleItems,
        [testPart],
        testCustomer,
        route: testRoute,
        salesman: testSalesman,
        printMode: 'A5_2UP',
        fallbackFont: testFont,
      );

      expect(doc, isNotNull);
      final bytes = await doc.save();
      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(100));

      expect(doc.document.pdfPageList.pages.length, equals(1));
      final page = doc.document.pdfPageList.pages.first;
      expect(page.pageFormat.width, equals(PdfPageFormat.a4.width));
      expect(page.pageFormat.height, equals(PdfPageFormat.a4.height));
    });

    test('Generates valid 80mm Continuous Thermal Receipt document (THERMAL_80MM)', () async {
      final doc = await InvoicePrinter.generateInvoiceDocument(
        testSale,
        testSaleItems,
        [testPart],
        testCustomer,
        route: testRoute,
        salesman: testSalesman,
        printMode: 'THERMAL_80MM',
        fallbackFont: testFont,
      );

      expect(doc, isNotNull);
      final bytes = await doc.save();
      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(100));

      expect(doc.document.pdfPageList.pages.length, equals(1));
      final page = doc.document.pdfPageList.pages.first;
      expect(page.pageFormat.width, equals(PdfPageFormat.roll80.width));
    });

    test('Generates valid 58mm Compact Thermal Receipt document (THERMAL_58MM)', () async {
      final doc = await InvoicePrinter.generateInvoiceDocument(
        testSale,
        testSaleItems,
        [testPart],
        testCustomer,
        route: testRoute,
        salesman: testSalesman,
        printMode: 'THERMAL_58MM',
        fallbackFont: testFont,
      );

      expect(doc, isNotNull);
      final bytes = await doc.save();
      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(100));

      expect(doc.document.pdfPageList.pages.length, equals(1));
      final page = doc.document.pdfPageList.pages.first;
      expect(page.pageFormat.width, equals(PdfPageFormat.roll57.width));
    });

    test('Defaults to A5 2-Up Laser format when printMode is null or unknown', () async {
      final doc = await InvoicePrinter.generateInvoiceDocument(
        testSale,
        testSaleItems,
        [testPart],
        testCustomer,
        route: testRoute,
        salesman: testSalesman,
        printMode: null,
        fallbackFont: testFont,
      );

      expect(doc, isNotNull);
      final bytes = await doc.save();
      expect(bytes, isNotEmpty);

      final page = doc.document.pdfPageList.pages.first;
      expect(page.pageFormat.width, equals(PdfPageFormat.a4.width));
    });
  });
}
