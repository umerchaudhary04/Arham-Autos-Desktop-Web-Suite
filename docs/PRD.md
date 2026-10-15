# Product Requirements Document (PRD)

**Project Name:** Arham Autos POS & Inventory Management System  
**Product Version:** 2.0.0 (Updated with Priority 0 & Priority 1 Enhancements)  
**Client:** Arham Autos (Bagobhar Road, Kotsmaba | Ph: 0300-6748837)  
**Technology Partner:** AlphaSync Systems (Private) Limited (`info@alphasync.codes` | `03140486627`)  
**UI/UX Design:** Antigravity UI/UX Team  
**Document Status:** Final Approved  

---

## 1. Product Vision & Goals

The Arham Autos POS & ERP system is an offline-first retail and wholesale management platform designed for motorcycle spare parts businesses. It eliminates manual pricing errors, enforces credit risk controls across B2B customer ledgers, streamlines regional delivery routes, protects business data through AES-256 encrypted local storage, and provides commercial-grade counter efficiency (parked carts, receivable aging analysis, dual-mode printing, and dead-stock velocity analytics).

---

## 2. User Roles & Permission Matrix

The application enforces a strict two-tier Role-Based Access Control (RBAC) model:

| Module / Action | Operator (Cashier) | Manager (Admin) |
| :--- | :---: | :---: |
| **Executive Dashboard (Financials, Gross Profit, Total Stock Value)** | Restricted | Full Access |
| **Operator Shift Dashboard (Personal Daily Sales Count)** | Full Access | Full Access |
| **Stock Shortage Alerts (Threshold <= 10 Units)** | View Only | Full Access |
| **POS Billing (Counter Sales, Invoice Generation, Printing)** | Full Access | Full Access |
| **Parked / Suspended Carts (`F6` Hold / `F7` Recall)** | Full Access | Full Access |
| **Customer Credit Limit Override** | Blocked | Authorization via PIN |
| **Parts Catalog (Search & Stock Inquiries)** | View Only | Full Access |
| **Parts Catalog (Add, Edit, Price Update, Manual Stock Adjust)** | Restricted | Full Access |
| **Barcode Studio (Generate & Print Sticker Labels)** | Restricted | Full Access |
| **Purchases & GRN (Goods Receipt Note)** | Restricted | Full Access |
| **Customer & Supplier Khata (Ledgers, Statements & Aging Tabs)** | Restricted | Full Access |
| **Returns & Claims (Draft Return Request)** | Can Initiate | Can Initiate |
| **Returns & Claims (Approve Claim, Triage Stock & Release Funds)** | Restricted | Full Access |
| **Returns & Claims (Direct Override Return without Draft)** | Restricted | Full Access |
| **Expense Journal & Employee Payroll** | Restricted | Full Access |
| **Route & Area Allotment for Salesmen** | Restricted | Full Access |
| **Reports Engine (Sales, COGS, Margins, Dead Stock, Excel/CSV Export)** | Restricted | Full Access |
| **Settings (User Management, Auto-Lock Timer, Print Mode Toggle)** | Restricted | Full Access |
| **Encrypted Backup & Restore** | Restricted | Full Access |
| **Immutable Audit Logs Viewer** | Restricted | View Only |
| **Factory Reset / Data Purge** | Blocked | Requires PIN + 16-Digit Master Key |
| **About Section (AlphaSync Systems Info)** | Full Access | Full Access |

---

## 3. Comprehensive Feature Specifications

### 3.1 Setup Wizard, Authentication & Security

#### PRD-SEC-01: First-Run Setup Wizard
* **Trigger:** App launches and detects no existing database configuration.
* **Step 1 - Language Selection:** Default system language (English or Urdu).
* **Step 2 - Backup Folder Configuration:** System file picker prompts user to select a permanent local directory/drive (e.g., `D:\ArhamAutos_Backups`).
* **Step 3 - Master Security Key Generation:**
  * System cryptographically generates a unique 16-digit alphanumeric key (e.g., `A9F4-88C1-X77B-03Q2`).
  * System displays this key once with an explicit warning: *"This key is required for system recovery and data wipes. It cannot be recovered online."*
  * **Mandatory Action:** An in-app button triggers instant printing or PDF export of a **Physical Master Key Certificate**.
* **Step 4 - Manager Account Setup:** Prompts for initial Manager username, password, and 4–6 digit quick-access PIN.

#### PRD-SEC-02: Authentication & Idle Lock
* Modern floating-card login UI featuring the "Arham Autos" header, Username field, Password/PIN field, and primary Login button.
* An idle listener detects mouse/keyboard inactivity. When inactivity reaches the configured threshold (5, 10, 15, or 30 minutes), the screen locks immediately.

#### PRD-SEC-03: Factory Reset / Data Wipe
* Destructive operation wiping `sales`, `sale_items`, `parts`, `purchases`, `khata_entries`, `parked_carts`, and `expenses`.
* **Execution Gate:** Requires active Manager session + Manager PIN verification + entry of the 16-digit Master Security Key.
* **Immutability Exception:** The `audit_logs` table is never deleted and records the factory reset timestamp and user.

