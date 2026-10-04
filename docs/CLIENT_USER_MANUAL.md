# Arham Autos POS & Inventory Management System
## Client User Manual

### 1. Introduction
Welcome to the Arham Autos POS System, designed specifically for your auto parts retail and wholesale business. This system ensures fast billing, secure data management, and comprehensive inventory tracking.

### 2. Initial Setup & Security
- **Master Key**: During the first run, a 16-digit alphanumeric Master Security Key is generated. Keep this certificate safe! It is required for factory resets and disaster recovery.
- **Roles**:
  - *Manager*: Full access to reports, ledger overrides, returns approval, and system settings.
  - *Operator*: Standard billing, barcoding, and inventory lookup. Cannot override credit limits.

### 3. Inventory & Parts Catalog
- **Adding Parts**: Navigate to the Parts section. Enter the item details, including Retail and Wholesale prices.
- **Barcodes**: Use the Barcode Studio to print Code-128 stickers for easy scanning at the counter.
- **Stock Adjustments**: When updating stock manually, a reason must be provided (Damage, Defect, etc.) for auditing.

### 4. POS Billing Engine
- **Quick Billing**: Scan a barcode or use the search bar. Use hotkeys (F1-F9) for rapid access.
- **Pricing**: The system defaults to Retail pricing. Selecting a B2B wholesale customer will automatically switch to Wholesale rates.
- **Credit Limits**: If a customer's bill exceeds their approved limit, the Manager PIN is required.

### 5. Khata (Ledgers) & Suppliers
- Keep track of customer dues and supplier payables.
- Generate statements for any period.

### 6. Backup & Disaster Recovery
- Go to Settings -> Backup Now to generate a `.bak` encrypted backup.
- In case of hardware failure, use this file to restore your entire database.

---
*For Account Solution Contact AlphaSync Systems: 03140486627*
