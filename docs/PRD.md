# Product Requirements Document (PRD)

**Project Name:** Arham Autos POS & Inventory Management System  
**Product Version:** 1.0.0  
**Technology Partner:** AlphaSync Systems (Private) Limited  
**UI/UX Design:** Antigravity UI/UX Team  
**Document Status:** Final Approved

---

## 1\. Product Vision & Goals

The Arham Autos POS & ERP system is designed to provide a robust, completely offline-first retail and wholesale management tool for bike spare parts businesses. It eliminates human errors in pricing, enforces strict financial control across credit customer ledgers, streamlines delivery routes, protects company data through AES-256 encrypted backups, and maintains an immutable audit trail.

---

## 2\. User Roles & Permission Matrix

The application strictly defines two roles:

| Module / Action | Operator (Cashier) | Manager (Admin) |
| :---- | :---: | :---: |
| **Executive Dashboard (Financials, Gross Profit, Total Stock Value)** | ❌ Restricted | ✅ Full Access |
| **Operator Shift Dashboard (Personal Daily Sales Count)** | ✅ Full Access | ✅ Full Access |
| **Stock Shortage Alerts (Threshold \$\\le 10\$)** | ✅ View Only | ✅ Full Access |
| **POS Billing (Counter Sales, Invoice Generation, Printing)** | ✅ Full Access | ✅ Full Access |
| **Customer Credit Limit Override** | ❌ Blocked | ✅ Authorization via PIN |
| **Parts Catalog (Search & Stock Inquiries)** | ✅ View Only | ✅ Full Access |
| **Parts Catalog (Add, Edit, Price Update, Manual Stock Adjust)** | ❌ Restricted | ✅ Full Access |
| **Barcode Studio (Generate & Print Sticker Labels)** | ❌ Restricted | ✅ Full Access |
| **Purchases & GRN (Goods Receipt Note)** | ❌ Restricted | ✅ Full Access |
| **Customer & Supplier Khata (Ledgers & Statements)** | ❌ Restricted | ✅ Full Access |
| **Returns & Claims (Draft Return Request)** | ✅ Can Initiate | ✅ Can Initiate |
| **Returns & Claims (Approve Claim & Release Funds)** | ❌ Restricted | ✅ Full Access |
| **Returns & Claims (Direct Override Return without Draft)** | ❌ Restricted | ✅ Full Access |
| **Expense Journal & Employee Payroll** | ❌ Restricted | ✅ Full Access |
| **Route & Area Allotment for Salesmen** | ❌ Restricted | ✅ Full Access |
| **Reports Engine (Sales, COGS, Margins, Excel/CSV Export)** | ❌ Restricted | ✅ Full Access |
| **Settings (User Management, Auto-Lock Timer)** | ❌ Restricted | ✅ Full Access |
| **Encrypted Backup & Restore** | ❌ Restricted | ✅ Full Access |
| **Immutable Audit Logs Viewer** | ❌ Restricted | ✅ View Only |
| **Factory Reset / Data Purge** | ❌ Blocked | ✅ Requires PIN \+ 16-Digit Master Key |
| **About Section (AlphaSync Systems Info)** | ✅ Full Access | ✅ Full Access |

---

## 3\. Comprehensive Feature Specifications

### 3.1 Setup Wizard, Authentication & Security

#### PRD-SEC-01: First-Run Setup Wizard

* **Trigger:** App launches and detects no existing database configuration.  
* **Step 1 \- Language Selection:** Default system language (English or Urdu).  
* **Step 2 \- Backup Folder Configuration:** System file picker prompts user to select a permanent local directory/drive (e.g., `D:\ArhamAutos_Backups`).  
* **Step 3 \- Master Security Key Generation:**  
  * System cryptographically generates a unique 16-digit alphanumeric key (e.g., `A9F4-88C1-X77B-03Q2`).  
  * System displays this key once with an explicit warning: *"This key is required for system recovery and data wipes. It cannot be recovered online."*  
  * **Mandatory Action:** An in-app button allows instant printing or PDF export of a **Physical Master Key Certificate**.  
* **Step 4 \- Manager Account Setup:** Prompts for initial Manager username, password, and 4–6 digit quick-access PIN.

#### PRD-SEC-02: Authentication & Idle Lock

* Fast PINpad / password entry screen on startup and lock.  
* An idle listener detects mouse/keyboard inactivity. When inactivity reaches the configured threshold (5, 10, 15, or 30 minutes), the screen locks immediately.

#### PRD-SEC-03: Factory Reset / Data Wipe

