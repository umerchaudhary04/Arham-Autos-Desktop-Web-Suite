# Technical Requirements Document (TRD)

**Project Name:** Arham Autos POS & Inventory Management System  
**Version:** 1.0.0  
**Technology Partner:** AlphaSync Systems (Private) Limited  
**UI/UX Implementation:** Antigravity UI/UX Team  
**Architecture:** Clean Architecture / Feature-First Pattern in Flutter

---

## 1\. Architectural Overview & Component Stack

The application is structured into four decoupled layers following Clean Architecture principles:

\+--------------------------------------------------------------------------+

|                        1\. PRESENTATION LAYER                             |

|  \* Flutter (Windows Desktop x64 Native \+ Web Target Readiness)           |

|  \* Antigravity UI Design System (Responsive Grid, Windows Scrollbars)    |

|  \* Bidirectional Localization (LTR for English, RTL for Urdu)            |

\+--------------------------------------------------------------------------+

                                     |

                                     v

\+--------------------------------------------------------------------------+

|                         2\. APPLICATION / BLOC                            |

|  \* State Management: Bloc / Cubit or Riverpod                            |

|  \* Security & RBAC Guards (Operator vs Manager Permission Interceptor)   |

|  \* Idle Inactivity Service (Window-level Pointer & Keyboard Hook)        |

\+--------------------------------------------------------------------------+

                                     |

                                     v

\+--------------------------------------------------------------------------+

|                           3\. DOMAIN LAYER                                |

|  \* Business Entities, Value Objects, Use Cases & Validation Services     |

|  \* Pricing Engine (Dual Retail/Wholesale resolution)                     |

|  \* Credit Limit Verification Service                                     |

|  \* Average Cost & Inventory Movement Calculators                         |

\+--------------------------------------------------------------------------+

                                     |

                                     v

\+--------------------------------------------------------------------------+

|                            4\. DATA LAYER                                 |

|  \* Drift ORM (Data Access Objects & Repositories)                        |

|  \* SQLCipher SQLite Native Driver (256-bit AES at-rest Encryption)       |

|  \* File Exporter (Excel/CSV via syncfusion\_flutter\_xlsio or csv package) |

|  \* Print Spooler (PDF / Native Windows Document Spooling)                |

\+--------------------------------------------------------------------------+

---

## 2\. Complete Relational Database Schema (Drift / SQLCipher)

All tables are created within the encrypted SQLite database file.

### 2.1 Security, Configuration & Users

\-- System configurations (Setup Wizard state, backup directory, idle lock)

CREATE TABLE system\_configs (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    config\_key TEXT NOT NULL UNIQUE,

    config\_value TEXT NOT NULL,

    updated\_at DATETIME DEFAULT CURRENT\_TIMESTAMP

);

\-- User accounts (Manager and Operator)

CREATE TABLE users (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    username TEXT NOT NULL UNIQUE,

    pin\_hash TEXT NOT NULL,          \-- Salted SHA-256 hash of 4-6 digit PIN

    password\_hash TEXT,             \-- Optional password for manager reset

    role TEXT NOT NULL CHECK(role IN ('MANAGER', 'OPERATOR')),

    is\_active BOOLEAN NOT NULL DEFAULT 1,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP

);

\-- Immutable audit logs (survives data wipe)

CREATE TABLE audit\_logs (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    user\_id INTEGER,

    action\_type TEXT NOT NULL,      \-- LOGIN, LOGOUT, REPORT\_EXPORT, RETURN\_APPROVE, STOCK\_ADJUST, DATA\_WIPE

    details TEXT NOT NULL,

    ip\_or\_terminal TEXT DEFAULT 'LOCAL\_TERMINAL',

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(user\_id) REFERENCES users(id)

);

### 2.2 Geography & Personnel

\-- Distribution routes for B2B wholesale

CREATE TABLE routes (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    name TEXT NOT NULL,             \-- e.g. "Mianwali Road KTS"

    city TEXT DEFAULT 'Kot Samba',

    description TEXT,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP

);

\-- Employees & Salesmen

