# Sprint Implementation Plan & Codebase Audit Status

**Project:** Arham Autos POS & Management System  
**Version:** 2.2.0 (Fully Synchronized with Complete Codebase Implementation & Monday.com Sprint Board)  
**Project Owner:** Umer Asghar  
**Technology Partner:** AlphaSync Systems (Private) Limited  

---

## 1. Sprint Overview & Verified Audit Summary

| Sprint | Sprint Focus | Done | Working On It | Not Started | Owner |
| :--- | :--- | :---: | :---: | :---: | :--- |
| **Sprint 1** | Core Architecture, Encrypted Database (Drift/SQLCipher) & Auth | 4 | 0 | 0 | Umer Asghar |
| **Sprint 2** | Parts Catalog, Dual Pricing, Stock Adjustments, Barcode Studio & GRN | 4 | 0 | 0 | Umer Asghar |
| **Sprint 3** | Executive Dashboard, POS Counter Billing, Khata Ledgers & Returns | 4 | 0 | 0 | Umer Asghar |
| **Sprint 4** | Accounts/GL, Employees/HR, Area/Route Management & Core Reports | 4 | 0 | 0 | Umer Asghar |
| **Sprint 5** | Bilingual Localization (Urdu RTL), Navigation, User CRUD & Backups | 4 | 0 | 0 | Umer Asghar |
| **Sprint 6** | UI Refinements, Edge-Case Safeguards & Priority 0 POS/Khata Features | 7 | 0 | 0 | Umer Asghar |
| **Sprint 7** | Priority 1 Enhancements (Dual-Print & Dead Stock) & Final Release QA | 3 | 0 | 0 | Umer Asghar |
| **TOTAL** | **30 Mapped Engineering Tasks across 7 Sprints** | **30** | **0** | **0** | **Umer Asghar** |

---

## 2. Granular Sprint Breakdown (Synchronized with Codebase Implementation)

### Sprint 1: Core Architecture, Encrypted DB & Auth
1. **[DONE]** **Flutter Project Scaffolding & Clean Architecture Setup** (`lib/main.dart`, `lib/app_shell.dart`, `pubspec.yaml`)
2. **[DONE]** **Encrypted Local SQLite Database (Drift ORM + SQLCipher AES-256)** (`lib/core/db/app_database.dart`, `lib/core/db/connection/connection_native.dart`)
3. **[DONE]** **First-Run Setup Wizard & 16-Digit Master Security Key Generation** (`lib/core/crypto/master_key.dart`, `lib/features/setup_wizard/setup_screen.dart`, `lib/main.dart`)
4. **[DONE]** **PIN/Password Authentication Gate, Idle Lock & 2-Tier RBAC Guards** (`lib/features/auth/login_screen.dart`, `lib/core/security/idle_lock_service.dart`, `lib/app_shell.dart`)

### Sprint 2: Parts Catalog, Barcodes & Purchases (GRN)
5. **[DONE]** **Parts Catalog CRUD with Dual B2C/B2B Pricing & Bilingual Titles** (`lib/features/inventory/parts_master_screen.dart`, `lib/features/inventory/part_form_dialog.dart`)
6. **[DONE]** **Manual Stock Adjustments (with Audit Reasons) & Low-Stock Alert Engine (`<= 10`)** (`lib/features/inventory/stock_adjustment_dialog.dart`, `lib/features/dashboard/executive_dashboard_screen.dart`)
7. **[DONE]** **Custom Barcode Studio (Code-128 Label Generator & Print Layout)** (`lib/features/barcode_studio/barcode_studio_screen.dart`, integrated with top bar button and per-row button in `lib/features/inventory/parts_master_screen.dart`)
8. **[DONE]** **Supplier Master & Purchases / GRN Workflow with Moving Average Costing** (`lib/features/purchases/grn_screen.dart`, `lib/features/suppliers/supplier_dialog.dart`, `lib/core/db/tables/all_tables.dart`)

