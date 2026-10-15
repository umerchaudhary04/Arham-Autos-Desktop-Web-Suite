# Technical Requirements Document (TRD)

**Project Name:** Arham Autos POS & Inventory Management System  
**Version:** 2.0.0 (Updated with Priority 0 & Priority 1 Technical Specifications)  
**Technology Partner:** AlphaSync Systems (Private) Limited  
**UI/UX Implementation:** Antigravity UI/UX Team  
**Architecture:** Clean Architecture / Feature-First Pattern in Flutter  

---

## 1. Architectural Overview & Component Stack

The application is structured into four decoupled layers following Clean Architecture principles:

1. **Presentation Layer:**
   * Flutter (Windows Desktop x64 Native + Web Target Readiness).
   * Antigravity UI Design System (Responsive Grid, Native Windows 8px Scrollbars, Floating-Card Login Screen).
   * Bidirectional Localization (`TextDirection.ltr` for English, `TextDirection.rtl` for Urdu with Google Noto Nastaliq Urdu).
2. **Application / State Layer:**
   * State Management: Bloc / Cubit or Riverpod.
   * Security & RBAC Guards (Operator vs. Manager permission interceptor & Manager PIN Step-Up Modal).
   * POS Parked Cart State Manager (`F6` Hold / `F7` Recall stack).
   * Idle Inactivity Service (Window-level pointer and keyboard listener).
3. **Domain Layer:**
   * Business Entities, Value Objects, Use Cases, and Validation Services.
   * Dual Pricing Engine (Retail B2C vs. Wholesale B2B automatic resolution).
   * Credit Limit Verification & Aging Receivables Calculator (`0–30`, `31–60`, `60+` days).
   * Inventory Velocity & Dead-Stock Analyzer (90-day turnover query engine).
4. **Data Layer:**
   * Drift ORM (Data Access Objects & Repositories) with rigorous `try/catch` SQLite error handling.
   * SQLCipher SQLite Native Driver (256-bit AES at-rest encryption).
   * Dual-Print Spooler (`pdf` + `printing` for 2-Up Half-Page A5 Laser AND 58mm/80mm Thermal Roll layouts).
   * File Exporter (Excel `.xlsx` and `.csv` generators).

---

## 2. Complete Relational Database Schema (Drift / SQLCipher)

### 2.1 Security, Configuration & Users
```sql
CREATE TABLE system_configs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    config_key TEXT NOT NULL UNIQUE, -- e.g. 'DEFAULT_PRINT_MODE' ('A5_2UP' | 'THERMAL_80MM' | 'THERMAL_58MM')
    config_value TEXT NOT NULL,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    pin_hash TEXT NOT NULL,          -- Salted SHA-256 hash of 4-6 digit PIN
    password_hash TEXT,
    role TEXT NOT NULL CHECK(role IN ('MANAGER', 'OPERATOR')),
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    action_type TEXT NOT NULL,      -- LOGIN, LOGOUT, REPORT_EXPORT, RETURN_APPROVE, STOCK_ADJUST, CREDIT_OVERRIDE, DATA_WIPE
    details TEXT NOT NULL,
    ip_or_terminal TEXT DEFAULT 'LOCAL_TERMINAL',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

### 2.2 Geography & Personnel
```sql
CREATE TABLE routes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    city TEXT DEFAULT 'Kot Samba',
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT,
    role TEXT NOT NULL,             -- SALESMAN, CASHIER, SHOP_BOY
    assigned_route_id INTEGER,
    monthly_salary REAL DEFAULT 0.0,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(assigned_route_id) REFERENCES routes(id)
);
```

### 2.3 Customers, Suppliers & Aging Receivables
```sql
CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    shop_name TEXT,
    phone TEXT,
    address TEXT,
    route_id INTEGER,
    customer_type TEXT NOT NULL DEFAULT 'RETAIL' CHECK(customer_type IN ('RETAIL', 'WHOLESALE')),
    credit_limit REAL DEFAULT 0.0,
    current_balance REAL DEFAULT 0.0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(route_id) REFERENCES routes(id)
);

CREATE TABLE customer_ledger_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    invoice_id INTEGER,
    entry_type TEXT NOT NULL CHECK(entry_type IN ('INVOICE_DEBIT', 'PAYMENT_CREDIT', 'RETURN_CREDIT', 'ADJUSTMENT')),
    debit_amount REAL DEFAULT 0.0,
    credit_amount REAL DEFAULT 0.0,
    unsettled_amount REAL DEFAULT 0.0, -- Tracks remaining unpaid balance per debit invoice for 30/60/90-day FIFO aging
    running_balance REAL NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(customer_id) REFERENCES customers(id),
    FOREIGN KEY(invoice_id) REFERENCES sales(id)
);