CREATE TABLE employees (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    name TEXT NOT NULL,

    phone TEXT,

    role TEXT NOT NULL,             \-- SALESMAN, CASHIER, SHOP\_BOY

    assigned\_route\_id INTEGER,

    monthly\_salary REAL DEFAULT 0.0,

    is\_active BOOLEAN NOT NULL DEFAULT 1,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(assigned\_route\_id) REFERENCES routes(id)

);

### 2.3 Customers & Suppliers (Khata / Ledgers)

\-- Customers (B2C & B2B Wholesale)

CREATE TABLE customers (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    name TEXT NOT NULL,

    shop\_name TEXT,                 \-- e.g. "Ms Autos Kot Samba"

    phone TEXT,

    address TEXT,

    route\_id INTEGER,

    customer\_type TEXT NOT NULL DEFAULT 'RETAIL' CHECK(customer\_type IN ('RETAIL', 'WHOLESALE')),

    credit\_limit REAL DEFAULT 0.0,  \-- 0.0 means unconstrained or default threshold

    current\_balance REAL DEFAULT 0.0, \-- Positive \= Customer owes money, Negative \= Advance

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(route\_id) REFERENCES routes(id)

);

\-- Customer Khata transactions

CREATE TABLE customer\_ledger\_entries (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    customer\_id INTEGER NOT NULL,

    invoice\_id INTEGER,

    entry\_type TEXT NOT NULL CHECK(entry\_type IN ('INVOICE\_DEBIT', 'PAYMENT\_CREDIT', 'RETURN\_CREDIT', 'ADJUSTMENT')),

    debit\_amount REAL DEFAULT 0.0,

    credit\_amount REAL DEFAULT 0.0,

    running\_balance REAL NOT NULL,

    notes TEXT,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(customer\_id) REFERENCES customers(id),

    FOREIGN KEY(invoice\_id) REFERENCES sales(id)

);

\-- Suppliers

CREATE TABLE suppliers (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    company\_name TEXT NOT NULL,

    contact\_person TEXT,

    phone TEXT,

    address TEXT,

    current\_balance REAL DEFAULT 0.0, \-- Amount owed to supplier

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP

);

\-- Supplier ledger transactions

CREATE TABLE supplier\_ledger\_entries (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    supplier\_id INTEGER NOT NULL,

    grn\_id INTEGER,

    entry\_type TEXT NOT NULL CHECK(entry\_type IN ('PURCHASE\_PAYABLE', 'PAYMENT\_PAID', 'RETURN\_DEBIT')),

    debit\_amount REAL DEFAULT 0.0,

    credit\_amount REAL DEFAULT 0.0,

    running\_balance REAL NOT NULL,

    notes TEXT,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(supplier\_id) REFERENCES suppliers(id),

    FOREIGN KEY(grn\_id) REFERENCES purchases\_grn(id)

);

### 2.4 Inventory & Parts Catalog

\-- Parts catalog with dual pricing

CREATE TABLE parts (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    code TEXT NOT NULL UNIQUE,      \-- Part SKU / Barcode code (e.g. CD70-SHK-01)

    barcode TEXT UNIQUE,            \-- Scannable barcode sequence

    name\_en TEXT NOT NULL,          \-- e.g. "SHOKE KAN CD70 BL"

    name\_ur TEXT,                   \-- e.g. "شاک کان CD70"

    brand TEXT,                     \-- e.g. "AJWA", "HONDA", "CROWN"

    model\_compatibility TEXT,       \-- e.g. "CD-70"

    shelf\_location TEXT,            \-- Rack / Shelf identifier

    cost\_price REAL NOT NULL,       \-- Purchasing unit cost

    retail\_price REAL NOT NULL,     \-- B2C retail counter price

    wholesale\_price REAL NOT NULL,  \-- B2B supply price

    current\_stock INTEGER NOT NULL DEFAULT 0,

    min\_stock\_alert INTEGER NOT NULL DEFAULT 10,

    is\_active BOOLEAN NOT NULL DEFAULT 1,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP

);

\-- Stock adjustments