* Destructive operation wiping `sales`, `sale_items`, `parts`, `purchases`, `khata_entries`, and `expenses`.  
* **Execution Gate:** Requires active Manager session \+ Manager PIN verification \+ entry of the 16-digit Master Security Key.  
* **Immutability Exception:** The `audit_logs` table is never deleted and records the factory reset timestamp and user.

---

### 3.2 Executive Dashboard

#### PRD-DSH-01: Key Performance Indicators (KPIs)

* **Total Stock Valuation:** \$\\sum (\\text{Current Stock} \\times \\text{Cost Price})\$ (Manager only).  
* **Daily Gross Profit:** \$\\sum (\\text{Sale Price} \- \\text{Cost Price})\$ for today's transactions (Manager only).  
* **Daily Total Sales:** Gross counter and route sales for the current calendar day.  
* **Low Stock Count:** Total distinct inventory items with quantity \$\\le 10\$.

#### PRD-DSH-02: Visual Analytics & Recent Activity

* **Performance Overview:** Interactive graph comparing weekly and monthly sales trends.  
* **Recent Sales Table:** Shows the latest 5 transactions with Bill \#, Customer Name, Sale Type (Retail/Wholesale), Amount, and Time.  
* **Stock Shortage List:** Table listing items where quantity \$\\le 10\$, displaying Part Name, Part Code, Current Stock, and Minimum Alert Level.

---

### 3.3 POS Billing & Invoicing System

#### PRD-POS-01: High-Speed Checkout Interface

* Keyboard-optimized layout (e.g., `F1` for Search, `F2` for Payment, `Enter` to Add Line).  
* Real-time search across Part Code, English Name, Urdu Name, and Brand.  
* Barcode scanner auto-detect: Scanned barcode instantly populates line item with quantity \= 1\.

#### PRD-POS-02: Dual Pricing Architecture

* Each item contains both a `retail_price` and `wholesale_price`.  
* Selecting **Retail Customer** defaults all item rates to `retail_price`.  
* Selecting a **Registered B2B Shop / Route Customer** automatically switches all rates to `wholesale_price`.  
* Manager can manually adjust unit rate on the fly if needed; Operators cannot sell below cost price.

#### PRD-POS-03: Customer Credit Limit Verification (Edge Case Implementation)

* When a B2B credit customer is selected, their existing outstanding balance is loaded.  
* If `(Current Balance + Invoice Total) > credit_limit`:  
  * System halts checkout and shows warning: *"Credit Limit Exceeded\! Current Balance: Rs. X, Limit: Rs. Y"*.  
  * System requires Manager PIN input to authorize transaction.

#### PRD-POS-04: Invoice Immutability (Edge Case Implementation)

* Once an invoice is confirmed and printed, it becomes **Read-Only**.  
* Invoices cannot be modified, deleted, or canceled directly. Any item return or adjustment must go through the **Returns & Claims** workflow to maintain strict ledger auditability.

#### PRD-POS-05: 2-Up Half-Page Printing Layout

* Specifically formatted for standard paper cut into half-page slips (2 invoices per A4 sheet).  
* **Header:** Arham Autos, Bagobhar Road, Kotsmaba, Ph: 0300-6748837.  
* **Customer Block:** Shop/Customer Name, Route/Area, DSO/Salesman Name.  
* **Metadata:** Bill Number, Date, Sale Terms (Cash / Credit).  
* **Itemized Table:** Serial \#, Product Description (English & Urdu), Rate, Quantity/Unit, Line Total.  
* **Financial Summary:** Gross Amount, Previous Khata Balance, Current Bill Total, Net Payable / Total Outstanding.  
* **Mandatory Attribution Footer:**  
  `"For Account Solution Contact AlphaSync Systems: 03140486627"`

---

### 3.4 Parts Catalog & Inventory Management

#### PRD-INV-01: Part Master Data

* Fields: SKU/Code, Barcode, English Name, Urdu Name, Brand/Company, Vehicle Model Compatibility (e.g., CD70, CG125, GS150), Category, Rack/Shelf Location, Cost Price, Retail Price, Wholesale Price, Current Stock, Minimum Alert Threshold (Default: 10).

#### PRD-INV-02: Stock Adjustments

* Manager can adjust stock count up or down with compulsory reason tagging: `Damage / Broken`, `Physical Count Discrepancy`, `Defective Batch`, `Internal Consumption`.  
* Adjustment transactions are permanently logged.

#### PRD-INV-03: Custom Barcode Studio

* Auto-generates unique Code-128 barcodes for unlabeled or loose spare parts.  
* Generates printable sticker sheets formatted for standard label sizes.

