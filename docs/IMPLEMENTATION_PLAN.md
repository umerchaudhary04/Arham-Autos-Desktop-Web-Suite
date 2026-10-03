# Implementation Plan & Engineering Roadmap

**Project:** Arham Autos POS & Management System  
**Version:** 1.0.0  
**Technology Partner:** AlphaSync Systems (Private) Limited  
**Target Completion:** 6 Weeks

---

## 1\. Project Phasing & Milestone Breakdown

\+-------------------------------------------------------------------------------------------------+

| W1: Phase 1 \- Foundation, Security & Database Setup                                             |

| • Scaffold Flutter project (Windows Desktop \+ Web)                                              |

| • Implement Drift ORM \+ SQLCipher 256-bit AES encryption layer                                  |

| • Build First-Run Setup Wizard (Language, Backup Path, 16-digit Master Key, Manager PIN)       |

| • Build Authentication Gate & RBAC Permission Guards (Manager vs Operator)                      |

\+-------------------------------------------------------------------------------------------------+

                                                |

                                                v

\+-------------------------------------------------------------------------------------------------+

| W2: Phase 2 \- Inventory, Parts Catalog, Barcodes & Purchases (GRN)                              |

| • Parts Catalog CRUD (dual retail/wholesale pricing, Urdu/English names, location tracking)     |

| • Stock adjustments & Low-Stock alert engine (Threshold \<= 10 units)                            |

| • Custom Barcode Studio (Code-128 generator & sticker print layouts)                            |

| • Supplier master & Purchases/GRN receiving workflow (auto-inventory increment & moving cost)   |

\+-------------------------------------------------------------------------------------------------+

                                                |

                                                v

\+-------------------------------------------------------------------------------------------------+

| W3: Phase 3 \- POS Billing Engine, Khata Ledgers & Invoice Printing                              |

| • Fast keyboard-driven POS counter terminal with instant search and barcode input               |

| • Automatic B2B wholesale vs B2C retail pricing resolution                                      |

| • Customer Khata integration (credit balance tracking, limit verification, Manager PIN override)|

| • Re-engineered 2-up Half-Page (A5/A4) invoice printing with AlphaSync Systems footer            |

\+-------------------------------------------------------------------------------------------------+

                                                |

                                                v

\+-------------------------------------------------------------------------------------------------+

| W4: Phase 4 \- Returns Workflow, Expense Accounting, Routes & Analytics                          |

| • Returns & Claims two-step approval flow (Operator draft / Manager approve or direct override) |

| • Return triage (Sellable stock vs Defective / Supplier claim pool)                             |

| • Operational expense journal & employee salary disbursement tracker                            |

| • Delivery route setup & salesman/DSO territory assignment                                      |

| • Reporting engine (Sales, COGS, Gross/Net Margins) with Excel (.xlsx) and CSV export           |

\+-------------------------------------------------------------------------------------------------+

                                                |

                                                v

\+-------------------------------------------------------------------------------------------------+

| W5: Phase 5 \- Disaster Recovery, Localization, Antigravity UI/UX & Polish                       |

