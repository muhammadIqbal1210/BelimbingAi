# Belimbing Bank - Architecture Documentation

## 📐 Architecture Overview

Aplikasi ini mengikuti pola **Model-View-Controller (MVC)** dengan **State Management** menggunakan Provider.

### Layer Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    Presentation Layer (Views)                   │
│  - DashboardScreen, CustomerManagementScreen, etc.              │
│  - Widgets (Cards, Loading, Empty, Error)                      │
│  - User Interactions                                             │
└───────────────────────────────┬─────────────────────────────────┘
                                │
┌───────────────────────────────▼─────────────────────────────────┐
│              Business Logic Layer (Controllers)                  │
│  - CustomerController, AccountController, etc.                  │
│  - ChangeNotifier untuk State Management                         │
│  - Business Rules & Validations                                 │
└───────────────────────────────┬─────────────────────────────────┘
                                │
┌───────────────────────────────▼─────────────────────────────────┐
│                    Data Layer (Services)                         │
│  - BankApiService (HTTP Calls)                                  │
│  - API Integration                                               │
└───────────────────────────────┬─────────────────────────────────┘
                                │
┌───────────────────────────────▼─────────────────────────────────┐
│                      Data Models                                 │
│  - Customer, Account, Transaction, DepositoType                │
│  - JSON Serialization                                           │
└─────────────────────────────────────────────────────────────────┘
```

## 🔀 Data Flow

```
User Interaction (Tap, Input, etc.)
    ↓
View (Widget) detects interaction
    ↓
Call Controller method via context.read()
    ↓
Controller validates data
    ↓
Controller calls BankApiService method
    ↓
Service sends HTTP request to API
    ↓
API processes and returns response
    ↓
Service parses response ke Model
    ↓
Controller updates state (notifyListeners)
    ↓
View rebuilds via Consumer/Listener
    ↓