---

### 3.5 Customer & Supplier Khata (Credit Ledger)

#### PRD-KHT-01: Double-Entry Credit Tracking

* **Customer Khata:**  
  * Credit sale adds to customer debit balance.  
  * Payment collection (Cash/Bank) credits the ledger.  
  * Running balance continuously calculated and printed on each consecutive invoice.  
* **Supplier Khata:**  
  * GRN entry increases accounts payable to supplier.  
  * Payment vouchers record settlements and reduce liability.

---

### 3.6 Purchases & Goods Receipt Notes (GRN)

#### PRD-PUR-01: Receiving Workflow

* Captures supplier invoice reference, receiving date, item lines, quantity received, purchase unit cost, and total bill.  
* Finalizing a GRN instantly increments warehouse inventory and updates the moving average cost of each part.

---

### 3.7 Returns & Claims Workflow

#### PRD-RET-01: Invoice Lookup & Validation

* Return initiation strictly requires entering an `Invoice ID`.  
* System pulls all original items, quantities, and rates sold, preventing returns of items not on the invoice or exceeding purchased quantities.

#### PRD-RET-02: Two-Step Approval Workflow

1. **Operator Step:** Selects items to return, enters quantity, and submits claim. Claim status becomes `Pending Manager Approval`. No financial or stock changes occur.  
2. **Manager Review:** Manager views pending claim queue. Can **Approve** (settles refund/credit and updates inventory) or **Reject** with comments.  
3. **Manager Direct Override:** Manager can initiate and finalize a return directly in one step.

#### PRD-RET-03: Inventory Triage (Edge Case Implementation)

* When approving a return, the Manager must classify each returned item:  
  * **Option A: Return to Sellable Stock:** Item is intact and restocked into active inventory.  
  * **Option B: Move to Defective / Supplier Claim:** Item is damaged/faulty and moved to a segregated claims pool for vendor return, without inflating active shelf stock.

---

### 3.8 Accounts, Expenses & Payroll

#### PRD-ACC-01: Expense Journal

* Records daily operational costs: Shop Rent, Electricity Bills, Staff Tea & Meals, Delivery Fuel, Maintenance, and Miscellaneous.  
* Supports category-wise monthly aggregation for net profit computation.

#### PRD-ACC-02: Employee & Payroll Management

* Staff records: Full Name, Role (Salesman/DSO, Cashier, Shop Boy), Phone, CNIC, Monthly Base Salary.  
* Monthly payroll ledger recording salary payouts, advances, and deductions.

---

### 3.9 Area & Route Distribution Management

#### PRD-RTE-01: Routes & Territorials

* Creation of distribution routes (e.g., Kot Samba City, Mianwali Road, Sadiqabad Sector).  
* B2B customers are mapped to a single home route.

#### PRD-RTE-02: Salesman Route Allotment

* Assigns specific salesmen/DSOs to routes. Enables route-wise sales performance reports, order booker efficiency tracking, and recovery audits.

---

### 3.10 Reports & Export Engine

#### PRD-REP-01: Analytical Reports

* **Daily Sales Report:** Broken down by cash sales vs credit sales vs returns.  
* **COGS & Profit Margin Report:** Total Revenue, Cost of Goods Sold, Gross Margin, Net Profit after deducting expenses.  
* **Stock Valuation Report:** Quantity on hand, total cost valuation, total retail valuation.  
* **Route / Salesman Performance:** Total orders booked and payments recovered per route.

#### PRD-REP-02: Dual Format Exports

* All report tables provide one-click export buttons to **Microsoft Excel (.xlsx)** and **Comma-Separated Values (.csv)**.

---

### 3.11 Localization, UI/UX & About Information

#### PRD-LOC-01: Bilingual Support & Layout Mirroring

* Toggle button in Settings and Header switches system between **English** and **Urdu**.  
* Selecting Urdu immediately activates Right-to-Left (`TextDirection.rtl`) orientation, updating all navigation bars, tables, form inputs, and modal dialogues.

#### PRD-ABT-01: About Section Specification

* Accessible by both Manager and Operator via navigation bar or settings.  
* Displays:  
  * **Application Name:** Arham Autos POS & Management System v1.0.0  
  * **Developed By:** AlphaSync Systems (Private) Limited  
  * **Support Email:** [info@alphasync.codes](mailto:info@alphasync.codes)  
  * **Phone / WhatsApp:** 03140486627  
  * **License Status:** Offline Perpetual License  
  * **Database Status:** Local Encrypted SQLCipher Database (Healthy)