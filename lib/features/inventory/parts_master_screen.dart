import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import 'part_form_dialog.dart';
import 'stock_adjustment_dialog.dart';

// Assuming a provider for database exists. We will create it.
final dbProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError();
});

class PartsMasterScreen extends ConsumerWidget {
  const PartsMasterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parts Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const PartFormDialog(),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<Part>>(
        stream: db.select(db.parts).watch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final parts = snapshot.data!;
          if (parts.isEmpty) {
            return const Center(child: Text('No parts found.'));
          }
          return ListView.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index];
              return ListTile(
                title: Text('${part.nameEn} ${part.nameUr != null ? '(${part.nameUr})' : ''}'),
                subtitle: Text('Code: ${part.code} | Stock: ${part.currentStock} | Shelf: ${part.shelfLocation ?? 'N/A'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('R: Rs${part.retailPricePaisa / 100} | W: Rs${part.wholesalePricePaisa / 100}'),
                    const SizedBox(width: 8),
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
    );
  }
}