CREATE TABLE suppliers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name TEXT NOT NULL,
    contact_person TEXT,
    phone TEXT,
    address TEXT,
    current_balance REAL DEFAULT 0.0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE supplier_ledger_entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    supplier_id INTEGER NOT NULL,
    grn_id INTEGER,
    entry_type TEXT NOT NULL CHECK(entry_type IN ('PURCHASE_PAYABLE', 'PAYMENT_PAID', 'RETURN_DEBIT')),
    debit_amount REAL DEFAULT 0.0,
    credit_amount REAL DEFAULT 0.0,
    running_balance REAL NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY(grn_id) REFERENCES purchases_grn(id)
);
```

### 2.4 Inventory, Defective Pool & Stock Adjustments
```sql
CREATE TABLE parts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    barcode TEXT UNIQUE,
    name_en TEXT NOT NULL,
    name_ur TEXT,
    brand TEXT,
    model_compatibility TEXT,
    shelf_location TEXT,
    cost_price REAL NOT NULL,
    retail_price REAL NOT NULL,
    wholesale_price REAL NOT NULL,
    current_stock INTEGER NOT NULL DEFAULT 0,
    defective_claim_stock INTEGER NOT NULL DEFAULT 0, -- Segregated pool for non-sellable returned items
    min_stock_alert INTEGER NOT NULL DEFAULT 10,
    last_sold_at DATETIME,                            -- Indexed timestamp for fast Dead Stock & Velocity queries
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_parts_last_sold ON parts(last_sold_at);
CREATE INDEX idx_parts_stock ON parts(current_stock);

CREATE TABLE stock_adjustments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    part_id INTEGER NOT NULL,
    adjusted_by INTEGER NOT NULL,
    quantity_change INTEGER NOT NULL,
    reason TEXT NOT NULL CHECK(reason IN ('DAMAGE', 'PHYSICAL_AUDIT', 'DEFECTIVE_BATCH', 'INTERNAL_USE')),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(part_id) REFERENCES parts(id),
    FOREIGN KEY(adjusted_by) REFERENCES users(id)
);
```

### 2.5 Purchases & Goods Receipt Notes (GRN)
```sql
CREATE TABLE purchases_grn (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    supplier_id INTEGER NOT NULL,
    supplier_invoice_no TEXT,
    purchase_date DATE NOT NULL,
    total_amount REAL NOT NULL,
    created_by INTEGER NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(supplier_id) REFERENCES suppliers(id),
    FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE TABLE purchase_items_grn (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    grn_id INTEGER NOT NULL,
    part_id INTEGER NOT NULL,
    quantity_received INTEGER NOT NULL,
    unit_purchase_price REAL NOT NULL,
    line_total REAL NOT NULL,
    FOREIGN KEY(grn_id) REFERENCES purchases_grn(id) ON DELETE CASCADE,
    FOREIGN KEY(part_id) REFERENCES parts(id)
);
```

### 2.6 Sales, POS Invoices & Parked Carts (Priority 0 Schema)
```sql
CREATE TABLE sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    bill_number INTEGER NOT NULL UNIQUE,
    customer_id INTEGER,
    salesman_id INTEGER,
    route_id INTEGER,
    sale_type TEXT NOT NULL CHECK(sale_type IN ('RETAIL', 'WHOLESALE')),
    gross_amount REAL NOT NULL,
    discount_amount REAL DEFAULT 0.0,
    net_amount REAL NOT NULL,
    paid_amount REAL NOT NULL,
    previous_balance REAL DEFAULT 0.0,
    payment_status TEXT NOT NULL CHECK(payment_status IN ('PAID', 'PARTIAL', 'CREDIT')),
    is_locked BOOLEAN NOT NULL DEFAULT 1, -- Enforces strict invoice immutability after print
    created_by INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(customer_id) REFERENCES customers(id),
    FOREIGN KEY(salesman_id) REFERENCES employees(id),
    FOREIGN KEY(route_id) REFERENCES routes(id),
    FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE TABLE sale_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sale_id INTEGER NOT NULL,
    part_id INTEGER NOT NULL,
    unit_rate REAL NOT NULL,
    quantity INTEGER NOT NULL,
    line_total REAL NOT NULL,
    FOREIGN KEY(sale_id) REFERENCES sales(id) ON DELETE CASCADE,
    FOREIGN KEY(part_id) REFERENCES parts(id)
);

