import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BarcodeStudioScreen extends StatefulWidget {
  const BarcodeStudioScreen({super.key});

  @override
  State<BarcodeStudioScreen> createState() => _BarcodeStudioScreenState();
}

class _BarcodeStudioScreenState extends State<BarcodeStudioScreen> {
  final _barcodeController = TextEditingController(text: '123456789');
  final _titleController = TextEditingController(text: 'Sample Part');
  final _priceController = TextEditingController(text: '1500');

  Future<void> _printBarcode() async {
    final pdf = pw.Document();
    
    final barcodeData = _barcodeController.text;
    final title = _titleController.text;
    final price = _priceController.text;

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(50 * PdfPageFormat.mm, 30 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(title, style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 2),
                pw.BarcodeWidget(
                  data: barcodeData,
                  barcode: pw.Barcode.code128(),
                  width: 120,
                  height: 40,
                ),
                pw.SizedBox(height: 2),
                pw.Text('Rs. $price', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Barcode_$barcodeData',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Studio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Part Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(labelText: 'Barcode (Code-128)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _printBarcode,
              icon: const Icon(Icons.print),
              label: const Text('Print Sticker'),
            ),
          ],
        ),
      ),
    );
  }
}
