import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../core/db/app_database.dart';
import '../../core/widgets/erp_page_header.dart';
import '../inventory/parts_master_screen.dart'; // contains dbProvider
import '../khata/customer_dialog.dart';

class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> {
  Route? _selectedRoute;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openRouteDialog([Route? route]) async {
    final nameCtrl = TextEditingController(text: route?.name ?? '');
    final cityCtrl = TextEditingController(text: route?.city ?? 'Kot Samba');
    final descCtrl = TextEditingController(text: route?.description ?? '');
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(route == null ? 'Add New Route / Area' : 'Edit Route: ${route.name}'),
        content: SizedBox(
          width: 420,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Route / Territory Name *',
                    hintText: 'e.g. Kot Samba City, Bagobhar Road, Sadiqabad Sector',
                    prefixIcon: Icon(Icons.route_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Route name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'City / Region *',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'City is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Description / Landmarks',
                    hintText: 'Optional notes on market coverage',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final db = ref.read(dbProvider);
              final name = nameCtrl.text.trim();
              final city = cityCtrl.text.trim();
              final desc = descCtrl.text.trim();

              if (route == null) {
                await db.into(db.routes).insert(
                  RoutesCompanion(
                    name: drift.Value(name),
                    city: drift.Value(city),
                    description: drift.Value(desc.isEmpty ? null : desc),
                  ),
                );
              } else {
                await (db.update(db.routes)..where((t) => t.id.equals(route.id))).write(
                  RoutesCompanion(
                    name: drift.Value(name),
                    city: drift.Value(city),
                    description: drift.Value(desc.isEmpty ? null : desc),
                  ),
                );
              }
              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            child: Text(route == null ? 'Create Route' : 'Save Changes'),
          ),
        ],
      ),
    );

    if (saved == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _assignSalesmanDialog(Route route, List<Employee> salesmen) async {
    Employee? currentSalesman = salesmen.where((e) => e.assignedRouteId == route.id).firstOrNull;
    Employee? selected = currentSalesman;

    final updated = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Assign Salesman (DSO) to ${route.name}'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select an employee who will manage recovery and order booking in this territory:'),
                const SizedBox(height: 16),
                DropdownButtonFormField<Employee?>(
                  decoration: const InputDecoration(
                    labelText: 'Salesman / DSO',
                    prefixIcon: Icon(Icons.person_pin_outlined),
                    border: OutlineInputBorder(),
                  ),
                  value: selected,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('No Salesman Assigned')),
                    ...salesmen.map((e) => DropdownMenuItem(value: e, child: Text('${e.name} (${e.phone ?? "No Phone"})'))),
                  ],
                  onChanged: (v) => setDialogState(() => selected = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
              onPressed: () async {
                final db = ref.read(dbProvider);

                await db.transaction(() async {
                  // 1. Unassign previous salesman from this route
                  if (currentSalesman != null && (selected == null || selected!.id != currentSalesman.id)) {
                    await (db.update(db.employees)..where((t) => t.id.equals(currentSalesman.id))).write(
                      const EmployeesCompanion(assignedRouteId: drift.Value(null)),
                    );
                  }

                  // 2. Assign new salesman to this route
                  if (selected != null) {
                    await (db.update(db.employees)..where((t) => t.id.equals(selected!.id))).write(
                      EmployeesCompanion(assignedRouteId: drift.Value(route.id)),
                    );
                  }
                });

                if (ctx.mounted) Navigator.pop(ctx, true);
              },
              child: const Text('Update Assignment'),
            ),
          ],
        ),
      ),
    );

    if (updated == true && mounted) {
      setState(() {});
    }
  }

  Future<void> _deleteRouteDialog(Route route, List<Customer> routeCustomers, Employee? currentSalesman) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
            const SizedBox(width: 8),
            Expanded(child: Text('Delete Route: ${route.name}')),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to permanently delete the route "${route.name}" (${route.city})?',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (routeCustomers.isNotEmpty || currentSalesman != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cascade Unlink Notice:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF991B1B)),
                      ),
                      const SizedBox(height: 4),
                      if (currentSalesman != null)
                        Text(
                          '• Salesman "${currentSalesman.name}" will be unassigned.',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D)),
                        ),
                      if (routeCustomers.isNotEmpty)
                        Text(
                          '• ${routeCustomers.length} B2B workshop(s) will have their route set to None.',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D)),
                        ),
                      const SizedBox(height: 4),
                      const Text(
                        'Past sales records will be safely preserved.',
                        style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF991B1B)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final db = ref.read(dbProvider);
              await db.transaction(() async {
                // 1. Unassign salesman
                await (db.update(db.employees)..where((t) => t.assignedRouteId.equals(route.id))).write(
                  const EmployeesCompanion(assignedRouteId: drift.Value(null)),
                );
                // 2. Unassign customers
                await (db.update(db.customers)..where((t) => t.routeId.equals(route.id))).write(
                  const CustomersCompanion(routeId: drift.Value(null)),
                );
                // 3. Clear sales route association to prevent FK constraint failures
                await (db.update(db.sales)..where((t) => t.routeId.equals(route.id))).write(
                  const SalesCompanion(routeId: drift.Value(null)),
                );
                // 4. Delete the route
                await (db.delete(db.routes)..where((t) => t.id.equals(route.id))).go();
              });

              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            child: const Text('Delete Route'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        if (_selectedRoute?.id == route.id) {
          _selectedRoute = null;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Route "${route.name}" deleted successfully'),
          backgroundColor: const Color(0xFF0F172A),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: StreamBuilder<List<Route>>(
        stream: db.select(db.routes).watch(),
        builder: (context, routeSnap) {
          if (!routeSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final routes = routeSnap.data!;
          final search = _searchController.text.toLowerCase().trim();
          final filteredRoutes = routes.where((r) {
            return search.isEmpty ||
                r.name.toLowerCase().contains(search) ||
                r.city.toLowerCase().contains(search) ||
                (r.description?.toLowerCase().contains(search) ?? false);
          }).toList();

          if (_selectedRoute != null) {
            _selectedRoute = routes.where((r) => r.id == _selectedRoute!.id).firstOrNull;
          }

          return StreamBuilder<List<Employee>>(
            stream: (db.select(db.employees)..where((t) => t.role.equals('SALESMAN'))).watch(),
            builder: (context, empSnap) {
              final salesmen = empSnap.data ?? [];

              return StreamBuilder<List<Customer>>(
                stream: db.select(db.customers).watch(),
                builder: (context, custSnap) {
                  final customers = custSnap.data ?? [];

                  // Calculate high-level KPIs
                  final totalRoutes = routes.length;
                  final totalAssignedShops = customers.where((c) => c.routeId != null).length;
                  final assignedSalesmenCount = salesmen.where((s) => s.assignedRouteId != null).length;
                  final totalReceivablesPaisa = customers.fold<int>(0, (sum, c) => sum + (c.currentBalancePaisa > 0 ? c.currentBalancePaisa : 0));

                  return Column(
                    children: [
                      // Unified ERP Header Bar
                      ErpPageHeader(
                        icon: Icons.alt_route_rounded,
                        title: 'Area & Route Distribution',
                        subtitle: 'Territory management, B2B shop allotments & salesman (DSO) assignments',
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                          label: const Text('Add Route', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          onPressed: () => _openRouteDialog(),
                        ),
                      ),

                      // Top KPI Summary Cards
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        color: Colors.white,
                        child: Row(
                          children: [
                            _buildKpiCard('Total Routes', '$totalRoutes', 'Covered Territories', const Color(0xFF0F172A), Icons.map_outlined),
                            const SizedBox(width: 14),
                            _buildKpiCard('Mapped B2B Shops', '$totalAssignedShops', 'Registered Workshops', const Color(0xFF16A34A), Icons.storefront_outlined),
                            const SizedBox(width: 14),
                            _buildKpiCard('Active Salesmen', '$assignedSalesmenCount / ${salesmen.length}', 'Assigned DSOs', const Color(0xFF2563EB), Icons.badge_outlined),
                            const SizedBox(width: 14),
                            _buildKpiCard('Route Receivables', 'Rs ${(totalReceivablesPaisa / 100).toStringAsFixed(0)}', 'Total Outstanding', const Color(0xFFDC2626), Icons.account_balance_wallet_outlined),
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: Color(0xFFE2E8F0)),

                      // Main Content: Split Master-Detail
                      Expanded(
                        child: Row(
                          children: [
                            // Left Column: Route List
                            SizedBox(
                              width: 380,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
                                ),
                                child: Column(
                                  children: [
                                    // Search Bar
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText: 'Search routes, cities, landmarks...',
                                          hintStyle: const TextStyle(fontSize: 12),
                                          prefixIcon: const Icon(Icons.search, size: 20),
                                          suffixIcon: _searchController.text.isNotEmpty
                                              ? IconButton(
                                                  icon: const Icon(Icons.clear, size: 16),
                                                  onPressed: () => setState(() => _searchController.clear()),
                                                )
                                              : null,
                                          isDense: true,
                                          filled: true,
                                          fillColor: const Color(0xFFF8FAFC),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                                          ),
                                        ),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),

                                    // List Count Bar
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      color: const Color(0xFFF1F5F9),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${filteredRoutes.length} Territories', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                                          const Text('Shops / Due', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                                        ],
                                      ),
                                    ),

                                    // Route List View
                                    Expanded(
                                      child: filteredRoutes.isEmpty
                                          ? const Center(child: Text('No routes found', style: TextStyle(color: Color(0xFF94A3B8))))
                                          : ListView.separated(
                                              itemCount: filteredRoutes.length,
                                              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                              itemBuilder: (context, index) {
                                                final r = filteredRoutes[index];
                                                final isSelected = _selectedRoute?.id == r.id;
                                                final routeCustomers = customers.where((c) => c.routeId == r.id).toList();
                                                final salesman = salesmen.where((s) => s.assignedRouteId == r.id).firstOrNull;
                                                final routeDuePaisa = routeCustomers.fold<int>(0, (sum, c) => sum + (c.currentBalancePaisa > 0 ? c.currentBalancePaisa : 0));

                                                return ListTile(
                                                  selected: isSelected,
                                                  selectedTileColor: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  leading: CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                                    child: Icon(Icons.route, size: 18, color: isSelected ? Colors.white : const Color(0xFF334155)),
                                                  ),
                                                  title: Text(
                                                    r.name,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'City: ${r.city} • ${salesman != null ? "DSO: ${salesman.name}" : "Unassigned"}',
                                                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                                      ),
                                                      if (r.description != null && r.description!.isNotEmpty)
                                                        Text(
                                                          r.description!,
                                                          style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                    ],
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${routeCustomers.length} shops',
                                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                                      ),
                                                      Text(
                                                        'Rs ${(routeDuePaisa / 100).toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                          color: routeDuePaisa > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () => setState(() => _selectedRoute = r),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Right Column: Territory Detail View
                            Expanded(
                              child: _selectedRoute == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.map_outlined, size: 64, color: Color(0xFFCBD5E1)),
                                          SizedBox(height: 12),
                                          Text('Select a Route / Territory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                                          SizedBox(height: 4),
                                          Text('View mapped B2B workshops, credit limits, and assign salesmen', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                                        ],
                                      ),
                                    )
                                  : _buildRouteDetail(_selectedRoute!, salesmen, customers),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRouteDetail(Route route, List<Employee> salesmen, List<Customer> allCustomers) {
    final routeCustomers = allCustomers.where((c) => c.routeId == route.id).toList();
    final salesman = salesmen.where((s) => s.assignedRouteId == route.id).firstOrNull;
    final totalDuePaisa = routeCustomers.fold<int>(0, (sum, c) => sum + (c.currentBalancePaisa > 0 ? c.currentBalancePaisa : 0));
    final totalLimitPaisa = routeCustomers.fold<int>(0, (sum, c) => sum + (c.creditLimitPaisa ?? 0));

    return Column(
      children: [
        // Route Information Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              route.name,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFF93C5FD)),
                              ),
                              child: Text(
                                route.city,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.badge_outlined, size: 16, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(
                              salesman != null ? 'Assigned Salesman: ${salesman.name} (${salesman.phone ?? "N/A"})' : 'No Salesman Assigned',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: salesman != null ? const Color(0xFF0F172A) : const Color(0xFFDC2626),
                              ),
                            ),
                            if (route.description != null) ...[
                              const SizedBox(width: 16),
                              const Icon(Icons.info_outline, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Text(route.description!, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Route Balances
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Route Outstanding Debt', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                        Text(
                          'Rs ${(totalDuePaisa / 100).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: totalDuePaisa > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                          ),
                        ),
                        Text('Total Credit Limit: Rs ${(totalLimitPaisa / 100).toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.person_add_alt_outlined, size: 16),
                    label: Text(salesman == null ? 'Assign Salesman (DSO)' : 'Reassign Salesman', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () => _assignSalesmanDialog(route, salesmen),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit Route Info', style: TextStyle(fontSize: 12)),
                    onPressed: () => _openRouteDialog(route),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.add_business_outlined, size: 16),
                    label: const Text('Add B2B Shop to Route', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      await showDialog<Customer>(
                        context: context,
                        builder: (_) => const CustomerFormDialog(),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFDC2626)),
                    label: const Text('Delete Route', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
                    onPressed: () => _deleteRouteDialog(route, routeCustomers, salesman),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Mapped Workshops Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          color: const Color(0xFFF1F5F9),
          child: Row(
            children: [
              Text(
                'Mapped B2B Workshops & Retailers (${routeCustomers.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569)),
              ),
              const Spacer(),
              const Text('Credit Limit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))),
              const SizedBox(width: 60),
              const Text('Current Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF475569))),
            ],
          ),
        ),

        // Table Content
        Expanded(
          child: routeCustomers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.storefront_outlined, size: 48, color: Color(0xFFCBD5E1)),
                      const SizedBox(height: 8),
                      Text('No shops mapped to "${route.name}" yet', style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('Use "Add B2B Shop to Route" above to register workshops in this area', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: routeCustomers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, i) {
                    final cust = routeCustomers[i];
                    final bal = cust.currentBalancePaisa / 100.0;
                    final limit = (cust.creditLimitPaisa ?? 0) / 100.0;
                    final isOverLimit = limit > 0 && bal > limit;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      color: i % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFFF1F5F9),
                            child: Text(
                              cust.name.isNotEmpty ? cust.name[0].toUpperCase() : '?',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      cust.shopName != null && cust.shopName!.isNotEmpty ? cust.shopName! : cust.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: cust.customerType == 'WHOLESALE' ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        cust.customerType,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: cust.customerType == 'WHOLESALE' ? const Color(0xFF1D4ED8) : const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Contact: ${cust.name} • ${cust.phone ?? "No Phone"} • ${cust.address ?? "No Address"}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              limit > 0 ? 'Rs ${limit.toStringAsFixed(0)}' : 'No Limit',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rs ${bal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: bal > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                                  ),
                                ),
                                if (isOverLimit)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.red.shade200),
                                    ),
                                    child: const Text('OVER LIMIT', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold)),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            tooltip: 'Edit Customer',
                            onPressed: () async {
                              await showDialog<Customer>(
                                context: context,
                                builder: (_) => CustomerFormDialog(customer: cust),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, Color color, IconData icon) {
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
