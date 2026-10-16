# Arham Autos POS & ERP Suite (v3.0.0)

> **Enterprise Desktop Point-of-Sale & Resource Planning System for Motorcycle Spare Parts, Wholesale Distribution & Retail Operations.**  
> Developed by **AlphaSync Systems (Private) Limited**

---

## 📌 Executive Overview

**Arham Autos POS & ERP Suite** is an enterprise-grade, offline-first desktop software application tailored specifically for automotive spare parts dealerships, retail counters, and wholesale distribution networks. Built on Flutter Desktop (Windows x64) with high-performance encrypted SQLite (`sqlite3mc` / SQLCipher via Drift ORM), it delivers lightning-fast transactional throughput (`<10ms` lookup time for 50,000+ SKU inventories), rock-solid double-entry ledger bookkeeping, and hardware-accelerated dual-engine printing.

---

## 🚀 Key Modules & System Features

### 1. 📊 Executive Dashboard (Manager Role)

- **Top 4 KPI Metrics:** Total Inventory Asset Valuation, Today's Gross Profit, Today's Net Sales, and Active Low Stock Threshold Alerts.
- **Visual Analytics:** Weekly & monthly sales performance trends.
- **Operational Feeds:** Recent 5 finalized bills with one-click re-print and immediate low-stock re-order triggers.

### 2. ⚡ POS Billing Terminal (High-Speed & Keyboard-First)

- **Zero-Latency Checkout:** Automatic focus on barcode and code search field with sub-millisecond keyboard navigation.
- **Dual-Pricing Engine:** Automatically switches line items between **Retail (B2C)** and **Wholesale (B2B)** tiers based on customer selection.
- **Customer Credit Guard:** Evaluates ledger balances in real time; requires Manager PIN step-up authorization if a sale exceeds credit limits.
- **Parked Carts (`F6` / `F7`):** Suspend active carts (`F6`) with reference notes to serve secondary customers, and instantly recall (`F7`) without losing bill state.
- **Dual-Print Engine:** Toggle seamlessly between standard **2-Up Half-Page (A5) Laser Slips** and high-speed **58mm / 80mm Continuous Thermal Receipts**.
- **Invoice Immutability:** Finalized transactions are cryptographically locked against post-facto tampering.

### 3. 📦 Inventory & Parts Master

- Handles **50,000+ Spare Parts** with code, bilingual English/Urdu descriptions, bike models, OEM brand tags, shelf/rack bin locations, and min/max stock thresholds.
- **Barcode Studio:** Built-in sticker design and generation for custom barcode label printing.

### 4. 🚚 Purchases & Goods Received Notes (GRN)

- Supplier procurement with real-time **Weighted Average Cost (WAC)** inventory revaluation.
- Auto-posts payable liabilities to the Supplier Ledger upon receiving goods.

### 5. 📒 Customer & Supplier Khata (Ledgers)

- Complete double-entry ledger tracking (`INVOICE_DEBIT`, `PAYMENT_CREDIT`, `PURCHASE_PAYABLE`, `RETURN_CREDIT`).
- **Priority 0 Aging Accounts Receivable:** Automated FIFO debt aging across 0–30 days, 31–60 days, and 60+ days overdue buckets.
- Voucher generation for field recovery payments.

### 6. 🔄 Returns & Customer Claims

- Operator-initiated return drafts linked directly to original invoices.
- Manager triage workflow with inventory disposition selector (**Return to Sellable Stock** vs. **Move to Supplier Claim / Defective**).
- Automatic customer khata balance and cash drawer adjustments.

### 7. 📑 General Ledger & Chart of Accounts

- Daily expense journal categorized across Operational, Logistics, and Administrative overheads.
- Real-time Balance Sheet: Current Assets (Cash-in-Hand, Inventory Valuation, Receivables), Liabilities (Supplier Payables), and Retained Earnings.

### 8. 👥 Employees & HR Payroll

