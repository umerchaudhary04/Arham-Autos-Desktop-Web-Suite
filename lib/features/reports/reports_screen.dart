import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // dbProvider

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  int _totalSales = 0;
  int _totalCogs = 0;
  int _totalExpenses = 0;
  List<List<dynamic>> _reportRows = [];

  bool _isLoading = false;

  void _generateReport() async {
    setState(() => _isLoading = true);
    final db = ref.read(dbProvider);

    int salesAcc = 0;
    int cogsAcc = 0;
    int expAcc = 0;

    List<List<dynamic>> rows = [];
    rows.add(['Date', 'Type', 'Description', 'Amount (Rs)']);

    // 1. Fetch Sales within date range
    final sales = await (db.select(db.sales)
      ..where((t) => t.createdAt.isBetween(drift.Variable(_startDate), drift.Variable(_endDate.add(const Duration(days: 1)))))).get();
    
    for (var sale in sales) {
      salesAcc += sale.netAmountPaisa;
      rows.add([sale.createdAt.toString().split(' ')[0], 'SALE', 'Invoice #${sale.billNumber}', sale.netAmountPaisa / 100]);
      
      // Calculate COGS for this sale
      final items = await (db.select(db.saleItems)..where((t) => t.saleId.equals(sale.id))).get();
      for (var item in items) {
        final part = await (db.select(db.parts)..where((t) => t.id.equals(item.partId))).getSingle();
        // Assuming avgCostPaisa is the unit cost
        cogsAcc += (part.avgCostPaisa * item.qty);
      }
    }

    // 2. Fetch Expenses within date range
    final expenses = await (db.select(db.expenses)
      ..where((t) => t.expenseDate.isBetween(drift.Variable(_startDate), drift.Variable(_endDate.add(const Duration(days: 1)))))).get();

    for (var exp in expenses) {
      expAcc += exp.amountPaisa;
      rows.add([exp.expenseDate.toString().split(' ')[0], 'EXPENSE', exp.category, -(exp.amountPaisa / 100)]);
    }

    setState(() {
      _totalSales = salesAcc;
      _totalCogs = cogsAcc;
      _totalExpenses = expAcc;
      _reportRows = rows;
      _isLoading = false;
    });
  }

  void _exportCsv() async {
    if (_reportRows.isEmpty) return;

    final csvData = _reportRows.map((row) => row.map((e) => '"$e"').join(',')).join('\n');
    final FileSaveLocation? path = await getSaveLocation(suggestedName: 'Financial_Report.csv');
    if (path != null) {
      final file = File(path.path);
      await file.writeAsString(csvData);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to ${path.path}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    int grossProfit = _totalSales - _totalCogs;
    int netProfit = grossProfit - _totalExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Analytics & Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final d = await showDatePicker(context: context, initialDate: _startDate, firstDate: DateTime(2020), lastDate: DateTime(2050));
                    if (d != null) setState(() => _startDate = d);
                  }, 
                  child: Text('Start: ${_startDate.toString().split(' ')[0]}')
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final d = await showDatePicker(context: context, initialDate: _endDate, firstDate: DateTime(2020), lastDate: DateTime(2050));
                    if (d != null) setState(() => _endDate = d);
                  }, 
                  child: Text('End: ${_endDate.toString().split(' ')[0]}')
                ),
                const Spacer(),
                ElevatedButton(onPressed: _generateReport, child: const Text('Generate')),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _reportRows.length > 1 ? _exportCsv : null, 
                  icon: const Icon(Icons.download), 
                  label: const Text('Export CSV')
                ),
              ],
            ),
            const Divider(),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading && _reportRows.isNotEmpty) ...[
              Wrap(
                spacing: 20,
                children: [
                  _SummaryCard(title: 'Total Sales', amount: _totalSales),
                  _SummaryCard(title: 'COGS', amount: _totalCogs, isExpense: true),
                  _SummaryCard(title: 'Gross Profit', amount: grossProfit),
                  _SummaryCard(title: 'Expenses', amount: _totalExpenses, isExpense: true),
                  _SummaryCard(title: 'Net Profit', amount: netProfit, isHighlight: true),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _reportRows.length - 1,
                  itemBuilder: (context, index) {
                    final row = _reportRows[index + 1];
                    return ListTile(
                      leading: Icon(row[1] == 'SALE' ? Icons.arrow_upward : Icons.arrow_downward, color: row[1] == 'SALE' ? Colors.green : Colors.red),
                      title: Text('${row[0]} | ${row[2]}'),
                      trailing: Text('Rs ${row[3]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final bool isExpense;
  final bool isHighlight;

  const _SummaryCard({required this.title, required this.amount, this.isExpense = false, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHighlight ? Colors.blue[100] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Rs ${amount / 100}', style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: isExpense ? Colors.red : Colors.green
            )),
          ],
        ),
      ),
    );
  }
}
