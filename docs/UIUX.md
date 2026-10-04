# UI/UX Design Brief & Screen Specifications

## Arham Autos POS & Management Desktop Suite

**Document Version:** 2.0.0 (Updated & Aligned with Final PRD / TRD)  
**Target Client:** Arham Autos (Bagobhar Road, Kotsmaba)  
**Technology Partner:** AlphaSync Systems (Private) Limited  
**Target Platform:** Flutter (Windows 10/11 Desktop Primary, Web Responsive Architecture)  
**UI/UX Lead:** Antigravity UI/UX Team

---

## 1\. Project Context & Business Model

A high-performance, offline-first Windows desktop ERP/POS application for a motorcycle spare parts business operating two simultaneous sales channels:

1. **B2C (Retail Counter Sales):** Over-the-counter sales to walk-in bike owners and mechanics with rapid barcode scanning and immediate receipt generation.  
2. **B2B (Wholesale Supply):** Bulk supply to external auto-part shops and regional workshops distributed via dedicated salesmen and geographic routes. Involves wholesale pricing tiers, credit (*Khata / Udhaar*) ledger management, and customer credit limits.  
* **Database & Connectivity:** Completely offline local SQLite database with 256-bit AES SQLCipher encryption. Zero reliance on internet or external servers.  
* **Bilingual Requirement:** Complete interface support in English (LTR) and Urdu (RTL) with high-legibility Nastaliq/Naskh typography and instant language switching (\<100ms without app restart).

---

## 2\. User Roles & Access Control (Strict Two-Tier RBAC)

The system strictly enforces **two user roles** (the Manager carries full administrative authority):