CREATE TABLE stock\_adjustments (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    part\_id INTEGER NOT NULL,

    adjusted\_by INTEGER NOT NULL,

    quantity\_change INTEGER NOT NULL, \-- e.g. \-2 or \+5

    reason TEXT NOT NULL CHECK(reason IN ('DAMAGE', 'PHYSICAL\_AUDIT', 'DEFECTIVE\_BATCH', 'INTERNAL\_USE')),

    notes TEXT,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(part\_id) REFERENCES parts(id),

    FOREIGN KEY(adjusted\_by) REFERENCES users(id)

);

### 2.5 Purchases & Goods Receipt Notes (GRN)

CREATE TABLE purchases\_grn (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    supplier\_id INTEGER NOT NULL,

    supplier\_invoice\_no TEXT,

    purchase\_date DATE NOT NULL,

    total\_amount REAL NOT NULL,

    created\_by INTEGER NOT NULL,

    notes TEXT,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(supplier\_id) REFERENCES suppliers(id),

    FOREIGN KEY(created\_by) REFERENCES users(id)

);

CREATE TABLE purchase\_items\_grn (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    grn\_id INTEGER NOT NULL,

    part\_id INTEGER NOT NULL,

    quantity\_received INTEGER NOT NULL,

    unit\_purchase\_price REAL NOT NULL,

    line\_total REAL NOT NULL,

    FOREIGN KEY(grn\_id) REFERENCES purchases\_grn(id) ON DELETE CASCADE,

    FOREIGN KEY(part\_id) REFERENCES parts(id)

);

### 2.6 Sales & POS Invoices

CREATE TABLE sales (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    bill\_number INTEGER NOT NULL UNIQUE, \-- Sequential invoice number

    customer\_id INTEGER,                \-- Nullable for anonymous walk-in counter sales

    salesman\_id INTEGER,                \-- DSO / Booker who originated the wholesale order

    route\_id INTEGER,

    sale\_type TEXT NOT NULL CHECK(sale\_type IN ('RETAIL', 'WHOLESALE')),

    gross\_amount REAL NOT NULL,

    discount\_amount REAL DEFAULT 0.0,

    net\_amount REAL NOT NULL,

    paid\_amount REAL NOT NULL,

    previous\_balance REAL DEFAULT 0.0,  \-- Snapshot of customer balance prior to this bill

    payment\_status TEXT NOT NULL CHECK(payment\_status IN ('PAID', 'PARTIAL', 'CREDIT')),

    created\_by INTEGER NOT NULL,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(customer\_id) REFERENCES customers(id),

    FOREIGN KEY(salesman\_id) REFERENCES employees(id),

    FOREIGN KEY(route\_id) REFERENCES routes(id),

    FOREIGN KEY(created\_by) REFERENCES users(id)

);

CREATE TABLE sale\_items (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    sale\_id INTEGER NOT NULL,

    part\_id INTEGER NOT NULL,

    unit\_rate REAL NOT NULL,

    quantity INTEGER NOT NULL,

    line\_total REAL NOT NULL,

    FOREIGN KEY(sale\_id) REFERENCES sales(id) ON DELETE CASCADE,

    FOREIGN KEY(part\_id) REFERENCES parts(id)

);

### 2.7 Returns & Claims Workflow

CREATE TABLE return\_claims (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    sale\_id INTEGER NOT NULL,

    requested\_by INTEGER NOT NULL,

    approved\_by INTEGER,

    claim\_status TEXT NOT NULL DEFAULT 'PENDING' CHECK(claim\_status IN ('PENDING', 'APPROVED', 'REJECTED')),

    total\_refund\_amount REAL NOT NULL,

    rejection\_reason TEXT,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    updated\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(sale\_id) REFERENCES sales(id),

    FOREIGN KEY(requested\_by) REFERENCES users(id),

    FOREIGN KEY(approved\_by) REFERENCES users(id)

);