---

### 3.2 Executive Dashboard

#### PRD-DSH-01: Key Performance Indicators (KPIs)
* **Total Stock Valuation:** Sum of `(Current Stock * Cost Price)` across all active parts (Manager only).
* **Daily Gross Profit:** Sum of `(Sale Price - Cost Price)` for today's finalized transactions (Manager only).
* **Daily Total Sales:** Gross counter and route sales for the current calendar day.
* **Low Stock Count:** Total distinct inventory items with quantity `<= 10`.

#### PRD-DSH-02: Visual Analytics & Recent Activity
* **Performance Overview:** Interactive graph comparing weekly and monthly sales trends.
* **Recent Sales Table:** Shows the latest 5 transactions with Bill #, Customer Name, Sale Type (Retail/Wholesale), Amount, and Time.
* **Stock Shortage List:** Table listing items where quantity `<= 10`, displaying Part Name, Part Code, Current Stock, and Minimum Alert Level.

---

### 3.3 POS Billing & Invoicing System

#### PRD-POS-01: High-Speed Checkout Interface
* Keyboard-optimized layout (`F1` Search, `F2` Confirm & Print, `F6` Hold Bill, `F7` Recall Bill, `Enter` Add Line).
* Real-time search across Part Code, English Name, Urdu Name, and Brand.
* Barcode scanner auto-detect: Scanned barcode populates the line item immediately with quantity = 1.

#### PRD-POS-02: Dual Pricing Architecture
* Each item contains both a `retail_price` and `wholesale_price`.
* Selecting **Retail Customer** defaults all item rates to `retail_price`.
* Selecting a **Registered B2B Shop / Route Customer** automatically switches all rates to `wholesale_price`.
* Manager can manually adjust unit rate on the fly; Operators cannot sell below cost price.

#### PRD-POS-03: Customer Credit Limit Verification
* When a B2B credit customer is selected, their existing outstanding balance is loaded.
* If `(Current Balance + Invoice Total) > credit_limit`:
  * System halts checkout and displays a warning modal: *"Credit Limit Exceeded! Current Balance: Rs. X, Limit: Rs. Y"*.
  * Requires on-screen Manager PIN input to authorize the transaction.

#### PRD-POS-04: Invoice Immutability
* Once an invoice is confirmed and printed, it becomes strictly **Read-Only**.
* Invoices cannot be modified, deleted, or canceled directly. Any item return or adjustment must go through the **Returns & Claims** workflow.

#### PRD-POS-05: Optional Dual-Print Engine (Priority 1 Enhancement)
* **Default Mode — 2-Up Half-Page (A5 / Half-A4 Laser Invoice):**
  * Formatted for standard A4 paper cut into two half-page slips.
  * **Header:** Arham Autos, Bagobhar Road, Kotsmaba, Ph: 0300-6748837.
  * **Customer Block:** Shop/Customer Name, Route/Area, DSO/Salesman Name.
  * **Itemized Table:** Serial #, Product Description (English & Urdu), Rate, Quantity/Unit, Line Total.
  * **Financial Summary:** Gross Amount, Previous Khata Balance, Current Bill Total, Net Payable / Total Outstanding.
  * **Mandatory Attribution Footer:** `"For Account Solution Contact AlphaSync Systems: 03140486627"`
* **Optional Mode — 58mm / 80mm Thermal Receipt Slip:**
  * Configurable toggle in POS Settings and checkout bar for fast walk-in retail cash transactions.
  * Renders a compact continuous-roll receipt containing shop header, itemized list, net cash total, and AlphaSync attribution footer.

#### PRD-POS-06: Parked / Suspended Carts (Priority 0 Enhancement)
* **Hold Bill (`F6`):** Cashiers can suspend an active, incomplete cart (e.g., when a walk-in customer steps away to check another bike part) with an optional reference note.
* **Parked Cart Indicator Badge:** A high-visibility badge on the POS top bar displays the count of currently parked carts.
* **Recall Bill (`F7`):** Opens a quick modal listing all suspended carts with timestamp, customer name, item count, and total, allowing 1-click restoration into the active checkout grid.

---

### 3.4 Parts Catalog & Inventory Management

#### PRD-INV-01: Part Master Data
* Fields: SKU/Code, Barcode, English Name, Urdu Name, Brand/Company, Vehicle Model Compatibility (e.g., CD70, CG125, GS150), Category, Rack/Shelf Location, Cost Price, Retail Price, Wholesale Price, Current Stock, Minimum Alert Threshold (Default: 10).

#### PRD-INV-02: Stock Adjustments
* Manager can adjust stock count up or down with compulsory reason tagging: `Damage / Broken`, `Physical Count Discrepancy`, `Defective Batch`, `Internal Consumption`.
* Adjustment transactions are permanently written to `audit_logs`.

