import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arham_autos/main.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Arham Autos Phase 1'), findsOneWidget);
  });
}
