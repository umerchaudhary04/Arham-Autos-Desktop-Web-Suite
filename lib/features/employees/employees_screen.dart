import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/db/app_database.dart';
import '../inventory/parts_master_screen.dart'; // dbProvider

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  void _addEmployeeDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController(text: 'SALESMAN');
    final salaryController = TextEditingController(text: '0');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Role (SALESMAN, CASHIER)')),
            TextField(controller: salaryController, decoration: const InputDecoration(labelText: 'Monthly Salary (Rs)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final db = ref.read(dbProvider);
              final nav = Navigator.of(context);
              await db.into(db.employees).insert(
                EmployeesCompanion(
                  name: drift.Value(nameController.text),
                  role: drift.Value(roleController.text),
                  monthlySalaryPaisa: drift.Value((double.parse(salaryController.text) * 100).toInt()),
                )
              );
              if (mounted) nav.pop();
            },
            child: const Text('Save')
          )
        ],
      )
    );
  }

  void _addRouteDialog() {
    final nameController = TextEditingController();
    final cityController = TextEditingController(text: 'Kot Samba');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Route'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Route Name')),
            TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final db = ref.read(dbProvider);
              final nav = Navigator.of(context);
              await db.into(db.routes).insert(
                RoutesCompanion(
                  name: drift.Value(nameController.text),
                  city: drift.Value(cityController.text),
                )
              );
              if (mounted) nav.pop();
            },
            child: const Text('Save')
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(dbProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Employees & Routes')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(title: const Text('Employees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), trailing: IconButton(icon: const Icon(Icons.add), onPressed: _addEmployeeDialog)),
                Expanded(
                  child: StreamBuilder<List<Employee>>(
                    stream: db.select(db.employees).watch(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final e = snapshot.data![index];
                          return ListTile(
                            title: Text(e.name),
                            subtitle: Text('${e.role} | Salary: Rs${e.monthlySalaryPaisa / 100}'),
                            trailing: e.assignedRouteId != null ? Text('Route ID: ${e.assignedRouteId}') : const Text('No Route'),
                          );
                        },
                      );
                    }
                  ),
                )
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                ListTile(title: const Text('Routes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), trailing: IconButton(icon: const Icon(Icons.add), onPressed: _addRouteDialog)),
                Expanded(
                  child: StreamBuilder<List<Route>>(
                    stream: db.select(db.routes).watch(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final r = snapshot.data![index];
                          return ListTile(
                            title: Text(r.name),
                            subtitle: Text(r.city),
                          );
                        },
                      );
                    }
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
