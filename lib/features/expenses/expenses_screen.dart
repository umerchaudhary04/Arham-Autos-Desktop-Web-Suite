import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // dbProvider

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  String _category = 'TEA_MEALS';

  void _recordExpense() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final db = ref.read(dbProvider);
    await db.into(db.expenses).insert(
      ExpensesCompanion(
        category: drift.Value(_category),
        amountPaisa: drift.Value((amount * 100).toInt()),
        description: drift.Value(_descController.text),
        paymentMode: const drift.Value('CASH'),
        recordedBy: const drift.Value(1),
        expenseDate: drift.Value(DateTime.now()),
      )
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense Recorded')));
      _amountController.clear();
      _descController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Expense Journal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Category'),
                    initialValue: _category,
                    items: const [
                      DropdownMenuItem(value: 'RENT', child: Text('Rent')),
                      DropdownMenuItem(value: 'ELECTRICITY', child: Text('Electricity')),
                      DropdownMenuItem(value: 'TEA_MEALS', child: Text('Tea / Meals')),
                      DropdownMenuItem(value: 'FUEL', child: Text('Fuel')),
                      DropdownMenuItem(value: 'MAINTENANCE', child: Text('Maintenance')),
                      DropdownMenuItem(value: 'MISC', child: Text('Miscellaneous')),
                    ],
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount (Rs)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description / Notes'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _recordExpense, child: const Text('Record Expense')),
            const Divider(),
            Expanded(
              child: StreamBuilder<List<Expense>>(
                stream: (db.select(db.expenses)..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])).watch(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text('${item.category} - Rs${item.amountPaisa / 100}'),
                        subtitle: Text(item.description ?? ''),
                        trailing: Text(item.createdAt.toString().split(' ')[0]),
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