CREATE TABLE return\_claim\_items (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    claim\_id INTEGER NOT NULL,

    part\_id INTEGER NOT NULL,

    quantity INTEGER NOT NULL,

    refund\_rate REAL NOT NULL,

    line\_refund\_total REAL NOT NULL,

    inventory\_disposition TEXT NOT NULL DEFAULT 'SELLABLE' CHECK(inventory\_disposition IN ('SELLABLE', 'DEFECTIVE\_CLAIM')),

    FOREIGN KEY(claim\_id) REFERENCES return\_claims(id) ON DELETE CASCADE,

    FOREIGN KEY(part\_id) REFERENCES parts(id)

);

### 2.8 Expense Accounting

CREATE TABLE expenses (

    id INTEGER PRIMARY KEY AUTOINCREMENT,

    category TEXT NOT NULL, \-- RENT, ELECTRICITY, TEA\_MEALS, FUEL, MAINTENANCE, MISC

    amount REAL NOT NULL,

    payment\_mode TEXT DEFAULT 'CASH',

    description TEXT,

    recorded\_by INTEGER NOT NULL,

    expense\_date DATE NOT NULL,

    created\_at DATETIME DEFAULT CURRENT\_TIMESTAMP,

    FOREIGN KEY(recorded\_by) REFERENCES users(id)

);

---

## 3\. Printing Engine Specifications (2-Up Half-Page Layout)

* **Library:** `pdf` and `printing` Flutter packages.  
* **Target Paper Size:** ISO A4 (210mm × 297mm) configured with two identical landscape panels or cut half-page A5 (148mm × 210mm).  
* **Grid Specifications:**  
  * Top Margin: 8mm | Left/Right Margins: 10mm.  
  * Typography: Clean sans-serif (e.g., Roboto/Inter) paired with Google Noto Nastaliq Urdu / Noto Sans Arabic for Urdu text.  
* **Layout Blocks:**  
  1. **Header Section:** Centered bold shop title *"Arham Autos"*, Subtitle: *"Bagobhar Road Kotsmaba"*, Phone: *"0300-6748837"*.  
  2. **Metadata Split:** Two-column table with thin borders: Left box \= Customer Details & Route; Right box \= Bill \#, Date, Payment Terms.  
  3. **Tabular Itemization:** Line numbering, Dual English/Urdu description, Rate, Quantity \+ Unit (`Piece`), and Total.  
  4. **Summary Footer:** Previous Balance, Current Bill Amount, Total Outstanding.  
  5. **Attribution String:**  
     `"For Account Solution Contact AlphaSync Systems: 03140486627"`

---

## 4\. Encryption & Disaster Recovery Architecture

2. **SQLCipher Configuration:**  
   * At runtime, the Drift database establishes connection via `open.databaseFactory` binding to `sqlite3_flutter_libs` compiled with SQLCipher.  
   * Encryption key derived via PBKDF2 with 64,000 iterations using a secret salt established during the first-run wizard.  
2. **Encrypted Backup Routine:**  
   * The application uses SQLite's native VACUUM INTO / Online Backup API to serialize the encrypted database directly into a timestamped file: `{User_Selected_Folder}\ArhamAutos_Backup_{YYYYMMDD_HHMMSS}.bak`.  
3. **Master Key Recovery & Factory Reset Pipeline:**  
   * During first-run, a 16-digit alphanumeric token is generated (`A-Z, 0-9`), hashed with SHA-256, and stored in `system_configs`.  
   * A PDF certificate is rendered via the printing engine for physical storage by the owner.  
   * Factory reset wipes operational tables inside an atomic transaction while logging the event in `audit_logs`.

---

## 5\. Non-Functional & Ergonomic Requirements

1. **Native Desktop Scrollbars:**  
   * All scrollable widgets (`ListView`, `SingleChildScrollView`, `DataTable`) are wrapped in custom `ScrollbarThemeData` with visible thumb thickness (8px), track visibility, and cross-axis scrolling for wide tables to prevent Windows viewport clipping.  
2. **Web Conversion Readiness:**  
   * Codebase strictly adheres to Repository pattern interfaces. Switching the persistence provider from Drift SQLite to REST/GraphQL for future multi-branch web hosting will not affect UI or domain layers.  
3. **Dual Localization Engine:**  
   * `flutter_localizations` with JSON resource files (`en.json`, `ur.json`).  
   * Dynamic root rebuilding with `Directionality(textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr)`.