import 'package:drift/drift.dart';
import 'users.dart';

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get actionType => text()();
  TextColumn get details => text()();
  TextColumn get ipOrTerminal => text().withDefault(const Constant('LOCAL_TERMINAL'))();
  IntColumn get userId => integer().nullable().references(Users, #id)();
  TextColumn get usernameSnapshot => text().nullable()();
  TextColumn get roleSnapshot => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class PartCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameEn => text()();
  TextColumn get nameUr => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get barcode => text().nullable()();
  TextColumn get nameEn => text()();
  TextColumn get nameUr => text().nullable()();
  TextColumn get brand => text().nullable()();
  TextColumn get modelCompatibility => text().nullable()();
  IntColumn get categoryId => integer().references(PartCategories, #id)();
  TextColumn get unit => text().withDefault(const Constant('PCS'))();
  IntColumn get avgCostPaisa => integer().withDefault(const Constant(0))();
  IntColumn get retailPricePaisa => integer().withDefault(const Constant(0))();
  IntColumn get wholesalePricePaisa => integer().withDefault(const Constant(0))();
  TextColumn get shelfLocation => text().nullable()();
  IntColumn get defectiveStock => integer().withDefault(const Constant(0))();
  IntColumn get currentStock => integer().withDefault(const Constant(0))();
  IntColumn get minStockAlert => integer().withDefault(const Constant(10))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class StockAdjustments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get adjustedBy => integer().references(Users, #id)();
  IntColumn get quantityChange => integer()();
  TextColumn get reason => text()(); // DAMAGE, PHYSICAL_AUDIT, DEFECTIVE_BATCH, INTERNAL_USE
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shopName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get routeId => integer().nullable().references(Routes, #id)();
  TextColumn get customerType => text().withDefault(const Constant('RETAIL'))();
  IntColumn get creditLimitPaisa => integer().nullable()(); // null means unconstrained
  IntColumn get currentBalancePaisa => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class CustomerLedgerEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id)();
  IntColumn get invoiceId => integer().nullable()();
  TextColumn get entryType => text()(); // INVOICE_DEBIT, PAYMENT_CREDIT, RETURN_CREDIT, ADJUSTMENT
  IntColumn get debitAmountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get creditAmountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get runningBalancePaisa => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get billNumber => integer().unique()();
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  IntColumn get salesmanId => integer().nullable().references(Employees, #id)();
  IntColumn get routeId => integer().nullable().references(Routes, #id)();
  TextColumn get saleType => text()(); // RETAIL, WHOLESALE
  IntColumn get grossAmountPaisa => integer()();
  IntColumn get discountAmountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get netAmountPaisa => integer()();
  IntColumn get paidAmountPaisa => integer()();
  IntColumn get previousBalancePaisa => integer().withDefault(const Constant(0))();
  TextColumn get paymentStatus => text()(); // PAID, PARTIAL, CREDIT
  IntColumn get createdBy => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get unitRatePaisa => integer()();
  IntColumn get qty => integer()();
  IntColumn get lineTotalPaisa => integer()();
}

class Routes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get city => text().withDefault(const Constant('Kot Samba'))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text()(); // SALESMAN, CASHIER, SHOP_BOY
  IntColumn get assignedRouteId => integer().nullable().references(Routes, #id)();
  IntColumn get monthlySalaryPaisa => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()(); // RENT, ELECTRICITY, TEA_MEALS, FUEL, MAINTENANCE, MISC
  IntColumn get amountPaisa => integer()();
  TextColumn get paymentMode => text().withDefault(const Constant('CASH'))();
  TextColumn get description => text().nullable()();
  IntColumn get recordedBy => integer().references(Users, #id)();
  DateTimeColumn get expenseDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class ReturnClaims extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get requestedBy => integer().references(Users, #id)();
  IntColumn get approvedBy => integer().nullable().references(Users, #id)();
  TextColumn get claimStatus => text().withDefault(const Constant('PENDING'))(); // PENDING, APPROVED, REJECTED
  IntColumn get totalRefundAmountPaisa => integer()();
  TextColumn get rejectionReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
}

class ReturnClaimItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get claimId => integer().references(ReturnClaims, #id)();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get quantity => integer()();
  IntColumn get refundRatePaisa => integer()();
  IntColumn get lineRefundTotalPaisa => integer()();
  TextColumn get inventoryDisposition => text().withDefault(const Constant('SELLABLE'))(); // SELLABLE, DEFECTIVE_CLAIM
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get company => text().nullable()();
  TextColumn get address => text().nullable()();
  IntColumn get currentBalancePaisa => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class PurchasesGrn extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().nullable().references(Suppliers, #id)();
  TextColumn get supplierInvoiceNo => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get totalAmountPaisa => integer()();
  IntColumn get createdBy => integer().references(Users, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class PurchaseItemsGrn extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get grnId => integer().references(PurchasesGrn, #id)();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get quantityReceived => integer()();
  IntColumn get unitPurchasePricePaisa => integer()();
  IntColumn get lineTotalPaisa => integer()();
}

class SupplierLedgerEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  IntColumn get grnId => integer().nullable().references(PurchasesGrn, #id)();
  TextColumn get entryType => text()(); // PURCHASE_PAYABLE, PAYMENT_PAID, RETURN_DEBIT
  IntColumn get debitAmountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get creditAmountPaisa => integer().withDefault(const Constant(0))();
  IntColumn get runningBalancePaisa => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