-- Priority 0: Persistent Parked / Suspended Carts
CREATE TABLE parked_carts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    reference_note TEXT,            -- Optional tag e.g. "Walk-in Mechanic CD70"
    customer_id INTEGER,
    sale_type TEXT NOT NULL DEFAULT 'RETAIL' CHECK(sale_type IN ('RETAIL', 'WHOLESALE')),
    cart_json TEXT NOT NULL,        -- Serialized JSON array of cart items, quantities, and unit rates
    discount_amount REAL DEFAULT 0.0,
    parked_by INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(customer_id) REFERENCES customers(id),
    FOREIGN KEY(parked_by) REFERENCES users(id)
);
```

### 2.7 Returns & Claims Workflow
```sql
CREATE TABLE return_claims (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sale_id INTEGER NOT NULL,
    requested_by INTEGER NOT NULL,
    approved_by INTEGER,
    claim_status TEXT NOT NULL DEFAULT 'PENDING' CHECK(claim_status IN ('PENDING', 'APPROVED', 'REJECTED')),
    total_refund_amount REAL NOT NULL,
    refund_mode TEXT DEFAULT 'CASH' CHECK(refund_mode IN ('CASH', 'KHATA_CREDIT')),
    rejection_reason TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(sale_id) REFERENCES sales(id),
    FOREIGN KEY(requested_by) REFERENCES users(id),
    FOREIGN KEY(approved_by) REFERENCES users(id)
);

CREATE TABLE return_claim_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    claim_id INTEGER NOT NULL,
    part_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    refund_rate REAL NOT NULL,
    line_refund_total REAL NOT NULL,
    inventory_disposition TEXT NOT NULL DEFAULT 'SELLABLE' CHECK(inventory_disposition IN ('SELLABLE', 'DEFECTIVE_CLAIM')),
    FOREIGN KEY(claim_id) REFERENCES return_claims(id) ON DELETE CASCADE,
    FOREIGN KEY(part_id) REFERENCES parts(id)
);
```

---

## 3. Priority 0 & Priority 1 Technical Specifications

### 3.1 Parked Carts Engine (`ParkedCartRepository`)
* Pressing `F6` serializes the active cart state into `parked_carts` and resets the POS grid in `<50ms`.
* Top bar StreamBuilder listens to `SELECT COUNT(*) FROM parked_carts` to render the live **Parked Cart Badge**.
* Pressing `F7` opens the Recall Modal; selecting a parked cart hydrates the POS state and deletes the record from `parked_carts`.

### 3.2 Aging Accounts Receivable Query (`KhataAgingDao`)
* Uses FIFO payment allocation across `customer_ledger_entries` where `entry_type = 'INVOICE_DEBIT'` and `unsettled_amount > 0`.
* Aggregates customer balances into three SQL buckets based on `julianday('now') - julianday(created_at)`:
  * `bucket_0_30`: `<= 30 days`
  * `bucket_31_60`: `> 30 AND <= 60 days`
  * `bucket_60_plus`: `> 60 days`

### 3.3 Optional Dual-Print Engine (`InvoicePrintService`)
* **Layout 1 — `A5_2UP` (Default):** Generates an ISO A4 PDF page split into two identical half-page (148mm × 210mm) slips containing full B2B route metadata, previous Khata balance, and the mandatory footer `"For Account Solution Contact AlphaSync Systems: 03140486627"`.
* **Layout 2 — `THERMAL_80MM` / `THERMAL_58MM` (Optional Toggle):** Uses `PdfPageFormat.roll80` or `PdfPageFormat.roll57` to generate a compact continuous thermal slip for walk-in cash sales while retaining the AlphaSync footer.

### 3.4 Dead Stock & Velocity Analytics (`InventoryAnalyticsDao`)
* **Dead Stock Query:**
  ```sql
  SELECT p.*, (p.current_stock * p.cost_price) AS locked_capital
  FROM parts p
  WHERE p.is_active = 1
    AND p.current_stock > 0
    AND (p.last_sold_at IS NULL OR julianday('now') - julianday(p.last_sold_at) >= :daysThreshold)
  ORDER BY locked_capital DESC;
  ```
* **Movement Velocity Query:** Joins `sale_items` and `sales` over a configurable period (30/60/90 days), ranking parts by `SUM(quantity)` into **Fast-Moving (Top 20%)**, **Moderate (Middle 50%)**, and **Slow-Moving (Bottom 30%)**.
