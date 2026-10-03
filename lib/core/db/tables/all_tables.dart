import 'package:drift/drift.dart';
import 'users.dart';

class AuditLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()();
  TextColumn get details => text().nullable()();
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
  IntColumn get categoryId => integer().references(PartCategories, #id)();
  TextColumn get unit => text().withDefault(const Constant('PCS'))();
  IntColumn get avgCostPaisa => integer().withDefault(const Constant(0))();
  IntColumn get retailPricePaisa => integer().withDefault(const Constant(0))();
  IntColumn get wholesalePricePaisa => integer().withDefault(const Constant(0))();
  TextColumn get shelfLocation => text().nullable()();
  IntColumn get defectiveStock => integer().withDefault(const Constant(0))();
  IntColumn get currentStock => integer().withDefault(const Constant(0))();
  IntColumn get minStockAlert => integer().withDefault(const Constant(10))();
}

class StockMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer().references(Parts, #id)();
  TextColumn get movementType => text()(); // GRN_IN, SALE_OUT, ADJ_IN, ADJ_OUT, etc.
  IntColumn get qtyChange => integer()();
  IntColumn get unitCostPaisa => integer()();
  TextColumn get refTable => text().nullable()();
  IntColumn get refId => integer().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shopName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  // routeId could be added later if needed
  TextColumn get customerType => text().withDefault(const Constant('RETAIL'))();
  IntColumn get creditLimitPaisa => integer().nullable()(); // null means unconstrained
  IntColumn get currentBalancePaisa => integer().withDefault(const Constant(0))();
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
  // salesman_id, route_id can be added later
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

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  IntColumn get amountPaisa => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get recordedBy => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get company => text().nullable()();
  IntColumn get currentBalancePaisa => integer().withDefault(const Constant(0))();
}

class Purchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().nullable().references(Suppliers, #id)();
  TextColumn get vendorBillNo => text().nullable()();
  IntColumn get totalAmountPaisa => integer()();
  IntColumn get recordedBy => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

class PurchaseItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get purchaseId => integer().references(Purchases, #id)();
  IntColumn get partId => integer().references(Parts, #id)();
  IntColumn get qty => integer()();
  IntColumn get unitCostPaisa => integer()();
}
