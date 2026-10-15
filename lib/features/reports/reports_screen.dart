import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as ex;

import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Financial Tab State
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  int _totalSalesPaisa = 0;
  int _totalCogsPaisa = 0;
  int _totalExpensesPaisa = 0;
  List<Map<String, dynamic>> _financialRows = [];
  bool _isLoadingFinancial = false;

  // Dead Stock Tab State
  int _deadStockWindowDays = 90; // 30, 60, 90, 180
  List<Map<String, dynamic>> _deadStockRows = [];
  bool _isLoadingDeadStock = false;
  final TextEditingController _deadStockSearchController = TextEditingController();

  // Movement Velocity (ABC) Tab State
  int _velocityWindowDays = 90; // 30, 60, 90, 180
  List<Map<String, dynamic>> _velocityRows = [];
  bool _isLoadingVelocity = false;
  final TextEditingController _velocitySearchController = TextEditingController();
  String _velocityFilterClass = 'ALL'; // ALL, A, B, C

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 1 && _deadStockRows.isEmpty) {
        _generateDeadStockReport();
      } else if (_tabController.index == 2 && _velocityRows.isEmpty) {
        _generateVelocityReport();
      }
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateFinancialReport();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _deadStockSearchController.dispose();
    _velocitySearchController.dispose();
    super.dispose();
  }

  // ==========================================
  // AUDIT LOG HELPER
  // ==========================================
  Future<void> _logExportAudit(String reportName, String format, String filePath) async {
    try {
      final db = ref.read(dbProvider);
      await db.into(db.auditLogs).insert(
        AuditLogsCompanion.insert(
          actionType: 'REPORT_EXPORT',
          details: 'Exported $reportName ($format) to $filePath',
        ),
      );
    } catch (e) {
      debugPrint('Failed to log report export audit: $e');
    }
  }

  // ==========================================
  // TAB 1: FINANCIAL PERFORMANCE & P&L
  // ==========================================
  Future<void> _generateFinancialReport() async {
    setState(() => _isLoadingFinancial = true);
    final db = ref.read(dbProvider);

    try {
      final start = DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0);
      final end = DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59);

      int salesAcc = 0;
      int cogsAcc = 0;
      int expAcc = 0;
      final List<Map<String, dynamic>> rows = [];

      // 1. Fetch Sales within date range
      final sales = await (db.select(db.sales)
            ..where((t) => t.createdAt.isBetween(drift.Variable(start), drift.Variable(end)))
            ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)]))
          .get();

      // Fetch all sale items and parts for COGS calculation
      final parts = await db.select(db.parts).get();
      final partMap = {for (var p in parts) p.id: p};

      for (var sale in sales) {
        salesAcc += sale.netAmountPaisa;

        final items = await (db.select(db.saleItems)..where((t) => t.saleId.equals(sale.id))).get();
        int saleCogs = 0;
        for (var item in items) {
          final part = partMap[item.partId];
          if (part != null) {
            saleCogs += (part.avgCostPaisa * item.qty);
          }
        }
        cogsAcc += saleCogs;

        rows.add({
          'date': sale.createdAt,
          'type': 'SALE',
          'ref': 'Invoice #${sale.billNumber}',
          'amountPaisa': sale.netAmountPaisa,
          'cogsPaisa': saleCogs,
          'marginPaisa': sale.netAmountPaisa - saleCogs,
        });
      }

      // 2. Fetch Expenses within date range
      final expenses = await (db.select(db.expenses)
            ..where((t) => t.expenseDate.isBetween(drift.Variable(start), drift.Variable(end)))
            ..orderBy([(t) => drift.OrderingTerm.desc(t.expenseDate)]))
          .get();

      for (var exp in expenses) {
        expAcc += exp.amountPaisa;
        rows.add({
          'date': exp.expenseDate,
          'type': 'EXPENSE',
          'ref': 'Expense: ${exp.category}${exp.description != null ? " (${exp.description})" : ""}',
          'amountPaisa': -exp.amountPaisa,
          'cogsPaisa': 0,
          'marginPaisa': -exp.amountPaisa,
        });
      }

      // Sort rows descending
      rows.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

      setState(() {
        _totalSalesPaisa = salesAcc;
        _totalCogsPaisa = cogsAcc;
        _totalExpensesPaisa = expAcc;
        _financialRows = rows;
        _isLoadingFinancial = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingFinancial = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating report: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _exportFinancialCsv() async {
    if (_financialRows.isEmpty) return;

    final List<List<dynamic>> rows = [
      ['Date', 'Transaction Type', 'Reference / Description', 'Amount (Rs)', 'COGS (Rs)', 'Gross Margin (Rs)'],
      ..._financialRows.map((r) => [
        _dateTimeFormat.format(r['date'] as DateTime),
        r['type'],
        r['ref'],
        ((r['amountPaisa'] as int) / 100).toStringAsFixed(2),
        ((r['cogsPaisa'] as int) / 100).toStringAsFixed(2),
        ((r['marginPaisa'] as int) / 100).toStringAsFixed(2),
      ]),
    ];

    final csvContent = csv.encode(rows);
    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'Financial_Report_${_dateFormat.format(_startDate)}_to_${_dateFormat.format(_endDate)}.csv',
    );
    if (location != null) {
      final file = File(location.path);
      await file.writeAsString(csvContent);
      await _logExportAudit('Financial Performance & P&L', 'CSV', location.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Financial report CSV saved: ${location.path}'), backgroundColor: Colors.green.shade800),
        );
      }
    }
  }

  Future<void> _exportFinancialExcel() async {
    if (_financialRows.isEmpty) return;

    final excel = ex.Excel.createExcel();
    final sheet = excel['P&L_Report'];
    excel.setDefaultSheet('P&L_Report');

    // Header Title
    sheet.appendRow([ex.TextCellValue('ARHAM AUTOS — FINANCIAL PERFORMANCE & P&L REPORT')]);
    sheet.appendRow([ex.TextCellValue('Period: ${_dateFormat.format(_startDate)} to ${_dateFormat.format(_endDate)}')]);
    sheet.appendRow([
      ex.TextCellValue('Total Sales: Rs ${(_totalSalesPaisa / 100).toStringAsFixed(2)}'),
      ex.TextCellValue('COGS: Rs ${(_totalCogsPaisa / 100).toStringAsFixed(2)}'),
      ex.TextCellValue('Gross Profit: Rs ${((_totalSalesPaisa - _totalCogsPaisa) / 100).toStringAsFixed(2)}'),
      ex.TextCellValue('Expenses: Rs ${(_totalExpensesPaisa / 100).toStringAsFixed(2)}'),
      ex.TextCellValue('Net Profit: Rs ${((_totalSalesPaisa - _totalCogsPaisa - _totalExpensesPaisa) / 100).toStringAsFixed(2)}'),
    ]);
    sheet.appendRow([]); // empty line

    // Column Headers
    sheet.appendRow([
      ex.TextCellValue('Date & Time'),
      ex.TextCellValue('Type'),
      ex.TextCellValue('Reference / Description'),
      ex.TextCellValue('Amount (Rs)'),
      ex.TextCellValue('COGS (Rs)'),
      ex.TextCellValue('Gross Margin (Rs)'),
    ]);

    for (final r in _financialRows) {
      sheet.appendRow([
        ex.TextCellValue(_dateTimeFormat.format(r['date'] as DateTime)),
        ex.TextCellValue(r['type'] as String),
        ex.TextCellValue(r['ref'] as String),
        ex.DoubleCellValue((r['amountPaisa'] as int) / 100.0),
        ex.DoubleCellValue((r['cogsPaisa'] as int) / 100.0),
        ex.DoubleCellValue((r['marginPaisa'] as int) / 100.0),
      ]);
    }

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'Financial_Report_${_dateFormat.format(_startDate)}_to_${_dateFormat.format(_endDate)}.xlsx',
    );
    if (location != null) {
      final bytes = excel.save();
      if (bytes != null) {
        final file = File(location.path);
        await file.writeAsBytes(bytes);
        await _logExportAudit('Financial Performance & P&L', 'EXCEL', location.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Financial report Excel (.xlsx) saved: ${location.path}'), backgroundColor: Colors.green.shade800),
          );
        }
      }
    }
  }

  // ==========================================
  // TAB 2: DEAD STOCK ANALYSIS (ZERO-MOVEMENT)
  // ==========================================
  Future<void> _generateDeadStockReport() async {
    setState(() => _isLoadingDeadStock = true);
    final db = ref.read(dbProvider);

    try {
      final now = DateTime.now();
      final thresholdDate = now.subtract(Duration(days: _deadStockWindowDays));

      // 1. Fetch all active parts with positive shelf inventory
      final parts = await (db.select(db.parts)..where((t) => t.currentStock.isBiggerThanValue(0))).get();

      // 2. Fetch all sales within the movement window
      final salesInWindow = await (db.select(db.sales)..where((t) => t.createdAt.isBiggerOrEqualValue(thresholdDate))).get();
      final saleIdsInWindow = salesInWindow.map((s) => s.id).toSet();

      // 3. Fetch sale items sold during this window
      final saleItems = await db.select(db.saleItems).get();
      final Map<int, int> partSalesCount = {};
      final Map<int, DateTime> lastSaleDates = {};

      for (var item in saleItems) {
        if (saleIdsInWindow.contains(item.saleId)) {
          partSalesCount[item.partId] = (partSalesCount[item.partId] ?? 0) + item.qty;
        }
      }

      // Check all sales ever to find last sale date
      final allSales = await db.select(db.sales).get();
      final allSaleMap = {for (var s in allSales) s.id: s.createdAt};
      for (var item in saleItems) {
        final sDate = allSaleMap[item.saleId];
        if (sDate != null) {
          if (!lastSaleDates.containsKey(item.partId) || sDate.isAfter(lastSaleDates[item.partId]!)) {
            lastSaleDates[item.partId] = sDate;
          }
        }
      }

      final List<Map<String, dynamic>> calculatedDeadStock = [];

      for (final p in parts) {
        final soldInWindow = partSalesCount[p.id] ?? 0;
        // Strictly zero movement within the window
        if (soldInWindow == 0) {
          final lastSale = lastSaleDates[p.id];
          final daysSinceLastSale = lastSale != null ? now.difference(lastSale).inDays : 999;
          final lockedCapitalPaisa = p.currentStock * p.avgCostPaisa;

          calculatedDeadStock.add({
            'part': p,
            'soldInWindow': 0,
            'lastSaleDate': lastSale,
            'daysSinceLastSale': daysSinceLastSale,
            'lockedCapitalPaisa': lockedCapitalPaisa,
          });
        }
      }

      // Sort by highest locked capital descending
      calculatedDeadStock.sort((a, b) =>
          (b['lockedCapitalPaisa'] as int).compareTo(a['lockedCapitalPaisa'] as int));

      setState(() {
        _deadStockRows = calculatedDeadStock;
        _isLoadingDeadStock = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingDeadStock = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error analyzing dead stock: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _exportDeadStockCsv() async {
    if (_deadStockRows.isEmpty) return;

    final List<List<dynamic>> rows = [
      ['Part Code', 'Part Name (EN)', 'Part Name (UR)', 'Rack / Shelf', 'Stock Qty', 'Avg Unit Cost (Rs)', 'Total Locked Capital (Rs)', 'Days Since Last Sale', 'Last Sold Date'],
      ..._deadStockRows.map((r) {
        final p = r['part'] as Part;
        final lastSale = r['lastSaleDate'] as DateTime?;
        return [
          p.code,
          p.nameEn,
          p.nameUr ?? '',
          p.shelfLocation ?? '-',
          p.currentStock,
          (p.avgCostPaisa / 100).toStringAsFixed(2),
          ((r['lockedCapitalPaisa'] as int) / 100).toStringAsFixed(2),
          r['daysSinceLastSale'] == 999 ? 'Never Sold' : '${r['daysSinceLastSale']} days ago',
          lastSale != null ? _dateFormat.format(lastSale) : 'Never',
        ];
      }),
    ];

    final csvContent = csv.encode(rows);
    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'Dead_Stock_Analysis_${_deadStockWindowDays}Days_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
    );
    if (location != null) {
      final file = File(location.path);
      await file.writeAsString(csvContent);
      await _logExportAudit('Dead Stock Analysis', 'CSV', location.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dead stock CSV saved: ${location.path}'), backgroundColor: Colors.green.shade800),
        );
      }
    }
  }

  Future<void> _exportDeadStockExcel() async {
    if (_deadStockRows.isEmpty) return;

    final excel = ex.Excel.createExcel();
    final sheet = excel['Dead_Stock_Report'];
    excel.setDefaultSheet('Dead_Stock_Report');

    final deadCapitalPaisa = _deadStockRows.fold<int>(0, (sum, r) => sum + (r['lockedCapitalPaisa'] as int));
    final deadUnits = _deadStockRows.fold<int>(0, (sum, r) => sum + (r['part'] as Part).currentStock);

    sheet.appendRow([ex.TextCellValue('ARHAM AUTOS — DEAD STOCK ZERO-MOVEMENT REPORT')]);
    sheet.appendRow([ex.TextCellValue('Inactivity Window: $_deadStockWindowDays Days | Generated: ${_dateTimeFormat.format(DateTime.now())}')]);
    sheet.appendRow([
      ex.TextCellValue('Total Dead Stock SKUs: ${_deadStockRows.length}'),
      ex.TextCellValue('Total Locked Capital: Rs ${(deadCapitalPaisa / 100).toStringAsFixed(2)}'),
      ex.TextCellValue('Total Stagnant Units: $deadUnits'),
    ]);
    sheet.appendRow([]);

    sheet.appendRow([
      ex.TextCellValue('Part Code'),
      ex.TextCellValue('Part Name (English)'),
      ex.TextCellValue('Part Name (Urdu)'),
      ex.TextCellValue('Rack / Shelf'),
      ex.TextCellValue('Current Stock'),
      ex.TextCellValue('Avg Unit Cost (Rs)'),
      ex.TextCellValue('Locked Capital (Rs)'),
      ex.TextCellValue('Days Since Last Sale'),
      ex.TextCellValue('Last Sold Date'),
    ]);

    for (final r in _deadStockRows) {
      final p = r['part'] as Part;
      final lastSale = r['lastSaleDate'] as DateTime?;
      sheet.appendRow([
        ex.TextCellValue(p.code),
        ex.TextCellValue(p.nameEn),
        ex.TextCellValue(p.nameUr ?? ''),
        ex.TextCellValue(p.shelfLocation ?? '-'),
        ex.IntCellValue(p.currentStock),
        ex.DoubleCellValue(p.avgCostPaisa / 100.0),
        ex.DoubleCellValue((r['lockedCapitalPaisa'] as int) / 100.0),
        ex.TextCellValue(r['daysSinceLastSale'] == 999 ? 'Never' : '${r['daysSinceLastSale']} days ago'),
        ex.TextCellValue(lastSale != null ? _dateFormat.format(lastSale) : 'Never'),
      ]);
    }

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'Dead_Stock_Analysis_${_deadStockWindowDays}Days_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx',
    );
    if (location != null) {
      final bytes = excel.save();
      if (bytes != null) {
        final file = File(location.path);
        await file.writeAsBytes(bytes);
        await _logExportAudit('Dead Stock Analysis', 'EXCEL', location.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dead stock Excel (.xlsx) saved: ${location.path}'), backgroundColor: Colors.green.shade800),
          );
        }
      }
    }
  }

  // ==========================================
  // TAB 3: MOVEMENT VELOCITY (ABC ANALYSIS)
  // ==========================================
  Future<void> _generateVelocityReport() async {
    setState(() => _isLoadingVelocity = true);
    final db = ref.read(dbProvider);

    try {
      final now = DateTime.now();
      final thresholdDate = now.subtract(Duration(days: _velocityWindowDays));

      final parts = await db.select(db.parts).get();

      final salesInWindow = await (db.select(db.sales)..where((t) => t.createdAt.isBiggerOrEqualValue(thresholdDate))).get();
      final saleIdsInWindow = salesInWindow.map((s) => s.id).toSet();
      final saleItems = await db.select(db.saleItems).get();

      final Map<int, int> partQtySold = {};
      final Map<int, int> partRevenue = {};
      final Map<int, int> partInvoiceCount = {};
      final Map<int, DateTime> lastSaleDates = {};

      final saleDateMap = {for (var s in salesInWindow) s.id: s.createdAt};

      for (var item in saleItems) {
        if (saleIdsInWindow.contains(item.saleId)) {
          partQtySold[item.partId] = (partQtySold[item.partId] ?? 0) + item.qty;
          partRevenue[item.partId] = (partRevenue[item.partId] ?? 0) + item.lineTotalPaisa;
          partInvoiceCount[item.partId] = (partInvoiceCount[item.partId] ?? 0) + 1;

          final sDate = saleDateMap[item.saleId];
          if (sDate != null) {
            if (!lastSaleDates.containsKey(item.partId) || sDate.isAfter(lastSaleDates[item.partId]!)) {
              lastSaleDates[item.partId] = sDate;
            }
          }
        }
      }

      // Collect parts with sales in window
      final List<Map<String, dynamic>> movedParts = [];
      for (final p in parts) {
        final qty = partQtySold[p.id] ?? 0;
        final rev = partRevenue[p.id] ?? 0;
        final invCount = partInvoiceCount[p.id] ?? 0;
        final lastSale = lastSaleDates[p.id];

        if (qty > 0) {
          movedParts.add({
            'part': p,
            'qtySold': qty,
            'revenuePaisa': rev,
            'invoiceCount': invCount,
            'lastSaleDate': lastSale,
          });
        }
      }

      // Sort descending by total revenue generated
      movedParts.sort((a, b) => (b['revenuePaisa'] as int).compareTo(a['revenuePaisa'] as int));

      final int totalWindowRevenue = movedParts.fold<int>(0, (sum, m) => sum + (m['revenuePaisa'] as int));

      // Standard ABC Pareto Classification:
      // Class A: Top 70% of cumulative revenue (Fast Moving)
      // Class B: Next 20% of cumulative revenue (70% - 90%) (Moderate)
      // Class C: Bottom 10% of cumulative revenue (90% - 100%) (Slow Moving)
      int cumulativeRevenue = 0;
      final List<Map<String, dynamic>> classified = [];

      for (final item in movedParts) {
        final rev = item['revenuePaisa'] as int;
        cumulativeRevenue += rev;
        final double cumulativePercent = totalWindowRevenue > 0 ? (cumulativeRevenue / totalWindowRevenue) * 100 : 100.0;

        String abcClass;
        String abcLabel;
        Color badgeColor;
        Color badgeBgColor;

        if (cumulativePercent <= 70.0 || (item['qtySold'] as int) >= 10) {
          abcClass = 'A';
          abcLabel = 'CLASS A (FAST)';
          badgeColor = const Color(0xFF16A34A);
          badgeBgColor = const Color(0xFFF0FDF4);
        } else if (cumulativePercent <= 90.0 || (item['qtySold'] as int) >= 4) {
          abcClass = 'B';
          abcLabel = 'CLASS B (MODERATE)';
          badgeColor = const Color(0xFF2563EB);
          badgeBgColor = const Color(0xFFEFF6FF);
        } else {
          abcClass = 'C';
          abcLabel = 'CLASS C (SLOW)';
          badgeColor = const Color(0xFFD97706);
          badgeBgColor = const Color(0xFFFFFBEB);
        }

        classified.add({
          ...item,
          'abcClass': abcClass,
          'abcLabel': abcLabel,
          'badgeColor': badgeColor,
          'badgeBgColor': badgeBgColor,
          'cumulativePercent': cumulativePercent,
        });
      }

      setState(() {
        _velocityRows = classified;
        _isLoadingVelocity = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingVelocity = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error analyzing velocity: $e'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _exportVelocityCsv() async {
    final search = _velocitySearchController.text.toLowerCase().trim();
    final filtered = _velocityRows.where((r) {
      final p = r['part'] as Part;
      final matchesSearch = search.isEmpty ||
          p.code.toLowerCase().contains(search) ||
          p.nameEn.toLowerCase().contains(search) ||
          (p.nameUr?.contains(search) ?? false);
      final matchesClass = _velocityFilterClass == 'ALL' || r['abcClass'] == _velocityFilterClass;
      return matchesSearch && matchesClass;
    }).toList();

    if (filtered.isEmpty) return;

    final List<List<dynamic>> rows = [
      ['Part Code', 'Part Name (EN)', 'Part Name (UR)', 'Rack / Shelf', 'Stock Qty', 'Units Sold in ${_velocityWindowDays}D', 'Invoices', 'Revenue Generated (Rs)', 'Last Sold Date', 'ABC Velocity Class'],
      ...filtered.map((r) {
        final p = r['part'] as Part;
        final lastSale = r['lastSaleDate'] as DateTime?;
        return [
          p.code,
          p.nameEn,
          p.nameUr ?? '',
          p.shelfLocation ?? '-',
          p.currentStock,
          r['qtySold'],
          r['invoiceCount'],
          ((r['revenuePaisa'] as int) / 100).toStringAsFixed(2),
          lastSale != null ? _dateFormat.format(lastSale) : 'Never',
          r['abcLabel'],
        ];
      }),
    ];

    final csvContent = csv.encode(rows);
    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'ABC_Movement_Velocity_${_velocityWindowDays}Days_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
    );
    if (location != null) {
      final file = File(location.path);
      await file.writeAsString(csvContent);
      await _logExportAudit('ABC Movement Velocity Report', 'CSV', location.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Velocity CSV saved: ${location.path}'), backgroundColor: Colors.green.shade800),
        );
      }
    }
  }

  Future<void> _exportVelocityExcel() async {
    final search = _velocitySearchController.text.toLowerCase().trim();
    final filtered = _velocityRows.where((r) {
      final p = r['part'] as Part;
      final matchesSearch = search.isEmpty ||
          p.code.toLowerCase().contains(search) ||
          p.nameEn.toLowerCase().contains(search) ||
          (p.nameUr?.contains(search) ?? false);
      final matchesClass = _velocityFilterClass == 'ALL' || r['abcClass'] == _velocityFilterClass;
      return matchesSearch && matchesClass;
    }).toList();

    if (filtered.isEmpty) return;

    final excel = ex.Excel.createExcel();
    final sheet = excel['Velocity_Report'];
    excel.setDefaultSheet('Velocity_Report');

    final totalRevPaisa = filtered.fold<int>(0, (sum, r) => sum + (r['revenuePaisa'] as int));
    final totalUnits = filtered.fold<int>(0, (sum, r) => sum + (r['qtySold'] as int));

    sheet.appendRow([ex.TextCellValue('ARHAM AUTOS — ABC MOVEMENT VELOCITY ANALYTICS')]);
    sheet.appendRow([ex.TextCellValue('Analysis Window: $_velocityWindowDays Days | Filter: $_velocityFilterClass | Date: ${_dateTimeFormat.format(DateTime.now())}')]);
    sheet.appendRow([
      ex.TextCellValue('Total Moving SKUs: ${filtered.length}'),
      ex.TextCellValue('Total Units Sold: $totalUnits'),
      ex.TextCellValue('Total Revenue: Rs ${(totalRevPaisa / 100).toStringAsFixed(2)}'),
    ]);
    sheet.appendRow([]);

    sheet.appendRow([
      ex.TextCellValue('Part Code'),
      ex.TextCellValue('Part Name (English)'),
      ex.TextCellValue('Part Name (Urdu)'),
      ex.TextCellValue('Rack / Shelf'),
      ex.TextCellValue('Current Stock'),
      ex.TextCellValue('Units Sold'),
      ex.TextCellValue('Invoices'),
      ex.TextCellValue('Revenue (Rs)'),
      ex.TextCellValue('Last Sold Date'),
      ex.TextCellValue('ABC Velocity Class'),
    ]);

    for (final r in filtered) {
      final p = r['part'] as Part;
      final lastSale = r['lastSaleDate'] as DateTime?;
      sheet.appendRow([
        ex.TextCellValue(p.code),
        ex.TextCellValue(p.nameEn),
        ex.TextCellValue(p.nameUr ?? ''),
        ex.TextCellValue(p.shelfLocation ?? '-'),
        ex.IntCellValue(p.currentStock),
        ex.IntCellValue(r['qtySold'] as int),
        ex.IntCellValue(r['invoiceCount'] as int),
        ex.DoubleCellValue((r['revenuePaisa'] as int) / 100.0),
        ex.TextCellValue(lastSale != null ? _dateFormat.format(lastSale) : 'Never'),
        ex.TextCellValue(r['abcLabel'] as String),
      ]);
    }

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: 'ABC_Movement_Velocity_${_velocityWindowDays}Days_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx',
    );
    if (location != null) {
      final bytes = excel.save();
      if (bytes != null) {
        final file = File(location.path);
        await file.writeAsBytes(bytes);
        await _logExportAudit('ABC Movement Velocity Report', 'EXCEL', location.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Velocity Excel (.xlsx) saved: ${location.path}'), backgroundColor: Colors.green.shade800),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reports & Business Intelligence',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Financial P&L statements, Excel/CSV exports, 90-day dead stock & ABC velocity analytics',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF475569),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'Financial & Margin Summary'),
                      Tab(text: 'Dead Stock (Zero-Movement)'),
                      Tab(text: 'Movement Velocity (ABC Analysis)'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFinancialTab(),
                _buildDeadStockTab(),
                _buildVelocityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FINANCIAL PERFORMANCE TAB VIEW
  // ==========================================
  Widget _buildFinancialTab() {
    final grossProfitPaisa = _totalSalesPaisa - _totalCogsPaisa;
    final netProfitPaisa = grossProfitPaisa - _totalExpensesPaisa;
    final grossMarginPercent = _totalSalesPaisa > 0 ? (grossProfitPaisa / _totalSalesPaisa) * 100 : 0.0;

    return Column(
      children: [
        // 5 Top KPI Cards
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.white,
          child: Row(
            children: [
              _buildReportKpiCard('Total Revenue / Sales', 'Rs ${(_totalSalesPaisa / 100).toStringAsFixed(0)}', '${_financialRows.where((r) => r['type'] == 'SALE').length} Invoices Finalized', const Color(0xFF0F172A), Icons.point_of_sale),
              const SizedBox(width: 12),
              _buildReportKpiCard('Cost of Goods (COGS)', 'Rs ${(_totalCogsPaisa / 100).toStringAsFixed(0)}', 'Inventory Moving Cost', const Color(0xFF475569), Icons.inventory_2_outlined),
              const SizedBox(width: 12),
              _buildReportKpiCard('Gross Profit', 'Rs ${(grossProfitPaisa / 100).toStringAsFixed(0)}', '${grossMarginPercent.toStringAsFixed(1)}% Gross Margin', const Color(0xFF2563EB), Icons.trending_up),
              const SizedBox(width: 12),
              _buildReportKpiCard('Operating Expenses', 'Rs ${(_totalExpensesPaisa / 100).toStringAsFixed(0)}', '${_financialRows.where((r) => r['type'] == 'EXPENSE').length} Expenses Logged', const Color(0xFFD97706), Icons.money_off_csred_outlined),
              const SizedBox(width: 12),
              _buildReportKpiCard('Net Profit', 'Rs ${(netProfitPaisa / 100).toStringAsFixed(0)}', netProfitPaisa >= 0 ? 'Profitable' : 'Net Loss', netProfitPaisa >= 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626), Icons.account_balance),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Date Filter & Export Action Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              // Start Date
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('From: ${_dateFormat.format(_startDate)}', style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  );
                  if (picked != null) {
                    setState(() => _startDate = picked);
                    _generateFinancialReport();
                  }
                },
              ),
              const SizedBox(width: 10),
              // End Date
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text('To: ${_dateFormat.format(_endDate)}', style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  );
                  if (picked != null) {
                    setState(() => _endDate = picked);
                    _generateFinancialReport();
                  }
                },
              ),
              const SizedBox(width: 14),
              // Refresh button
              IconButton(
                tooltip: 'Recompute Analytics',
                icon: _isLoadingFinancial
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                onPressed: _isLoadingFinancial ? null : _generateFinancialReport,
              ),
              const Spacer(),
              // Export CSV
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.file_download_outlined, size: 16),
                label: const Text('Export CSV', style: TextStyle(fontSize: 12)),
                onPressed: _financialRows.isEmpty ? null : _exportFinancialCsv,
              ),
              const SizedBox(width: 10),
              // Export Excel
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.table_view_outlined, size: 16),
                label: const Text('Export Excel (.xlsx)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: _financialRows.isEmpty ? null : _exportFinancialExcel,
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Transactions Table
        Expanded(
          child: _isLoadingFinancial
              ? const Center(child: CircularProgressIndicator())
              : _financialRows.isEmpty
                  ? const Center(child: Text('No sales or expenses found in selected period', style: TextStyle(color: Color(0xFF94A3B8))))
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          color: const Color(0xFFF1F5F9),
                          child: const Row(
                            children: [
                              SizedBox(width: 140, child: Text('Date & Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 100, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              Expanded(child: Text('Reference / Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 120, child: Text('Amount (Rs)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 120, child: Text('COGS (Rs)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 120, child: Text('Net Margin (Rs)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _financialRows.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, i) {
                              final r = _financialRows[i];
                              final isSale = r['type'] == 'SALE';
                              final amount = (r['amountPaisa'] as int) / 100.0;
                              final cogs = (r['cogsPaisa'] as int) / 100.0;
                              final margin = (r['marginPaisa'] as int) / 100.0;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 140,
                                      child: Text(_dateTimeFormat.format(r['date'] as DateTime), style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isSale ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          isSale ? 'REVENUE' : 'EXPENSE',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: isSale ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        r['ref'] as String,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Rs ${amount.toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isSale ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        isSale ? 'Rs ${cogs.toStringAsFixed(2)}' : '-',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Rs ${margin.toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: margin >= 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: DEAD STOCK ANALYSIS TAB
  // ==========================================
  Widget _buildDeadStockTab() {
    final search = _deadStockSearchController.text.toLowerCase().trim();
    final filtered = _deadStockRows.where((r) {
      final p = r['part'] as Part;
      return search.isEmpty ||
          p.code.toLowerCase().contains(search) ||
          p.nameEn.toLowerCase().contains(search) ||
          (p.nameUr?.contains(search) ?? false);
    }).toList();

    final int deadCapitalPaisa = filtered.fold<int>(0, (sum, r) => sum + (r['lockedCapitalPaisa'] as int));
    final int deadUnits = filtered.fold<int>(0, (sum, r) => sum + (r['part'] as Part).currentStock);

    return Column(
      children: [
        // 4 Dead Stock KPI Summary Cards
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.white,
          child: Row(
            children: [
              _buildReportKpiCard('Total Capital Locked', 'Rs ${(deadCapitalPaisa / 100).toStringAsFixed(0)}', 'Locked in Dead Inventory', const Color(0xFFDC2626), Icons.lock_clock_outlined),
              const SizedBox(width: 14),
              _buildReportKpiCard('Dead Stock SKUs', '${filtered.length} Items', 'Zero movement in $_deadStockWindowDays days', const Color(0xFFB91C1C), Icons.warning_amber_rounded),
              const SizedBox(width: 14),
              _buildReportKpiCard('Stagnant Units', '$deadUnits units', 'Resting on Shelves', const Color(0xFFD97706), Icons.shelves),
              const SizedBox(width: 14),
              _buildReportKpiCard('Inactivity Threshold', '$_deadStockWindowDays Days', 'Configurable Window', const Color(0xFF0F172A), Icons.timelapse),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Window Selector & Actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              // Search input
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _deadStockSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search part code or name...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 14),
              // Window Chips
              const Text('Zero-Movement Window:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
              const SizedBox(width: 8),
              ...[30, 60, 90, 180].map((days) {
                final isSelected = _deadStockWindowDays == days;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text('$days Days', style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0F172A),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF334155)),
                    onSelected: (sel) {
                      if (sel) {
                        setState(() => _deadStockWindowDays = days);
                        _generateDeadStockReport();
                      }
                    },
                  ),
                );
              }),
              const Spacer(),
              // Export CSV
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.file_download_outlined, size: 16),
                label: const Text('Export CSV', style: TextStyle(fontSize: 12)),
                onPressed: filtered.isEmpty ? null : _exportDeadStockCsv,
              ),
              const SizedBox(width: 10),
              // Export Excel
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.table_view_outlined, size: 16),
                label: const Text('Export Excel (.xlsx)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: filtered.isEmpty ? null : _exportDeadStockExcel,
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Table
        Expanded(
          child: _isLoadingDeadStock
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
                  ? const Center(child: Text('No zero-movement inventory items found for this window', style: TextStyle(color: Color(0xFF94A3B8))))
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          color: const Color(0xFFF1F5F9),
                          child: const Row(
                            children: [
                              SizedBox(width: 110, child: Text('Part Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              Expanded(flex: 3, child: Text('Part Name (English / Urdu)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 100, child: Text('Rack / Shelf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 90, child: Text('Stock Qty', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 110, child: Text('Unit Cost', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 130, child: Text('Locked Capital', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 130, child: Text('Last Sold Date', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 110, child: Center(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, i) {
                              final r = filtered[i];
                              final p = r['part'] as Part;
                              final lockedCapital = (r['lockedCapitalPaisa'] as int) / 100.0;
                              final lastSale = r['lastSaleDate'] as DateTime?;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      child: Text(p.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(p.nameEn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                                          if (p.nameUr != null && p.nameUr!.isNotEmpty)
                                            Text(p.nameUr!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(p.shelfLocation ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text('${p.currentStock}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Text('Rs ${(p.avgCostPaisa / 100).toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Text(
                                        'Rs ${lockedCapital.toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Center(
                                        child: Text(
                                          lastSale != null ? _dateFormat.format(lastSale) : 'Never Sold',
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEF2F2),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: const Color(0xFFFCA5A5)),
                                          ),
                                          child: const Text(
                                            'DEAD STOCK',
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFDC2626),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: MOVEMENT VELOCITY TAB (ABC ANALYSIS)
  // ==========================================
  Widget _buildVelocityTab() {
    final search = _velocitySearchController.text.toLowerCase().trim();
    final filtered = _velocityRows.where((r) {
      final p = r['part'] as Part;
      final matchesSearch = search.isEmpty ||
          p.code.toLowerCase().contains(search) ||
          p.nameEn.toLowerCase().contains(search) ||
          (p.nameUr?.contains(search) ?? false);
      final matchesClass = _velocityFilterClass == 'ALL' || r['abcClass'] == _velocityFilterClass;
      return matchesSearch && matchesClass;
    }).toList();

    final classA = _velocityRows.where((r) => r['abcClass'] == 'A').toList();
    final classB = _velocityRows.where((r) => r['abcClass'] == 'B').toList();
    final classC = _velocityRows.where((r) => r['abcClass'] == 'C').toList();

    final classARev = classA.fold<int>(0, (sum, r) => sum + (r['revenuePaisa'] as int));
    final classBRev = classB.fold<int>(0, (sum, r) => sum + (r['revenuePaisa'] as int));
    final classCRev = classC.fold<int>(0, (sum, r) => sum + (r['revenuePaisa'] as int));
    final totalUnits = _velocityRows.fold<int>(0, (sum, r) => sum + (r['qtySold'] as int));
    final totalRev = _velocityRows.fold<int>(0, (sum, r) => sum + (r['revenuePaisa'] as int));

    return Column(
      children: [
        // 4 Velocity KPI Summary Cards
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.white,
          child: Row(
            children: [
              _buildReportKpiCard('Class A (Fast-Moving)', '${classA.length} SKUs', 'Rs ${(classARev / 100).toStringAsFixed(0)} Turnover', const Color(0xFF16A34A), Icons.bolt),
              const SizedBox(width: 14),
              _buildReportKpiCard('Class B (Moderate)', '${classB.length} SKUs', 'Rs ${(classBRev / 100).toStringAsFixed(0)} Turnover', const Color(0xFF2563EB), Icons.trending_up),
              const SizedBox(width: 14),
              _buildReportKpiCard('Class C (Slow-Moving)', '${classC.length} SKUs', 'Rs ${(classCRev / 100).toStringAsFixed(0)} Turnover', const Color(0xFFD97706), Icons.hourglass_bottom),
              const SizedBox(width: 14),
              _buildReportKpiCard('Period Volume', '$totalUnits Units', 'Rs ${(totalRev / 100).toStringAsFixed(0)} Total Sales', const Color(0xFF0F172A), Icons.speed),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Controls Bar: Search, Window, Class Filter & Exports
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              // Search input
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _velocitySearchController,
                  decoration: InputDecoration(
                    hintText: 'Search moving parts...',
                    hintStyle: const TextStyle(fontSize: 12),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              // Window Chips
              const Text('Window:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
              const SizedBox(width: 6),
              ...[30, 60, 90, 180].map((days) {
                final isSelected = _velocityWindowDays == days;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ChoiceChip(
                    label: Text('${days}D', style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0F172A),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF334155)),
                    onSelected: (sel) {
                      if (sel) {
                        setState(() => _velocityWindowDays = days);
                        _generateVelocityReport();
                      }
                    },
                  ),
                );
              }),
              const SizedBox(width: 12),
              // Class Filter Chips
              const Text('Class:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
              const SizedBox(width: 6),
              ...[
                {'id': 'ALL', 'label': 'All'},
                {'id': 'A', 'label': 'Class A'},
                {'id': 'B', 'label': 'Class B'},
                {'id': 'C', 'label': 'Class C'},
              ].map((c) {
                final isSelected = _velocityFilterClass == c['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: FilterChip(
                    label: Text(c['label']!, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0F172A),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF334155)),
                    onSelected: (sel) {
                      setState(() => _velocityFilterClass = c['id']!);
                    },
                  ),
                );
              }),
              const Spacer(),
              // Export CSV
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.file_download_outlined, size: 16),
                label: const Text('Export CSV', style: TextStyle(fontSize: 12)),
                onPressed: filtered.isEmpty ? null : _exportVelocityCsv,
              ),
              const SizedBox(width: 10),
              // Export Excel
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.table_view_outlined, size: 16),
                label: const Text('Export Excel (.xlsx)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                onPressed: filtered.isEmpty ? null : _exportVelocityExcel,
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // Table
        Expanded(
          child: _isLoadingVelocity
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
                  ? const Center(child: Text('No moving inventory items match current filter criteria', style: TextStyle(color: Color(0xFF94A3B8))))
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          color: const Color(0xFFF1F5F9),
                          child: const Row(
                            children: [
                              SizedBox(width: 110, child: Text('Part Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              Expanded(flex: 3, child: Text('Part Name (English / Urdu)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 90, child: Text('Rack / Shelf', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 80, child: Text('Stock', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 90, child: Text('Sold Qty', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 70, child: Text('Invoices', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 120, child: Text('Revenue (Rs)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 120, child: Text('Last Sold Date', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569)))),
                              SizedBox(width: 130, child: Center(child: Text('ABC Class', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            itemBuilder: (context, i) {
                              final r = filtered[i];
                              final p = r['part'] as Part;
                              final lastSale = r['lastSaleDate'] as DateTime?;
                              final revenue = (r['revenuePaisa'] as int) / 100.0;
                              final badgeColor = r['badgeColor'] as Color;
                              final badgeBgColor = r['badgeBgColor'] as Color;
                              final abcLabel = r['abcLabel'] as String;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      child: Text(p.code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(p.nameEn, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                                          if (p.nameUr != null && p.nameUr!.isNotEmpty)
                                            Text(p.nameUr!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text(p.shelfLocation ?? '-', style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text('${p.currentStock}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text('${r['qtySold']}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text('${r['invoiceCount']}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Rs ${revenue.toStringAsFixed(2)}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: Center(
                                        child: Text(
                                          lastSale != null ? _dateFormat.format(lastSale) : 'Never',
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: badgeBgColor,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                                          ),
                                          child: Text(
                                            abcLabel,
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: badgeColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildReportKpiCard(String title, String value, String subtitle, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
