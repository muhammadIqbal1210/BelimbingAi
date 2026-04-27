# Belimbing Bank Flutter - Quick Reference Guide

## 📱 Project Structure at a Glance

```
lib/
├── main.dart                    # Entry point dengan MultiProvider
├── models/                      # Data models
├── services/                    # API service (bank_api_service.dart)
├── controllers/                 # State management (Provider)
├── views/
│   ├── screens/                 # Main screens (5 screens)
│   └── widgets/                 # Reusable widgets
├── constants/                   # Theme, colors, app constants
└── utils/                       # Helpers & utilities
```

## 🎯 Main Screens

| Screen | Route | Purpose |
|--------|-------|---------|
| Dashboard | / | Home screen dengan summary & navigation |
| Customer Management | /customers | CRUD Customer |
| Account Management | /accounts | CRUD Account |
| Transaction | /transaction | Input Deposit/Withdraw |
| Result View | /result | Display hasil transaksi |

## 🔧 Quick Configuration

### 1. Update API Base URL
**File**: `lib/services/bank_api_service.dart` (line 7)
```dart
static const String baseUrl = 'http://your-api-endpoint/api';
```

### 2. Update App Theme
**File**: `lib/constants/app_theme.dart`
```dart
// Primary color
static const Color primary = Color(0xFF1F77D2);
// Change to your brand color
```

### 3. Add New Screen
```dart
// 1. Create screen in lib/views/screens/
// 2. Create controller in lib/controllers/
// 3. Add to MultiProvider in main.dart
// 4. Add route in main.dart routes
```

## 📝 API Endpoints Expected

```
CUSTOMERS
GET    /api/customers
GET    /api/customers/{id}
POST   /api/customers
PUT    /api/customers/{id}
DELETE /api/customers/{id}

ACCOUNTS
GET    /api/accounts
GET    /api/accounts/{id}
GET    /api/customers/{customerId}/accounts
POST   /api/accounts
PUT    /api/accounts/{id}
DELETE /api/accounts/{id}

TRANSACTIONS
GET    /api/transactions
GET    /api/accounts/{accountId}/transactions
POST   /api/transactions/deposit
POST   /api/transactions/withdraw

DEPOSITO TYPES
GET    /api/deposito-types
GET    /api/deposito-types/{id}
```

## 🏗️ Controller Usage Pattern

```dart
// Access controller
final controller = context.read<CustomerController>();

// Or use Consumer for reactive updates
Consumer<CustomerController>(
  builder: (context, controller, _) {
    if (controller.isLoading) return LoadingWidget();
    if (controller.errorMessage != null) return ErrorWidget();
    return ListView(...);
  },
)

// Call controller method
context.read<CustomerController>().fetchCustomers();
context.read<CustomerController>().createCustomer(...);
```

## 🎨 Utility Functions

### Date & Currency Formatting
```dart
import 'package:frontend/utils/helpers.dart';

// Format date
String formatted = DateTimeUtil.formatDate(DateTime.now());
// Output: 22/04/2024

// Format currency
String formatted = DateTimeUtil.formatCurrency(5000000);
// Output: Rp. 5.000.000,00
```

### Validation
```dart
// Email validation
String? error = ValidationUtil.validateEmail('test@example.com');

// Phone validation
String? error = ValidationUtil.validatePhoneNumber('08123456789');

// Amount validation
String? error = ValidationUtil.validateAmount('1000000');

// Not empty validation
String? error = ValidationUtil.validateNotEmpty('value', 'Field Name');
```

## 🔌 Provider Setup

All providers are already setup in `main.dart`:

```dart
MultiProvider(
  providers: [
    Provider<BankApiService>(...),
    ChangeNotifierProvider<CustomerController>(...),
    ChangeNotifierProvider<AccountController>(...),
    ChangeNotifierProvider<TransactionController>(...),
    ChangeNotifierProvider<DepositoTypeController>(...),
  ],
  ...
)
```

## 💾 Generated Files

When you run build_runner, these files are generated automatically:

```
lib/models/customer.g.dart       # JSON serialization for Customer
lib/models/account.g.dart        # JSON serialization for Account
lib/models/deposito_type.g.dart  # JSON serialization for DepositoType
lib/models/transaction.g.dart    # JSON serialization for Transaction
lib/models/api_response.g.dart   # JSON serialization for ApiResponse
```

**Don't edit these files manually!** They're auto-generated.

## 🚀 First Time Setup Commands

```bash
# Navigate to project
cd "d:\Proyek_NonKuliah\Belimbing AI\Frontend"

# Get dependencies
flutter pub get

# Generate serializable files
flutter pub run build_runner build

# Run app
flutter run
```

## 🐛 Troubleshooting Quick Fixes

| Issue | Solution |
|-------|----------|
| "Missing .g.dart files" | Run: `flutter pub run build_runner build` |
| "Provider not found" | Check main.dart MultiProvider setup |
| "API returns 404" | Update base URL in bank_api_service.dart |
| "UI not updating" | Check if `notifyListeners()` is called |
| "Build errors" | Run: `flutter clean && flutter pub get` |

## 📋 Common Tasks

### Fetch Data
```dart
await context.read<CustomerController>().fetchCustomers();
```

### Create Data
```dart
await context.read<CustomerController>().createCustomer(
  customerName: 'John',
  customerAddress: '...',
  customerPhone: '...',
  customerEmail: '...',
);
```

### Update Data
```dart
await context.read<CustomerController>().updateCustomer(
  customerId: 1,
  customerName: 'Updated Name',
  ...
);
```

### Delete Data
```dart
await context.read<CustomerController>().deleteCustomer(1);
```

### Navigate to Screen
```dart
Navigator.pushNamed(
  context,
  '/transaction',
  arguments: accountObject,
);
```

## 🎨 Color Scheme

**Primary**: `#1F77D2` (Blue)
**Secondary**: `#00BCD4` (Cyan)
**Accent**: `#FF9800` (Orange)
**Success**: `#4CAF50` (Green)
**Error**: `#f44336` (Red)

Edit di `lib/constants/app_theme.dart` untuk customization.

## 📚 Important Files Reference

| File | Purpose | Key Edit |
|------|---------|----------|
| main.dart | App entry & routing | Add providers/routes |
| bank_api_service.dart | API communication | Update base URL |
| app_theme.dart | UI theme | Customize colors |
| app_constants.dart | Global constants | Add app-wide constants |
| helpers.dart | Utility functions | Add helper functions |

## ✅ Checklist Before Deployment

- [ ] API base URL updated
- [ ] All endpoints working & tested
- [ ] Theme customized for brand
- [ ] App icon updated
- [ ] App name updated in pubspec.yaml
- [ ] Privacy policies added if needed
- [ ] Error messages are user-friendly
- [ ] UI responsive on all devices
- [ ] No hardcoded values (use constants)
- [ ] Documentation updated

## 🔗 Useful Links

- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter Official Docs](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [HTTP Package](https://pub.dev/packages/http)

## 💡 Tips & Best Practices

1. **Always use Constants** instead of magic strings
2. **Always validate Input** before sending to API
3. **Always handle Errors** with user-friendly messages
4. **Always use const** for static widgets
5. **Always test API** endpoints with Postman first
6. **Keep Controllers** focused on business logic
7. **Keep Views** simple and presentational
8. **Use meaningful Names** for variables & functions

---

**For detailed documentation, see SETUP.md, ARCHITECTURE.md, and IMPLEMENTATION_CHECKLIST.md**
