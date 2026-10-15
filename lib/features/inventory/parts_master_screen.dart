import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import 'part_form_dialog.dart';
import 'stock_adjustment_dialog.dart';
import '../barcode_studio/barcode_studio_screen.dart';

// Assuming a provider for database exists. We will create it.
final dbProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError();
});

class PartsMasterScreen extends ConsumerStatefulWidget {
  const PartsMasterScreen({super.key});

  @override
  ConsumerState<PartsMasterScreen> createState() => _PartsMasterScreenState();
}

class _PartsMasterScreenState extends ConsumerState<PartsMasterScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts Catalog & Master Inventory'),
        actions: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F172A),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            label: const Text('Barcode Studio'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BarcodeStudioScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F172A),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Part'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const PartFormDialog(),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Input Field
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search spare parts by English/Urdu title, part code, or barcode...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),

            // Parts List
            Expanded(
              child: StreamBuilder<List<Part>>(
                stream: db.select(db.parts).watch(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final allParts = snapshot.data!;
                  final parts = allParts.where((p) {
                    if (_searchQuery.isEmpty) return true;
                    final nameEnMatch = p.nameEn.toLowerCase().contains(_searchQuery);
                    final nameUrMatch = (p.nameUr ?? '').toLowerCase().contains(_searchQuery);
                    final codeMatch = p.code.toLowerCase().contains(_searchQuery);
                    final barcodeMatch = (p.barcode ?? '').toLowerCase().contains(_searchQuery);
                    return nameEnMatch || nameUrMatch || codeMatch || barcodeMatch;
                  }).toList();

                  if (parts.isEmpty) {
                    return const Center(child: Text('No matching parts found in catalog.'));
                  }

                  return ListView.separated(
                    itemCount: parts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      final isLowStock = part.currentStock <= part.minStockAlert;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isLowStock ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                          foregroundColor: isLowStock ? Colors.red.shade800 : const Color(0xFF0F172A),
                          child: Icon(isLowStock ? Icons.warning_amber_rounded : Icons.precision_manufacturing),
                        ),
                        title: Text(
                          '${part.nameEn} ${part.nameUr != null && part.nameUr!.isNotEmpty ? '(${part.nameUr})' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Code: ${part.code} | Stock: ${part.currentStock} ${part.unit} '
                          '| Barcode: ${part.barcode ?? "N/A"} | Shelf: ${part.shelfLocation ?? "N/A"}',
                          style: TextStyle(
                            color: isLowStock ? Colors.red.shade700 : const Color(0xFF64748B),
                            fontWeight: isLowStock ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Retail: Rs ${(part.retailPricePaisa / 100).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('Wholesale: Rs ${(part.wholesalePricePaisa / 100).toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(Icons.qr_code_2),
                              tooltip: 'Print Barcode Sticker',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => BarcodeStudioScreen(part: part)),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.tune),
                              tooltip: 'Adjust Stock',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => StockAdjustmentDialog(part: part),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit Part',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => PartFormDialog(part: part),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
