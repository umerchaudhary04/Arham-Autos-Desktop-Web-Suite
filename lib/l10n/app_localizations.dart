import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Arham Autos'**
  String get appTitle;

  /// No description provided for @wizardTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Wizard'**
  String get wizardTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @shellTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get shellTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @posTerminal.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get posTerminal;

  /// No description provided for @partsCatalog.
  ///
  /// In en, this message translates to:
  /// **'Parts Catalog'**
  String get partsCatalog;

  /// No description provided for @purchasesGrn.
  ///
  /// In en, this message translates to:
  /// **'Purchases / GRN'**
  String get purchasesGrn;

  /// No description provided for @khataLedger.
  ///
  /// In en, this message translates to:
  /// **'Khata Ledger'**
  String get khataLedger;

  /// No description provided for @returnsClaims.
  ///
  /// In en, this message translates to:
  /// **'Returns & Claims'**
  String get returnsClaims;

  /// No description provided for @expenseJournal.
  ///
  /// In en, this message translates to:
  /// **'Expense Journal'**
  String get expenseJournal;

  /// No description provided for @employeesHr.
  ///
  /// In en, this message translates to:
  /// **'Employees & HR'**
  String get employeesHr;

  /// No description provided for @routesAreas.
  ///
  /// In en, this message translates to:
  /// **'Routes & Areas'**
  String get routesAreas;

  /// No description provided for @reportsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get reportsAnalytics;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Settings & Security'**
  String get settingsSecurity;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel (.xlsx)'**
  String get exportExcel;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV (.csv)'**
  String get exportCsv;

  /// No description provided for @grossTotal.
  ///
  /// In en, this message translates to:
  /// **'Gross Total'**
  String get grossTotal;

  /// No description provided for @netPayable.
  ///
  /// In en, this message translates to:
  /// **'Net Payable'**
  String get netPayable;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @retail.
  ///
  /// In en, this message translates to:
  /// **'Retail (B2C)'**
  String get retail;

  /// No description provided for @wholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale (B2B)'**
  String get wholesale;

  /// No description provided for @creditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get creditLimit;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @attributionFooter.
  ///
  /// In en, this message translates to:
  /// **'For Account Solution Contact AlphaSync Systems: 03140486627'**
  String get attributionFooter;

  /// No description provided for @totalInventoryValue.
  ///
  /// In en, this message translates to:
  /// **'Total Inventory Value'**
  String get totalInventoryValue;

  /// No description provided for @dailyGrossProfit.
  ///
  /// In en, this message translates to:
  /// **'Daily Gross Profit'**
  String get dailyGrossProfit;

  /// No description provided for @dailyGrossSales.
  ///
  /// In en, this message translates to:
  /// **'Daily Gross Sales'**
  String get dailyGrossSales;

  /// No description provided for @lowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get lowStockAlerts;

  /// No description provided for @recentSales.
  ///
  /// In en, this message translates to:
  /// **'Recent Sales'**
  String get recentSales;

  /// No description provided for @reprintReceipt.
  ///
  /// In en, this message translates to:
  /// **'Reprint Receipt'**
  String get reprintReceipt;

  /// No description provided for @barcodeInput.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode or Search Part...'**
  String get barcodeInput;

  /// No description provided for @holdBill.
  ///
  /// In en, this message translates to:
  /// **'Hold Bill (F6)'**
  String get holdBill;

  /// No description provided for @recallBill.
  ///
  /// In en, this message translates to:
  /// **'Recall Bill (F7)'**
  String get recallBill;

  /// No description provided for @finalizeSale.
  ///
  /// In en, this message translates to:
  /// **'Finalize Sale (F12)'**
  String get finalizeSale;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get clearCart;

  /// No description provided for @walkInCustomer.
  ///
  /// In en, this message translates to:
  /// **'Walk-in Retail Customer'**
  String get walkInCustomer;

  /// No description provided for @receivedAmount.
  ///
  /// In en, this message translates to:
  /// **'Received Amount'**
  String get receivedAmount;

  /// No description provided for @changeDue.
  ///
  /// In en, this message translates to:
  /// **'Change Due'**
  String get changeDue;

  /// No description provided for @parkedCartsBadge.
  ///
  /// In en, this message translates to:
  /// **'Parked Carts'**
  String get parkedCartsBadge;

  /// No description provided for @partCode.
  ///
  /// In en, this message translates to:
  /// **'Part Code'**
  String get partCode;

  /// No description provided for @partNameEn.
  ///
  /// In en, this message translates to:
  /// **'Part Name (English)'**
  String get partNameEn;

  /// No description provided for @partNameUr.
  ///
  /// In en, this message translates to:
  /// **'Part Name (Urdu)'**
  String get partNameUr;

  /// No description provided for @shelfLocation.
  ///
  /// In en, this message translates to:
  /// **'Rack / Shelf'**
  String get shelfLocation;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @avgCost.
  ///
  /// In en, this message translates to:
  /// **'Average Cost'**
  String get avgCost;

  /// No description provided for @retailPrice.
  ///
  /// In en, this message translates to:
  /// **'Retail Price'**
  String get retailPrice;

  /// No description provided for @wholesalePrice.
  ///
  /// In en, this message translates to:
  /// **'Wholesale Price'**
  String get wholesalePrice;

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add New Part'**
  String get addPart;

  /// No description provided for @adjustStock.
  ///
  /// In en, this message translates to:
  /// **'Adjust Stock'**
  String get adjustStock;

  /// No description provided for @supplierInvoiceNo.
  ///
  /// In en, this message translates to:
  /// **'Supplier Invoice No.'**
  String get supplierInvoiceNo;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get supplierName;

  /// No description provided for @postGrn.
  ///
  /// In en, this message translates to:
  /// **'Post GRN'**
  String get postGrn;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get addSupplier;

  /// No description provided for @customerKhata.
  ///
  /// In en, this message translates to:
  /// **'Customer Khata (Receivables)'**
  String get customerKhata;

  /// No description provided for @supplierKhata.
  ///
  /// In en, this message translates to:
  /// **'Supplier Khata (Payables)'**
  String get supplierKhata;

  /// No description provided for @recordRecovery.
  ///
  /// In en, this message translates to:
  /// **'Record Recovery'**
  String get recordRecovery;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @agingReceivables.
  ///
  /// In en, this message translates to:
  /// **'Aging Accounts Receivable'**
  String get agingReceivables;

  /// No description provided for @returnDraft.
  ///
  /// In en, this message translates to:
  /// **'Return Draft'**
  String get returnDraft;

  /// No description provided for @approveReturn.
  ///
  /// In en, this message translates to:
  /// **'Approve Return'**
  String get approveReturn;

  /// No description provided for @returnToStock.
  ///
  /// In en, this message translates to:
  /// **'Return to Sellable Stock'**
  String get returnToStock;

  /// No description provided for @moveDefective.
  ///
  /// In en, this message translates to:
  /// **'Move to Defective Claim'**
  String get moveDefective;

  /// No description provided for @dailyExpenseJournal.
  ///
  /// In en, this message translates to:
  /// **'Daily Expense Journal'**
  String get dailyExpenseJournal;

  /// No description provided for @chartOfAccounts.
  ///
  /// In en, this message translates to:
  /// **'General Ledger & Chart of Accounts'**
  String get chartOfAccounts;

  /// No description provided for @cashInHand.
  ///
  /// In en, this message translates to:
  /// **'Cash-in-Hand'**
  String get cashInHand;

  /// No description provided for @operatingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Operating Expenses'**
  String get operatingExpenses;

  /// No description provided for @netOperatingProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Operating Profit'**
  String get netOperatingProfit;

  /// No description provided for @staffPayroll.
  ///
  /// In en, this message translates to:
  /// **'Employees & HR Payroll'**
  String get staffPayroll;

  /// No description provided for @monthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary'**
  String get monthlySalary;

  /// No description provided for @disburseSalary.
  ///
  /// In en, this message translates to:
  /// **'Disburse Salary'**
  String get disburseSalary;

  /// No description provided for @salesmanDso.
  ///
  /// In en, this message translates to:
  /// **'Salesman (DSO)'**
  String get salesmanDso;

  /// No description provided for @routesTerritories.
  ///
  /// In en, this message translates to:
  /// **'Territories & Routes Distribution'**
  String get routesTerritories;

  /// No description provided for @mappedShops.
  ///
  /// In en, this message translates to:
  /// **'Mapped Workshops & Retailers'**
  String get mappedShops;

  /// No description provided for @assignSalesman.
  ///
  /// In en, this message translates to:
  /// **'Assign Salesman'**
  String get assignSalesman;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial & Margin Summary'**
  String get financialSummary;

  /// No description provided for @deadStockReport.
  ///
  /// In en, this message translates to:
  /// **'Dead Stock (Zero-Movement)'**
  String get deadStockReport;

  /// No description provided for @movementVelocity.
  ///
  /// In en, this message translates to:
  /// **'Movement Velocity (ABC Analysis)'**
  String get movementVelocity;

  /// No description provided for @lockedCapital.
  ///
  /// In en, this message translates to:
  /// **'Locked Up Capital'**
  String get lockedCapital;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management (RBAC)'**
  String get userManagement;

  /// No description provided for @auditTrail.
  ///
  /// In en, this message translates to:
  /// **'Immutable Audit Trail'**
  String get auditTrail;

  /// No description provided for @idleAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Terminal Auto-Lock'**
  String get idleAutoLock;

  /// No description provided for @databaseBackup.
  ///
  /// In en, this message translates to:
  /// **'Encrypted Database Backup'**
  String get databaseBackup;

  /// No description provided for @resetPin.
  ///
  /// In en, this message translates to:
  /// **'Reset PIN / Password'**
  String get resetPin;

  /// No description provided for @factoryReset.
  ///
  /// In en, this message translates to:
  /// **'Factory Reset'**
  String get factoryReset;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