- Staff profiling for Salesmen, Cashiers, Shop Attendants, and Delivery Bookers.
- Monthly salary disbursement tracker with audit log recording.

### 9. 🗺️ Routes & Distribution Logistics

- Territorial route mapping for field order bookers and distribution delivery runs.
- Tracks customer balances and booking volumes by geographic sector.

### 10. 📈 Reports & Business Intelligence

- Comprehensive Financial Summary with customizable date ranges (Daily, Weekly, Monthly, Custom).
- **Dead Stock Analyzer:** Flags inventory with 90-day zero sales velocity to release trapped working capital.
- **ABC Movement Velocity:** Pareto classification (Class A fast-movers, Class B regular, Class C slow-movers).
- **Dual Export:** Instant export to formatted **Microsoft Excel (`.xlsx`)** and standard CSV (`.csv`).

### 11. 🛡️ Settings, Security & Recovery

- **Role-Based Access Control (RBAC):** Strict separation between Manager (Full ERP) and Operator (POS & Lookup only).
- **Immutable Audit Trail:** System events (price overrides, logins, voids, user resets, exports) logged with timestamps and user IDs.
- **Enterprise Disaster Recovery:** Automated 16-character master security key generation, printable PDF recovery certificates, and AES-256 database backup engine.

---

## 🔐 Default Production Credentials

The system comes pre-initialized with default credentials for administrative and counter operations. It is strongly recommended to reset passwords after first login:

| Role | Username | PIN (Quick-Auth) | Password | Access Level |
| :--- | :--- | :--- | :--- | :--- |
| **Manager (Admin)** | `admin_arham` | `1122` | `admin123` | Full Administrative & ERP Access |
| **Operator (Cashier)** | `cashier_usman` | `3344` | `cashier123` | POS Terminal, Catalog & Return Drafts |

---

## ⌨️ POS Keyboard Shortcuts

| Shortcut | Function | Description |
| :---: | :--- | :--- |
| `F1` | Help / Shortcuts | Opens keyboard shortcut legend |
| `F2` | Quick Search | Focuses the parts catalog and barcode input |
| `F3` | Customer Select | Opens customer khata search dialog |
| `F4` | Payment Mode | Toggles Cash / Credit / Bank Transfer |
| `F6` | Hold Bill | Suspends active cart into parked carts storage |
| `F7` | Recall Bill | Opens parked carts queue to restore a held bill |
| `F8` | Apply Discount | Focuses bill discount input field |
| `F10` | Finalize / Print | Finalizes invoice and triggers dual-print engine |
| `ESC` | Clear / Cancel | Clears current input or dismisses open modals |

---

## 🛠️ Build & Development Commands

### Prerequisites

- Windows 10/11 64-bit
- Flutter SDK (v3.24.x or higher)
- Visual Studio 2022 (with "Desktop development with C++" workload)
- Inno Setup 6 (for building installer packages)

### Compilation Steps

1. **Fetch Dependencies:**

   ```powershell
   flutter pub get
   ```

2. **Generate Drift Database Schema:**

   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run Code Analysis & Tests:**

   ```powershell
   flutter analyze --no-fatal-infos
   flutter test
   ```

4. **Build Windows Release Binary:**

   ```powershell
   flutter build windows --release
   ```

5. **Compile Production Installer (`.exe`):**

   ```powershell
   & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer.iss
   ```

The compiled setup installer will be generated in:
`Output\Arham_Autos_POS_Setup_v3.0.0.exe`

---

## 📞 Support & Software Licensing

Arham Autos POS & Management Suite is designed, engineered, and supported by **AlphaSync Systems (Private) Limited**.

- **Helpline / WhatsApp:** `03140486627`
- **Official Website:** [https://alphasync.codes](https://alphasync.codes)
- **Technical Support:** `info@alphasync.codes`
- **Headquarters:** Rahim Yar Khan / Khan Pur, Punjab, Pakistan

---
*Copyright © 2026 AlphaSync Systems (Private) Limited. All rights reserved.*
 API reference.