User sees updated UI
```

## 📁 Folder Structure Details

### `/models`
**Tanggung Jawab**: Data structure dan serialization

```
models/
├── customer.dart          # Class Customer dengan @JsonSerializable
├── account.dart           # Class Account dengan @JsonSerializable
├── deposito_type.dart     # Class DepositoType dengan @JsonSerializable
├── transaction.dart       # Class Transaction dengan @JsonSerializable
├── api_response.dart      # Generic wrapper untuk API responses
└── index.dart             # Central export file
```

**Key Features**:
- JSON serialization dengan `json_annotation`
- `copyWith` method untuk immutable updates
- Type-safe model classes
- Generated `.g.dart` files via build_runner

### `/services`
**Tanggung Jawab**: Komunikasi dengan API

```
services/
├── bank_api_service.dart  # Singleton API service
└── index.dart             # Central export file
```

**BankApiService Methods**:
- `getAllCustomers()`, `getCustomerById()`, `createCustomer()`, `updateCustomer()`, `deleteCustomer()`
- `getAllAccounts()`, `getAccountsByCustomerId()`, `createAccount()`, `updateAccount()`, `deleteAccount()`
- `getAllTransactions()`, `getAccountTransactions()`, `deposit()`, `withdraw()`
- `getAllDepositoTypes()`, `getDepositoTypeById()`

**Error Handling**: 
- Try-catch pada semua method
- Throw Exception dengan descriptive messages
- Status code checking

### `/controllers`
**Tanggung Jawab**: State management dan business logic

```
controllers/
├── customer_controller.dart       # Mengelola state customer
├── account_controller.dart        # Mengelola state account
├── transaction_controller.dart    # Mengelola state transaction
├── deposito_type_controller.dart  # Mengelola state deposito type
└── index.dart                     # Central export file
```

**Setiap Controller memiliki**:
- Properties: data list, selected item, loading state, error message
- Getters: untuk akses properties dari UI
- Methods: fetch, create, update, delete operations
- `notifyListeners()`: untuk update UI

**ChangeNotifier Base Class**:
```dart
class CustomerController extends ChangeNotifier {
  // State properties
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Methods with notifyListeners()
  Future<void> fetchCustomers() async {
    _isLoading = true;
    notifyListeners(); // Notify UI
    try {
      // ... logic
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### `/views/screens`
**Tanggung Jawab**: UI screens dan page layouts

```
views/screens/
├── dashboard_screen.dart              # Main dashboard
├── customer_management_screen.dart    # CRUD customer
├── account_management_screen.dart     # CRUD account
├── transaction_screen.dart            # Input transaksi
├── result_view_screen.dart           # Hasil transaksi
└── index.dart                         # Central export file
```

**Screen Responsibilities**:
- Build UI sesuai wireframe
- Consume data dari Controller via `Consumer<>`
- Handle user interactions
- Navigate ke screen lain
- Display loading/error/empty states

### `/views/widgets`
**Tanggung Jawab**: Reusable UI components

```
views/widgets/
├── account_card.dart      # Display account info
├── customer_card.dart     # Display customer info
├── state_widgets.dart     # LoadingWidget, EmptyWidget, ErrorWidget
└── index.dart             # Central export file
```

### `/constants`
**Tanggung Jawab**: Global constants, theme, dan configuration

```
constants/
├── app_constants.dart     # App-level constants
├── app_theme.dart         # Material theme & colors
└── index.dart             # Central export file
```

**app_theme.dart**:
- `AppColors`: semua color yang digunakan
- `AppTheme`: Material3 theme configuration
- Consistent styling across app

### `/utils`
**Tanggung Jawab**: Helper functions dan utilities

```
utils/
├── helpers.dart           # DateTimeUtil, ValidationUtil
└── index.dart             # Central export file
```

**Utilities**:
- `DateTimeUtil.formatDate()` - Format tanggal ke string
- `DateTimeUtil.formatCurrency()` - Format currency Rupiah
- `ValidationUtil.validateEmail()` - Email validation
- `ValidationUtil.validatePhoneNumber()` - Phone validation
- `ValidationUtil.validateAmount()` - Amount validation

## 🔌 Provider Setup

### main.dart - MultiProvider Configuration

```dart
MultiProvider(
  providers: [
    // API Service
    Provider<BankApiService>(create: (_) => BankApiService()),
    
    // Controllers
    ChangeNotifierProvider<CustomerController>(
      create: (context) => CustomerController(
        apiService: context.read<BankApiService>(),
      ),
    ),
    // ... other controllers
  ],
  child: MaterialApp(...),
)
```

**Key Points**:
- BankApiService disediakan sebagai `Provider` (singleton)
- Controllers disediakan sebagai `ChangeNotifierProvider`
- Controllers di-inject dengan BankApiService
- Semua providers available di seluruh app via `context.read()` atau `Consumer<>`

## 🎯 Data Flow Examples

### Example 1: Fetch Customers
```
1. User membuka CustomerManagementScreen
2. initState memanggil: context.read<CustomerController>().fetchCustomers()
3. CustomerController:
   - Set _isLoading = true, notifyListeners()
   - Call apiService.getAllCustomers()
   - BankApiService: GET /api/customers
   - Parse response ke List<Customer>
   - Set _customers = list, _isLoading = false, notifyListeners()
4. Consumer widget rebuild dengan data baru
5. ListView menampilkan list customers
```

### Example 2: Create Customer
```
1. User fill form dan tap "Tambah"
2. Validasi input
3. Call context.read<CustomerController>().createCustomer(...)
4. CustomerController:
   - Set _isLoading = true
   - Call apiService.createCustomer(...)
   - BankApiService: POST /api/customers
   - Parse response ke Customer object
   - Add ke _customers list
   - notifyListeners()
5. Bottom sheet closes
6. ListView rebuild dengan customer baru
```

### Example 3: Withdraw Transaction
```
1. User fill transaction form
2. Tap "Kirim Transaksi"
3. Navigate ke ResultViewScreen dengan data
4. ResultViewScreen initState memanggil: 
   context.read<TransactionController>().performWithdrawal(...)
5. TransactionController:
   - Set _isLoading = true
   - Call apiService.withdraw(...)
   - BankApiService: POST /api/transactions/withdraw
   - API returns: { success: true, final_balance: XXX, bunga: XXX }
   - Set _transactionResult = result, _isLoading = false, notifyListeners()
6. ResultViewScreen rebuild dengan result data
7. Display success/error dengan detail hasil transaksi
```

## 🔐 Design Patterns Used

### 1. **MVC Pattern**
- **Model**: Data classes di `/models`
- **View**: Screens dan widgets di `/views`
- **Controller**: State management di `/controllers`

### 2. **Provider Pattern**
- Centralized state management
- Reactive UI updates
- Easy dependency injection

### 3. **Repository Pattern** (via BankApiService)
- Single source of truth untuk API calls
- Abstraction dari HTTP implementation
- Easy mocking untuk testing

### 4. **Singleton Pattern** (BankApiService)
- Single instance shared across app
- Efficient resource usage

### 5. **Consumer Pattern**
- Widget rebuilt when data changes
- Fine-grained UI updates

## 🚀 Extension Points

### Adding New Feature (e.g., Loan Management)

1. **Create Model** (`lib/models/loan.dart`)
2. **Add API Methods** (di `BankApiService`)
3. **Create Controller** (`lib/controllers/loan_controller.dart`)
4. **Create Screens** (`lib/views/screens/loan_screen.dart`)
5. **Create Widgets** (jika diperlukan)
6. **Add Provider** (di `main.dart`)
7. **Add Route** (di `main.dart` routes)

## 📊 State Management Flow

```
┌─────────────────────────────────────────┐
│     User Interaction (Tap, Input)       │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Screen / Widget calls Controller method │
│  context.read<Controller>().method()    │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Controller updates state (_data, etc.)  │
│  and calls notifyListeners()             │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Consumer widgets rebuild automatically  │
│  with new state data                     │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  UI updates pada screen                  │
└─────────────────────────────────────────┘
```

## 🎓 Learning Resources

- [Provider Package](https://pub.dev/packages/provider)
- [Flutter MVC Pattern](https://flutter.dev/docs)
- [JSON Serialization](https://flutter.dev/docs/development/data-and-backend/json)
- [Material Design 3](https://m3.material.io/)

---

**Last Updated**: 2024