#### PRD-INV-03: Custom Barcode Studio
* Auto-generates unique Code-128 barcodes for unlabeled or loose spare parts and formats printable sticker sheets.

---

### 3.5 Customer & Supplier Khata (Credit Ledger)

#### PRD-KHT-01: Double-Entry Credit Tracking
* **Customer Khata:** Credit sale adds to customer debit balance; payment collection (Cash/Bank) credits the ledger; running balance prints on every invoice.
* **Supplier Khata:** GRN entry increases accounts payable to supplier; payment vouchers reduce liability.

#### PRD-KHT-02: Aging Accounts Receivable Summary (Priority 0 Enhancement)
* Dedicated Aging Analysis tabs within the Customer Khata module categorizing outstanding balances into:
  * **Current (0–30 Days):** Recent active credit bills.
  * **Overdue (31–60 Days):** Amber warning badge requiring salesman follow-up.
  * **Critical Overdue (60+ Days):** Crimson alert badge highlighting chronically delayed workshops.
* Filterable by Route/Area and assigned Salesman (DSO) to generate targeted recovery sheets.

---

### 3.6 Purchases & Goods Receipt Notes (GRN)

#### PRD-PUR-01: Receiving Workflow
* Captures supplier invoice reference, receiving date, item lines, quantity received, purchase unit cost, and total bill.
* Finalizing a GRN increments warehouse inventory and updates the weighted moving average cost of each part.

---

### 3.7 Returns & Claims Workflow

#### PRD-RET-01: Invoice Lookup & Validation
* Return initiation requires entering a valid `Invoice ID`.
* Pre-loads original sold items, quantities, and rates to prevent returning more units than originally purchased.

#### PRD-RET-02: Two-Step Approval Workflow
1. **Operator Step:** Selects items to return, enters quantity, and submits claim into `Pending Manager Approval`.
2. **Manager Review:** Manager approves (settles refund/credit and updates stock) or rejects with reason.
3. **Manager Direct Override:** Manager can initiate and finalize an immediate return in a single step.

#### PRD-RET-03: Inventory Triage
* Upon approval, the Manager classifies each returned item:
  * **Option A — Return to Sellable Stock:** Item is intact and increments active sellable inventory.
  * **Option B — Move to Defective / Supplier Claim:** Item is damaged/faulty and routed to a segregated defective claim pool without inflating active shelf stock.

---

### 3.8 Accounts, Expenses & Payroll

#### PRD-ACC-01: Expense Journal & General Ledger
* Daily operational costs: Shop Rent, Electricity Bills, Staff Tea & Meals, Delivery Fuel, Maintenance, and Miscellaneous.
* Chart of Accounts view classifying Assets, Liabilities, and Expenses.

#### PRD-ACC-02: Employee & Payroll Management
* Staff records: Full Name, Role (Salesman/DSO, Cashier, Shop Boy), Phone, CNIC, Monthly Base Salary, and salary payout logs.

---

### 3.9 Area & Route Distribution Management

#### PRD-RTE-01: Routes & Salesman Allotment
* Dedicated Sidebar module for creating distribution routes (e.g., Kot Samba City, Mianwali Road, Sadiqabad Sector), mapping B2B shops, and assigning salesmen (DSOs).

---

### 3.10 Reports & Export Engine

#### PRD-REP-01: Core Financial & Operational Reports
* **Daily Sales Report:** Cash sales vs. credit sales vs. returns.
* **COGS & Profit Margin Report:** Total Revenue, Cost of Goods Sold, Gross Margin, and Net Profit after deducting operating expenses.
* **Stock Valuation Report:** Quantity on hand, total cost valuation, total retail valuation.
* **Route / Salesman Performance:** Total orders booked and payments recovered per route.

#### PRD-REP-02: Dead Stock & Movement Velocity Analytics (Priority 1 Enhancement)
* **Dead Stock Identification:** Highlights inventory items with `current_stock > 0` that have recorded **zero sales movement over the last 90 days** (configurable 30/60/90/180-day window), displaying total capital locked up in stagnant parts.
* **Velocity Classification (ABC Movement):** Ranks parts into Fast-Moving, Moderate-Moving, and Slow-Moving tiers based on unit turnover frequency.

#### PRD-REP-03: Dual Format Exports
* All report tables provide one-click export buttons to **Microsoft Excel (.xlsx)** and **Comma-Separated Values (.csv)**.

---

### 3.11 Localization, UI/UX & About Information

#### PRD-LOC-01: Bilingual Support & Layout Mirroring
* Instant toggle between **English (LTR)** and **Urdu (RTL)** using `flutter_localizations` and Google Noto Nastaliq Urdu font.

#### PRD-ABT-01: About Section Specification
* Accessible by both Manager and Operator:
  * **Application Name:** Arham Autos POS & Management System v2.0.0
  * **Developed By:** AlphaSync Systems (Private) Limited
  * **Support Email:** `info@alphasync.codes`
  * **Phone / WhatsApp:** `03140486627`
  * **License Status:** Offline Perpetual License