### Sprint 3: POS Billing, Khata Ledgers & Returns Workflow
9. **[DONE]** **Executive Dashboard (4 KPI Cards, Sales Trends, Recent 5 Sales & Low-Stock Table)** (`lib/features/dashboard/executive_dashboard_screen.dart`)
10. **[DONE]** **POS Counter Billing Terminal with Auto-Focus Barcode & Dual-Price Switching** (`lib/features/pos/pos_screen.dart`)
11. **[DONE]** **Customer & Supplier Khata Double-Entry Ledgers & Balance Carryover** (`lib/features/khata/khata_screen.dart`, `lib/features/khata/customer_dialog.dart`, `lib/features/khata/khata_statement_printer.dart`)
12. **[DONE]** **Returns & Claims 2-Step Approval Workflow (Operator Draft & Manager Approve)** (`lib/features/returns/returns_screen.dart`)

### Sprint 4: Accounts/GL, Employees/HR, Routes & Core Reports
13. **[DONE]** **Operational Expense Journal & General Ledger Chart of Accounts (`GlScreen`)** (`lib/features/expenses/expenses_screen.dart`)
14. **[DONE]** **Employee Directory & HR Payroll / Salary Tracker (`HrScreen`)** (`lib/features/employees/employees_screen.dart`, `test/employees_payroll_test.dart`)
15. **[DONE]** **Area & Route Distribution Module with Salesman/DSO Territory Assignment** (`lib/features/routes/routes_screen.dart`, `lib/app_shell.dart`)
16. **[DONE]** **Core Financial Reports Engine (Sales, COGS, Margins) with Excel & CSV Exports** (`lib/features/reports/reports_screen.dart`)

### Sprint 5: Urdu RTL Localization, Backups & Security
17. **[DONE]** **Full English & Urdu RTL Localization with Google Noto Nastaliq Font** (`lib/main.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_ur.arb`, `lib/l10n/app_localizations.dart`, `lib/app_shell.dart`)
18. **[DONE]** **Persistent 11-Item Sidebar Navigation Order & Legacy Import Removal** (`lib/app_shell.dart`)
19. **[DONE]** **Settings User Management CRUD & SQLite Persistence Hardening** (`lib/features/settings/settings_screen.dart`)
20. **[DONE]** **Encrypted `.bak` Backups, Audit Logs Viewer, Master Key Wipe & About Modal** (`lib/features/settings/settings_screen.dart`, `lib/features/about/about_dialog_widget.dart`)

### Sprint 6: UI Polish, Edge Cases & Priority 0 Features
21. **[DONE]** **Login Screen UI Refactor (Floating Card Design per Reference Image)** (`lib/features/auth/login_screen.dart`)
22. **[DONE]** **Customer Credit Limit Verification & Manager PIN Step-Up Modal (Edge Case)** (`lib/features/pos/pos_screen.dart`)
23. **[DONE]** **Returns Inventory Disposition Triage: `Sellable` vs. `Defective Claim Pool` (Edge Case)** (`lib/features/returns/returns_screen.dart`)
24. **[DONE]** **Master Security Key Printable Recovery Certificate in Setup Wizard (Edge Case)** (`lib/features/setup_wizard/setup_screen.dart`)
25. **[DONE]** **Invoice Immutability Enforcement (Read-Only Post-Print Lock)** (`lib/features/pos/pos_screen.dart`)
26. **[DONE]** **[Priority 0] Parked / Suspended Carts (`F6` Hold / `F7` Recall + Top Bar Badge)** (`lib/features/pos/pos_screen.dart`, `lib/core/db/tables/all_tables.dart`)
27. **[DONE]** **[Priority 0] Aging Accounts Receivable Summary (`0–30`, `31–60`, `60+ Days Overdue` Tabs)** (`lib/features/khata/khata_screen.dart`, `lib/features/khata/khata_statement_printer.dart`)

### Sprint 7: Priority 1 Enhancements (Dual-Print & Dead Stock) & QA
28. **[DONE]** **[Priority 1] Optional Dual-Print Engine (2-Up Half-Page A5 Laser + 58/80mm Thermal Slip)** (`lib/features/pos/invoice_printer.dart`, `lib/features/settings/settings_screen.dart`)
29. **[DONE]** **[Priority 1] Dead Stock & Movement Velocity Analytics (90-Day Zero-Movement Report)** (`lib/features/reports/reports_screen.dart`)
30. **[DONE]** **Final Desktop Scrollbar Polish (`ScrollbarThemeData` 8px), 50k SKU Stress Testing & Windows `.exe` Packaging** (`lib/main.dart`, `test/phase6_tests.dart`)