| Role | Target Persona | Access Scope & Layout Behavioral Changes |
| :---- | :---- | :---- |
| **Operator** | Counter Cashier / Sales Staff | • **Default Landing:** POS Terminal. • **Dashboard:** Simplified counter shift summary (today's personal bill count) — **all financial metrics, gross profit, inventory valuation, and margins are completely hidden**. • **Inventory:** View & search only (cannot edit prices or stock). • **Returns:** Can only draft return requests (cannot approve refunds). • **Restricted Modules:** Blocked from Purchases/GRN, Khata Ledgers, Accounts/Expenses, Employees, Routes, Reports, and System Settings. |
| **Manager** | Store Owner / Admin / Accounts Officer | • **Full Unrestricted Access:** Full Executive Dashboard (Profit, Revenue, Valuation, Alerts), Parts Catalog editing, Purchases/GRN, Khata Ledgers, Return Approvals & Direct Returns, Expenses, Routes, Reports (Excel/CSV), Encrypted Backups, User Management, and Master-Key Protected Factory Reset. |

---

## 3\. Platform & Technical Constraints for UI/UX

1. **Screen Resolutions & Scaling:**  
   * Baseline canvas: **1920×1080 (1080p Desktop)**, responsive down to **1366×768**.  
   * Resizable window support with native Windows scrollbar ergonomics (`ScrollbarThemeData` with visible 8px thumb thickness and track visibility) to eliminate viewport clipping on small resolutions.  
2. **Keyboard-First Ergonomics at POS:**  
   * The POS Terminal must be 100% operable via hotkeys (`F1`\-`F9`, `Enter`, `Tab`, `Escape`, `Arrow Keys`). Cashiers should not need to reach for a mouse during a standard checkout.  
3. **Barcode Scanning Input:**  
   * Scanners act as high-speed keyboard input terminating with an `Enter` key stroke. The search/barcode field must maintain intelligent auto-focus.  
4. **Printer Output (Laser / Inkjet A4 Half-Page 2-Up):**  
   * **Crucial Constraint:** The store uses standard office printers (laser/inkjet), **NOT thermal receipt printers**.  
   * Invoices must be rendered as a **2-Up Half-Page (A5 landscape or 2 vertical slips per A4 sheet)**. Two identical copies fit on a single A4 page.  
   * Compulsory Footer: `"For Account Solution Contact AlphaSync Systems: 03140486627"`.  
5. **Modest Hardware Target:**  
   * Target PC: Intel Core i3 with 4GB RAM running Windows 10/11. Avoid heavy GPU shaders, blur/glassmorphism, or complex animations. Keep UI clean, snappy, and lightweight.

---

## 4\. Visual Identity & Design System

* **Theme:** Clean Professional Light Theme (Optimized for bright shop counter visibility).  
* **Color Palette:**  
  * **Primary Brand:** Deep Navy / Slate Blue (`#1E3A8A` / `#0F172A`) — conveys reliability and structure.  
  * **Success / Paid / In-Stock:** Emerald Green (`#059669`).  
  * **Warning / Low Stock (\$\\le 10\$) / Pending Approval:** Amber / Tangerine (`#D97706`).  
  * **Danger / Overdue / Limit Exceeded / Critical Reset:** Crimson Red (`#DC2626`).  
  * **Backgrounds & Surfaces:** Crisp neutral greys (`#F8FAFC`, `#FFFFFF`, card borders `#E2E8F0`).  
* **Typography:**  
  * English: Inter / Roboto with heavy bold weights for prices, bills, and totals.  
  * Urdu: Google Noto Nastaliq Urdu / Noto Sans Arabic with adequate line-height to prevent vertical text clipping.  
* **Component Styling:** Material Design 3 desktop conventions (flat cards with subtle borders, clear button hierarchies, high-contrast inputs).

---

## 5\. Navigation Shell & Information Architecture

### Persistent Sidebar Navigation

* **Position:** Fixed on the Left in English; dynamically moves to the Right in Urdu (RTL).  
* **Behavior:** Persistent on desktop (\>1200px), collapsible to icons-only rail on compact screens.

| \# | Sidebar Navigation Item | Icon | Operator Access | Manager Access |
| :---: | :---- | :---: | :---: | :---: |
| 1 | **Dashboard** | `dashboard` | Simplified (Sales count only) | Full Executive Metrics |
| 2 | **POS Terminal** | `point_of_sale` | Full (Cash & Credit billing) | Full Access |
| 3 | **Parts Catalog** | `inventory_2` | View & Search Only | Full CRUD \+ Stock Adjust |
| 4 | **Purchases / GRN** | `shopping_bag` | ❌ Hidden | Full Access |
| 5 | **Khata Ledger** | `menu_book` | ❌ Hidden | Full Access |
| 6 | **Returns & Claims** | `assignment_return` | Initiate Draft Only | Approve & Settle / Direct |
| 7 | **Accounts & Expenses** | `receipt_long` | ❌ Hidden | Full Access |
| 8 | **Employees & HR** | `badge` | ❌ Hidden | Full Access |
| 9 | **Routes & Areas** | `alt_route` | ❌ Hidden | Full Access |
| 10 | **Reports & Analytics** | `analytics` | ❌ Hidden | Full Access (Excel/CSV) |
| 11 | **Settings & Recovery** | `settings` | ❌ Hidden | Full Access |

### Top Application Bar

* **Left / Leading:** Shop Name (*"Arham Autos"*), Active Module Title.  
* **Center / Status:** Active logged-in user badge with role indicator (`Manager` or `Operator`).  
* **Right / Actions:**  
  * Language Switcher Toggle (`English` / `اردو`).  
  * Inactivity Auto-Lock trigger & countdown status.  
  * "About" Info Dialog button.

---

## 6\. Detailed Screen-by-Screen UX Specifications

### 6.1 Splash & First-Time Setup Wizard (First Launch Only)

* **Step 1 \- Language Choice:** English or Urdu default.  
* **Step 2 \- Local Backup Directory Picker:** Mandatory Windows folder selector (e.g. `D:\ArhamAutos_Backups`).  
* **Step 3 \- 16-Digit Master Security Key:**  
  * Displayed in prominent monospace font with distinct warning.  
  * **Mandatory UI Action:** "Print Certificate" button that generates a physical paper copy for the shop owner before proceeding.  
* **Step 4 \- Manager Account:** Initial username, password, and 4-6 digit numeric PIN.

### 6.2 Login & Session Screen

* Numeric PINpad (touch and numpad friendly) \+ option to toggle standard Password form.  
* Shows active language; automatically switches layout to the user's saved preference upon authentication.

### 6.3 Executive Dashboard

* **Top Metric Cards (Manager Only):**  
  1. *Total Inventory Value:* Cumulative cost value (\$\\sum \\text{Stock} \\times \\text{Cost Price}\$).  
  2. *Daily Gross Profit:* Today's sales margin.  
  3. *Daily Total Sales:* Gross revenue for today.  
  4. *Low Stock Alert Count:* Total parts with quantity \$\\le 10\$.  
* **Performance Chart:** Weekly/Monthly sales trend line/bar graph.  
* **Two-Column Data Split:**  
  * *Left:* Recent 5 Sales list (Bill \#, customer/route, amount, time, reprint quick-action).  
  * *Right:* Stock Shortage Alert List (Parts with stock \$\\le 10\$, displaying part code, Urdu/Eng name, remaining count, and a direct "Create GRN" button).

### 6.4 POS Billing Terminal (Highest Priority Screen)

* **Left Panel (Cart & Item Entry):**  
  * Auto-focused Search/Scan field supporting Part Code, English Name, Urdu Name, and Barcode.  
  * Table: Line \#, Item Description, Price Type Badge (Retail/Wholesale), Unit Price, Qty (inline editable), Line Total, Delete action.  
* **Right Panel (Customer & Financial Summary):**  
  * **Customer Selector:** Walk-in Retail (defaults to Retail Price) or B2B Route Customer (switches cart to Wholesale Price).  
  * Route & Salesman indicator.  
  * Subtotal, Discount input (Manager PIN gated), Previous Khata Balance, Net Payable.  
  * **Payment Split:** Cash Tendered, Change Due, Credit (Added to Khata).  
  * **Credit Limit Guard (Edge Case):** If new balance exceeds customer's credit limit, a warning modal appears requiring Manager PIN authorization to proceed.  
  * **Action Button:** Giant high-contrast "Confirm & Print Invoice (F2)" button.  
* **Post-Print State:** Instant print spooling with visible "Reprint Bill" button. Finalized invoices are strictly immutable (cannot be edited or deleted).

### 6.5 Parts Catalog & Inventory

* Search bar \+ filter chips (Brand, Shelf/Rack Location, Model e.g. CD70, Low Stock filter).  
* Grid/Table showing Code, Barcode, Name (Eng/Urdu), Cost Price (Manager only), Retail Price, Wholesale Price, Stock, Rack.  
* **Stock Adjustment Modal:** Requires selecting reason (`Damage`, `Audit Discrepancy`, `Defective Batch`) and logs to audit trail.  
* **Barcode Studio:** Batch/single Code-128 label sticker generator with printable preview.

### 6.6 Customer & Supplier Khata (Ledgers)

* Customer list showing total balance with color-coded risk indicators.  
* Detailed ledger view: Opening balance, invoice debits, payment credits, and running balance.  
* Payment entry voucher: Cash/Bank payment recording with instant receipt printout.

### 6.7 Purchases & Goods Receipt Notes (GRN)

* Supplier selector, invoice reference number, date.  
* Itemized intake table (Part, Received Qty, Purchase Unit Cost, Line Total).  
* Posting GRN automatically increments inventory and recalculates moving average unit cost.

### 6.8 Returns & Claims Workflow

* **Lookup:** Compulsory entry of original `Invoice ID`.  
* **Operator Flow:** Selects returned line items, enters quantities, submits claim \$\\rightarrow\$ Status: `Pending Manager Review`.  
* **Manager Flow:** Review pending queue \$\\rightarrow\$ Approve or Reject.  
* **Direct Override:** Manager can bypass draft and finalize returns on the spot.  
* **Inventory Disposition (Edge Case):** Manager must select for each item:  
  * `Return to Sellable Stock` (restocks active inventory).  
  * `Move to Defective / Supplier Claim` (routes to vendor claim pool without inflating active shelf stock).

### 6.9 Accounts & Expense Journal

* Daily expense recording tagged by category (`Rent`, `Electricity`, `Tea & Meals`, `Fuel`, `Maintenance`).  
* Monthly summary card calculating net operating profit after overhead deduction.

### 6.10 Routes & Employee Management

* Route creation (geographic zones) and mapping of B2B customer shops.  
* Salesman / DSO profile management with route assignment for territory-wise performance tracking.

### 6.11 Reports & Data Exports

* Tabular reports: Daily Sales Summary, COGS & Margins, Stock Valuation, Route Performance.  
* Dedicated, high-visibility **Export to Excel (.xlsx)** and **Export to CSV** action buttons on every report.

### 6.12 Settings, Backup & Security

* **Auto-Lock Dropdown:** 5 min, 10 min, 15 min, 30 min.  
* **Encrypted Backup:** "Backup Now" button saves an AES-256 encrypted `.bak` file to the configured folder.  
* **Factory Reset / Data Wipe:** High-risk section with crimson background. Wipes operational tables only upon supplying Manager PIN \+ the 16-digit Master Security Key.  
* **Audit Logs Viewer:** Filterable, read-only list of all system actions (survives data wipe).  
* **"About" System Modal:** Displays AlphaSync Systems (Private) Limited, Email: `info@alphasync.codes`, Phone: `03140486627`, and license details.

---

## 7\. Re-Engineered Invoice Print Layout (A5 / Half-Page A4)

\+--------------------------------------------------------------------------+

|                               ARHAM AUTOS                                |

|                         Bagobhar Road, Kotsmaba                          |

|                            Ph: 0300-6748837                              |

\+------------------------------------+-------------------------------------+

| Customer Info:                     | Invoice Info:                       |

| Name: \[Customer / Shop Name\]       | Bill \#:   \[Bill ID / e.g. 502\]      |

| Route/Area: \[e.g. Mianwali Road\]   | Date:     \[DD/MM/YYYY\]              |

| DSO / Booker: \[Salesman Name\]      | Terms:    \[Cash / Credit\]           |

\+----+-------------------------------+-----------+------------+------------+

| Sr | Product Description (Eng/Urdu)| Rate (Rs) | Qty / Unit | Total (Rs) |

\+----+-------------------------------+-----------+------------+------------+

| 1  | SHOKE KAN CD70 BL (شاک کان)   |    200.00 |   2 Piece  |     400.00 |

| 2  | SHOKE KANN CD 70 RED          |    210.00 |   2 Piece  |     420.00 |

| 3  | SHOAK GLASS CD70 (شاک گلاس)   |    250.00 |   3 Piece  |     750.00 |

| 4  | H/L SHEESHA CD 70 AJWA        |     50.00 |   5 Piece  |     250.00 |

| 5  | CHAIN COVER PLS CD70 (چین کور)|    150.00 |   5 Piece  |     750.00 |

\+----+-------------------------------+-----------+------------+------------+

| Gross Amount:           Rs. 2,570  | Previous Balance:          Rs. \-100 |

| Discount:                 Rs. 0.00 | Current Bill:             Rs. 2,570 |

| Net Payable:            Rs. 2,570  | Total Outstanding:        Rs. 2,470 |

\+--------------------------------------------------------------------------+

|  For Account Solution Contact AlphaSync Systems: 03140486627             |

\+--------------------------------------------------------------------------+

---

## 8\. Antigravity Implementation Checklist

- [ ] **Dual Pricing Switcher:** Ensure POS auto-switches between Retail and Wholesale pricing upon customer selection.  
- [ ] **A5 / Half-Page Invoice Print Layout:** Implement 2-up half-page laser printing format with AlphaSync promotional footer.  
- [ ] **Shortage Threshold \$\\le 10\$:** Configure dashboard alerts and inventory badges for quantities \$\\le 10\$.  
- [ ] **Manager PIN Step-Up Dialog:** Reusable security modal for discounts, credit limit overrides, and stock adjustments.  
- [ ] **Urdu RTL Mirroring:** Test full horizontal flip of sidebar, table columns, and form fields when switching to Urdu.  
- [ ] **Windows Scrollbars:** Apply custom `ScrollbarThemeData` (8px thickness, visible track) on all tables and lists.