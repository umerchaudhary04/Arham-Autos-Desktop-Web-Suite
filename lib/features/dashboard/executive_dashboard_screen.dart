import 'package:flutter/material.dart';

class ExecutiveDashboardScreen extends StatelessWidget {
  const ExecutiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF171717);
    const secondaryColor = Color(0xFF404040);
    const ctaColor = Color(0xFFD4AF37);
    const bgColor = Color(0xFFF8FAFC); // Slight off-white to make cards pop
    const cardColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Executive Dashboard',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            // Top Section: 4 KPI Cards
            Row(
              children: [
                _buildKpiCard('Total Inventory Value', 'Rs. 4.2M', Icons.inventory_2_outlined, ctaColor),
                const SizedBox(width: 16),
                _buildKpiCard('Daily Gross Profit', 'Rs. 15,400', Icons.trending_up, Colors.green),
                const SizedBox(width: 16),
                _buildKpiCard('Daily Gross Sales', 'Rs. 85,000', Icons.receipt_long, Colors.blue),
                const SizedBox(width: 16),
                _buildKpiCard('Low Stock Alerts', '12 Items', Icons.warning_amber_rounded, Colors.red),
              ],
            ),
            const SizedBox(height: 24),
            // Middle Section: Weekly & Monthly Sales Performance Chart
            Container(
              height: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Performance',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildMockChart(ctaColor, secondaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Bottom Section: Split View
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Recent 5 Sales
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Sales',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(5, (index) => _buildRecentSaleItem(index, primaryColor, ctaColor)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Right: Low Stock Alerts
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Low Stock Alerts',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(5, (index) => _buildLowStockItem(index, primaryColor, ctaColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFF404040),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF171717),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockChart(Color primaryColor, Color secondaryColor) {
    // A simple visual representation of a bar chart
    final heights = [40.0, 70.0, 50.0, 100.0, 80.0, 120.0, 90.0];
    final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 32,
              height: heights[index],
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              labels[index],
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: secondaryColor,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRecentSaleItem(int index, Color primaryColor, Color ctaColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INV-${1000 + index}',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const Text(
                '2 items • Walk-in Customer',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Rs. ${1500 * (index + 1)}',
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: primaryColor),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.print, size: 20),
                color: ctaColor,
                onPressed: () {},
                tooltip: 'Reprint',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockItem(int index, Color primaryColor, Color ctaColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Brake Pad ${String.fromCharCode(65 + index)}',
                  style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: primaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Code: BP-00${index + 1} • Stock: ${2 + index}',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ctaColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {},
            child: const Text('Create GRN', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