| • Encrypted \`.bak\` backup engine (Backup Now button \+ designated local directory sync)          |

| • Protected Factory Reset requiring Manager PIN \+ 16-digit Master Key verification              |

| • Full bilingual localization (English LTR & Urdu Nastaliq RTL)                                 |

| • Windows-native scrollbars and viewport responsive optimization                                |

| • "About" section integration featuring AlphaSync Systems credentials                           |

\+-------------------------------------------------------------------------------------------------+

                                                |

                                                v

\+-------------------------------------------------------------------------------------------------+

| W6: Phase 6 \- Quality Assurance, Security Audit & On-Premises Deployment                        |

| • Stress testing offline database with 50,000+ SKU records                                      |

| • Thermal and A4 laser printer verification across Windows 10 & 11                              |

| • Release build compilation (.exe Windows installer) & client handoff documentation             |

\+-------------------------------------------------------------------------------------------------+

---

## 2\. Granular Task Matrix & Acceptance Criteria

### Phase 1: Foundation, Security & Database Setup

* **Tasks:**  
  1. Configure Flutter project repository targeting Windows Desktop and Web platform.  
  2. Implement Drift database schema with SQLCipher binding and PBKDF2 key derivation.  
  3. Create `SetupWizardView`:  
     * Step 1: Language selection (English / Urdu).  
     * Step 2: Backup folder selection via Windows Folder Picker.  
     * Step 3: Cryptographic generation of 16-digit Master Security Key with "Print Certificate" button.  
     * Step 4: Manager username, password, and 4-digit PIN setup.  
  4. Build PINpad login screen with session manager and RBAC route guard.  
* **Acceptance Criteria:** App detects first run, forces wizard completion, stores encrypted credentials in local database, and locks when idle timer expires.

### Phase 2: Inventory, Catalog, Barcodes & Purchases (GRN)

* **Tasks:**  
  1. Parts master CRUD screen with dual pricing (`retail_price`, `wholesale_price`), bilingual title fields, and shelf location.  
  2. Stock adjustments dialog with compulsory reason tagging.  
  3. Barcode Studio widget generating Code-128 barcode stickers.  
  4. Purchases / GRN receiving screen: Add vendor bill, line items, and auto-update stock upon posting.  
* **Acceptance Criteria:** Adding a part reflects immediately; creating a GRN updates warehouse stock and updates unit cost; items with quantity \$\\le 10\$ appear in shortage lists.

### Phase 3: POS Billing Engine, Khata Ledgers & Invoicing

* **Tasks:**  
  1. POS sales counter interface with hotkeys (`F1`\-`F9`).  
  2. Dynamic price selection: Retail default, Wholesale upon selecting B2B client.  
  3. Customer credit limit validation: If `New Balance > Limit`, prompt for Manager PIN authorization.  
  4. Invoice printing engine producing 2-up half-page layout matching the reference sample with: `"For Account Solution Contact AlphaSync Systems: 03140486627"`.  
  5. Immutability enforcement: Finalized invoices cannot be edited or deleted.  
* **Acceptance Criteria:** Fast barcode scan and item addition; seamless credit bill generation; exact A5/half-A4 laser print preview.

### Phase 4: Returns, Expenses, Routes & Analytics

* **Tasks:**  
  1. Returns module: Search by `Invoice ID`.  
  2. Operator can submit claim; Manager can approve or directly process return.  
  3. Triage selection on return approval: Restock into sellable stock or route to defective/supplier claim pool.  
  4. Daily expense journal with category tagging (Rent, Fuel, Tea, Electricity).  
  5. Employee directory with route assignment for salesmen.  
  6. Reports module computing COGS, Gross Profit, and Net Profit, with one-click Excel (.xlsx) and CSV export.  
* **Acceptance Criteria:** Operator claims do not affect stock until Manager approves; Excel export produces properly formatted tables with column headers.

### Phase 5: Backup, Disaster Recovery, Localization & UI Polish

* **Tasks:**  
  1. Encrypted backup generation (`.bak` files) saved to the designated local drive.  
  2. Factory reset verification requiring active Manager PIN \+ 16-digit Master Key.  
  3. Audit log persistence verification across factory reset.  
  4. Urdu Nastaliq/Naskh typography integration with complete RTL UI mirroring.  
  5. Antigravity UI styling: Windows-native scrollbars on tables and list views.  
  6. "About" section modal populated with AlphaSync Systems (Private) Limited information.  
* **Acceptance Criteria:** Backup restores reliably on test machine; Urdu mode flips entire UI cleanly without overflow errors; About dialog displays all contact channels.

### Phase 6: Testing, Hardening & Deployment

* **Tasks:**  
  1. Load test with 50,000 spare parts and 100,000 ledger entries.  
  2. Offline power-interruption test during checkout to confirm SQLite WAL integrity.  
  3. Build production Windows x64 `.exe` installer.  
  4. Prepare Client User Manual and Quick Reference Cheat Sheet.  
* **Acceptance Criteria:** Zero data corruption on simulated crash; sub-50ms query response on large datasets; single-click installer.

---

## 3\. Risk Assessment & Mitigation Strategies

| Risk Description | Severity | Probability | Mitigation Strategy |
| :---- | :---: | :---: | :---- |
| **Loss of 16-Digit Master Key by Owner** | High | Low | Setup Wizard forces the owner to print a physical "Master Key Recovery Certificate" before allowing the system to proceed. |
| **Accidental Incomplete Transactions during Power Cut** | Medium | Medium | SQLite Write-Ahead Logging (WAL) and strict ACID transactional blocks ensure zero database corruption upon sudden power loss. |
| **Credit Default by B2B Customers** | High | Medium | Hard credit limits on customer profiles prevent operators from issuing goods on credit without on-screen Manager PIN override. |
| **Urdu Font Rendering & RTL Clipping** | Low | Medium | Custom `ScrollbarThemeData` with horizontal scrolling support and Google Noto Nastaliq Urdu font integration. |

