import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // To get dbProvider

class BarcodeStudioScreen extends ConsumerStatefulWidget {
  final Part? part;
  const BarcodeStudioScreen({super.key, this.part});

  @override
  ConsumerState<BarcodeStudioScreen> createState() => _BarcodeStudioScreenState();
}

class _BarcodeStudioScreenState extends ConsumerState<BarcodeStudioScreen> {
  final _barcodeController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _partCodeController = TextEditingController();

  Part? _currentPart;
  int _copies = 1;
  bool _isA4Sheet = false;

  @override
  void initState() {
    super.initState();
    if (widget.part != null) {
      _loadPart(widget.part!);
    } else {
      _barcodeController.text = '123456789';
      _titleController.text = 'Sample Spare Part';
      _priceController.text = '1500';
      _partCodeController.text = 'SP-001';
    }
  }

  void _loadPart(Part part) {
    setState(() {
      _currentPart = part;
      _titleController.text = part.nameUr != null && part.nameUr!.isNotEmpty
          ? '${part.nameEn} (${part.nameUr})'
          : part.nameEn;
      _barcodeController.text = part.barcode != null && part.barcode!.isNotEmpty
          ? part.barcode!
          : part.code;
      _partCodeController.text = part.code;
      _priceController.text = (part.retailPricePaisa / 100).toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _partCodeController.dispose();
    super.dispose();
  }

  Future<void> _printBarcode() async {
    final barcodeData = _barcodeController.text.trim();
    final title = _titleController.text.trim();
    final price = _priceController.text.trim();
    final code = _partCodeController.text.trim();

    if (barcodeData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barcode value cannot be empty.')),
      );
      return;
    }

    final pdf = pw.Document();

    pw.Widget buildSingleLabel() {
      return pw.Container(
        width: 48 * PdfPageFormat.mm,
        height: 28 * PdfPageFormat.mm,
        padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              'ARHAM AUTOS',
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            pw.Text(
              title,
              maxLines: 1,
              style: pw.TextStyle(
                fontSize: 7.5,
                fontWeight: pw.FontWeight.bold,
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.Container(
              height: 14 * PdfPageFormat.mm,
              child: pw.BarcodeWidget(
                data: barcodeData,
                barcode: pw.Barcode.code128(),
                drawText: true,
                textStyle: const pw.TextStyle(fontSize: 6.5),
              ),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Code: $code',
                  style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey800),
                ),
                pw.Text(
                  'Rs. $price',
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (_isA4Sheet) {
      // A4 Sheet: 3 columns x 8 rows = 24 labels per sheet
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(12 * PdfPageFormat.mm),
          build: (pw.Context context) {
            return [
              pw.Wrap(
                spacing: 4 * PdfPageFormat.mm,
                runSpacing: 4 * PdfPageFormat.mm,
                children: List.generate(_copies, (_) => buildSingleLabel()),
              ),
            ];
          },
        ),
      );
    } else {
      // Individual Roll Label (50mm x 30mm)
      for (int i = 0; i < _copies; i++) {
        pdf.addPage(
          pw.Page(
            pageFormat: const PdfPageFormat(50 * PdfPageFormat.mm, 30 * PdfPageFormat.mm),
            margin: const pw.EdgeInsets.all(1 * PdfPageFormat.mm),
            build: (pw.Context context) {
              return pw.Center(child: buildSingleLabel());
            },
          ),
        );
      }
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Barcode_${code}_$barcodeData',
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Studio — Label Generator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel: Form & Part Picker
                Expanded(
                  flex: 5,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Label Configuration',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Select an inventory part or enter custom sticker specifications.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 20),

                          // Part Picker Stream
                          StreamBuilder<List<Part>>(
                            stream: db.select(db.parts).watch(),
                            builder: (context, snapshot) {
                              final parts = snapshot.data ?? [];
                              return DropdownButtonFormField<Part>(
                                decoration: const InputDecoration(
                                  labelText: 'Pre-fill from Part Catalog',
                                  prefixIcon: Icon(Icons.inventory_2_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                value: _currentPart != null && parts.any((p) => p.id == _currentPart!.id)
                                    ? parts.firstWhere((p) => p.id == _currentPart!.id)
                                    : null,
                                items: parts.map((p) {
                                  return DropdownMenuItem(
                                    value: p,
                                    child: Text('${p.nameEn} [${p.code}]'),
                                  );
                                }).toList(),
                                onChanged: (p) {
                                  if (p != null) _loadPart(p);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Sticker Part Title',
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _partCodeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Part Code',
                                    prefixIcon: Icon(Icons.tag),
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    labelText: 'Retail Price (Rs)',
                                    prefixIcon: Icon(Icons.attach_money),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: _barcodeController,
                            decoration: const InputDecoration(
                              labelText: 'Barcode String (Code-128)',
                              prefixIcon: Icon(Icons.qr_code_2),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 20),

                          // Print Settings Row
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  decoration: const InputDecoration(
                                    labelText: 'Copies to Print',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _copies,
                                  items: [1, 2, 5, 10, 20, 24, 48, 100].map((c) {
                                    return DropdownMenuItem(value: c, child: Text('$c Label(s)'));
                                  }).toList(),
                                  onChanged: (v) => setState(() => _copies = v ?? 1),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<bool>(
                                  decoration: const InputDecoration(
                                    labelText: 'Target Media',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _isA4Sheet,
                                  items: const [
                                    DropdownMenuItem(value: false, child: Text('50x30mm Thermal Roll')),
                                    DropdownMenuItem(value: true, child: Text('A4 Multi-Sticker Sheet')),
                                  ],
                                  onChanged: (v) => setState(() => _isA4Sheet = v ?? false),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _printBarcode,
                              icon: const Icon(Icons.print),
                              label: Text(
                                'Print $_copies ${_isA4Sheet ? "Sticker(s) on A4" : "Thermal Sticker(s)"}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // Right Panel: Live Visual Sticker Preview
                Expanded(
                  flex: 4,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Live Sticker Preview',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Simulated 50mm x 30mm thermal label layout.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 24),

                          // Sticker Preview Box
                          Center(
                            child: Container(
                              width: 240,
                              height: 144,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'ARHAM AUTOS',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                                  ),
                                  Text(
                                    _titleController.text.isNotEmpty ? _titleController.text : 'Part Title',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                  // Barcode lines mock
                                  Container(
                                    height: 38,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 24,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: List.generate(40, (i) => i % 3 == 0 ? Colors.black : Colors.white),
                                                stops: List.generate(40, (i) => i / 40),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _barcodeController.text.isNotEmpty ? _barcodeController.text : '123456789',
                                            style: const TextStyle(fontFamily: 'Courier', fontSize: 9, letterSpacing: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Code: ${_partCodeController.text}',
                                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                      Text(
                                        'Rs. ${_priceController.text}',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.info_outline, size: 20, color: Color(0xFF475569)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Standard 50mm x 30mm Code-128 is compatible with Xprinter, TSC, and Gprinter barcode printers.',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
