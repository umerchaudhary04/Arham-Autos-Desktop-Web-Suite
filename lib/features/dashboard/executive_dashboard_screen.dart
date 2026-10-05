import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider
import 'package:drift/drift.dart' as drift;

final dashboardStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final db = ref.read(dbProvider);
  
  // 1. Total Inventory Value
  final parts = await db.select(db.parts).get();
  double totalValue = parts.fold(0.0, (sum, p) => sum + ((p.avgCostPaisa ?? 0) * (p.currentStock ?? 0)) / 100);
  
  // 2. Daily Gross Sales
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final salesToday = await (db.select(db.sales)..where((t) => t.createdAt.isBiggerOrEqualValue(startOfDay))).get();
  double dailySales = salesToday.fold(0.0, (sum, s) => sum + (s.netAmountPaisa / 100));
  
  // 3. Low Stock Alerts
  final lowStock = await (db.select(db.parts)..where((t) => t.currentStock.isSmallerOrEqualValue(10))).get();
  
  // 4. Recent Sales
  final recentSales = await (db.select(db.sales)
    ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])
    ..limit(5)).get();

  return {
    'totalValue': totalValue,
    'dailySales': dailySales,
    'grossProfit': dailySales * 0.2, // Mock margin 20% for now
    'lowStockCount': lowStock.length,
    'lowStockItems': lowStock,
    'recentSales': recentSales,
  };
});

class ExecutiveDashboardScreen extends ConsumerWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFF171717);
    const ctaColor = Color(0xFFD4AF37);
    const cardColor = Colors.white;

    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: primaryColor)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (stats) {
          final totalValue = stats['totalValue'] as double;
          final dailySales = stats['dailySales'] as double;
          final grossProfit = stats['grossProfit'] as double;
          final lowStockCount = stats['lowStockCount'] as int;
          final lowStockItems = stats['lowStockItems'] as List<Part>;
          final recentSales = stats['recentSales'] as List<Sale>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Executive Dashboard', style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildKpiCard('Total Inventory Value', 'Rs. ${totalValue.toStringAsFixed(2)}', Icons.inventory, Colors.blue),
                    const SizedBox(width: 16),
                    _buildKpiCard('Daily Gross Profit', 'Rs. ${grossProfit.toStringAsFixed(2)}', Icons.trending_up, Colors.green),
                    const SizedBox(width: 16),
                    _buildKpiCard('Daily Gross Sales', 'Rs. ${dailySales.toStringAsFixed(2)}', Icons.point_of_sale, Colors.purple),
                    const SizedBox(width: 16),
                    _buildKpiCard('Low Stock Alerts', '$lowStockCount Items', Icons.warning_amber_rounded, Colors.red),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sales Performance (Weekly)', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor)),
                      const SizedBox(height: 24),
                      SizedBox(height: 200, child: _buildMockChart(primaryColor, const Color(0xFF404040))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Recent Sales', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor)),
                            const SizedBox(height: 16),
                            if (recentSales.isEmpty) const Text("No recent sales.", style: TextStyle(color: Colors.grey))
                            else ...recentSales.map((s) => _buildRecentSaleItem(s, primaryColor, ctaColor)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Low Stock Alerts', style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor)),
                            const SizedBox(height: 16),
                            if (lowStockItems.isEmpty) const Text("No alerts. All stock optimal.", style: TextStyle(color: Colors.green))
                            else ...lowStockItems.take(5).map((p) => _buildLowStockItem(p, primaryColor, ctaColor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Color(0xFF404040), fontWeight: FontWeight.w500)),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF171717))),
          ],
        ),
      ),
    );
  }

  Widget _buildMockChart(Color primaryColor, Color secondaryColor) {
    final heights = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: 32, height: heights[index], decoration: BoxDecoration(color: primaryColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))),
            const SizedBox(height: 8),
            Text(labels[index], style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: secondaryColor)),
          ],
        );
      }),
    );
  }

  Widget _buildRecentSaleItem(Sale sale, Color primaryColor, Color ctaColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INV-${sale.id}', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: primaryColor)),
              Text(sale.createdAt.toString().split('.')[0], style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              Text('Rs. ${(sale.netAmountPaisa / 100).toStringAsFixed(2)}', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: primaryColor)),
              const SizedBox(width: 16),
              IconButton(icon: const Icon(Icons.print, size: 20), color: ctaColor, onPressed: () {}, tooltip: 'Reprint'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockItem(Part part, Color primaryColor, Color ctaColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(part.nameEn, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: primaryColor), overflow: TextOverflow.ellipsis),
                Text('Code: ${part.code} • Stock: ${part.currentStock ?? 0}', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.red)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctaColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            onPressed: () {},
            child: const Text('Create GRN', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
