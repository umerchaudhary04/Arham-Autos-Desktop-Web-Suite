# Phase 2 Verification Report (Inventory & Purchases)

## Overview
This report validates the implementation of Phase 2 (Inventory, Parts Catalog, Barcodes & Purchases) in the codebase against Sections 2.4 and 2.5 of the TRD.

## Findings

### 1. Parts Table (Inventory & Parts Catalog - TRD 2.4)
**Status:** **FAIL/MISSING**
* **Dual Pricing:** Implemented correctly. `retailPricePaisa` and `wholesalePricePaisa` are present and integrated into the UI (`part_form_dialog.dart`).
* **min_stock_alert:** Partially implemented. The column exists in Drift (`minStockAlert`), but it is not configurable in the UI (`part_form_dialog.dart`).
* **Missing Database Columns:**
  * `brand` (TEXT) - Missing in `all_tables.dart`
  * `model_compatibility` (TEXT) - Missing in `all_tables.dart`
  * `is_active` (BOOLEAN NOT NULL DEFAULT 1) - Missing in `all_tables.dart`
  * `created_at` (DATETIME DEFAULT CURRENT_TIMESTAMP) - Missing in `all_tables.dart`
* **Missing UI Fields:** The `part_form_dialog.dart` is missing input fields for `barcode`, `brand`, `model_compatibility`, and `min_stock_alert`.

### 2. Stock Adjustments (TRD 2.4)
**Status:** **FAIL/MISSING**
* **Implementation:** The table is implemented as `StockMovements` instead of `stock_adjustments`.
* **Missing Constraints:** The TRD requires a `reason` field restricted to `('DAMAGE', 'PHYSICAL_AUDIT', 'DEFECTIVE_BATCH', 'INTERNAL_USE')`. In `stock_adjustment_dialog.dart` and `all_tables.dart`, it relies on `movementType` ('ADJ_IN', 'ADJ_OUT') and an open `notes` text field, failing to enforce the strict reason validation.

### 3. Purchases & GRN (TRD 2.5)
**Status:** **FAIL/MISSING**
* **Implementation:** Implemented as `Purchases` and `PurchaseItems` instead of `purchases_grn` and `purchase_items_grn`.
* **Missing Fields in Purchases (`purchases_grn`):**
  * `purchase_date` (DATE NOT NULL) - Missing in `all_tables.dart`.
  * `notes` (TEXT) - Missing in `all_tables.dart`.
* **Missing Fields in PurchaseItems (`purchase_items_grn`):**
  * `line_total` (REAL NOT NULL) - Missing in `all_tables.dart`.

## Conclusion
The core functionality for dual pricing and GRN workflows exists, but several database schema requirements (specific columns and check constraints) are missing. The UI logic is lacking the necessary fields to collect the missing data.
