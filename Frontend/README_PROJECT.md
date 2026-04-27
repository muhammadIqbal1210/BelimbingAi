# Belimbing Bank - Flutter Mobile Banking Application

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue)](https://dart.dev)
[![Provider](https://img.shields.io/badge/Provider-6.4-green)](https://pub.dev/packages/provider)
[![License](https://img.shields.io/badge/License-MIT-green)](#)

Aplikasi Flutter profesional untuk manajemen akun bank dengan arsitektur MVC yang terintegrasi dengan API bank backend.

## ✨ Fitur Utama

- 📊 **Dashboard** - Ringkasan saldo dan daftar akun nasabah
- 👥 **Manajemen Nasabah** - CRUD Customer dengan validasi lengkap
- 🏦 **Manajemen Akun** - CRUD Account dengan 3 jenis (Tabungan, Giro, Deposito)
- 💸 **Transaksi** - Input Setoran dan Penarikan dengan Date Picker
- 📈 **Kalkulasi Bunga** - Otomatis menghitung bunga deposito untuk penarikan
- 🎨 **UI Profesional** - Material Design 3 dengan responsive layout
- 🔄 **State Management** - Provider untuk reactive UI updates

## 🏗️ Arsitektur

Aplikasi mengikuti pola **Model-View-Controller (MVC)** dengan clear separation of concerns:

```
┌─────────────────────────────────────────┐
│     Presentation Layer (Views)          │
│  Screens, Widgets, User Interactions    │
└───────────────────┬─────────────────────┘
                    │
┌───────────────────▼─────────────────────┐
│    Business Logic Layer (Controllers)   │
│  State Management with Provider         │
└───────────────────┬─────────────────────┘
                    │
┌───────────────────▼─────────────────────┐
│      Data Layer (Services)              │
│  API Integration, HTTP Calls            │
└───────────────────┬─────────────────────┘
                    │
┌───────────────────▼─────────────────────┐
│         Models & Data                   │
│  Customer, Account, Transaction, etc.   │
└─────────────────────────────────────────┘
```

## 📋 Struktur Proyek

```
lib/
├── main.dart                      # App entry point dengan MultiProvider
├── models/                        # Data models (Customer, Account, etc.)
├── services/                      # API service (bank_api_service.dart)
├── controllers/                   # State management (Provider)
├── views/
│   ├── screens/                   # Main application screens
│   └── widgets/                   # Reusable UI components
├── constants/                     # Theme, colors, constants
└── utils/                         # Helper functions & utilities
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10.4+
- Dart SDK
- API Bank endpoint

### Setup

1. **Clone repository**
   ```bash
   cd d:\Proyek_NonKuliah\Belimbing AI\Frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serializable files**
   ```bash
   flutter pub run build_runner build
   ```

4. **Configure API endpoint**
   - Edit `lib/services/bank_api_service.dart`
   - Update `baseUrl` to your API endpoint

5. **Run application**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
Provider:             6.4.0     # State management
HTTP:                 1.1.0     # API communication
JSON Annotation:      4.8.1     # JSON serialization
Intl:                 0.19.0    # Date/time formatting
Flutter ScreenUtil:   5.9.0     # Responsive UI
```

## 🎯 Main Screens

| Screen | Route | Description |
|--------|-------|-------------|
| Dashboard | / | Home dengan overview dan navigasi |
| Customer Mgmt | /customers | CRUD untuk nasabah |
| Account Mgmt | /accounts | CRUD untuk akun |
| Transaction | /transaction | Input transaksi |
| Result View | /result | Hasil & kalkulasi transaksi |

## 💡 Key Features

### State Management
- Provider untuk reactive UI updates
- ChangeNotifier base class untuk controllers
- Consumer widgets untuk UI rebuilding
- Easy dependency injection

### API Integration
- RESTful API client
- Comprehensive error handling
- Request/response mapping
- JSON serialization dengan build_runner

### Data Models
- Type-safe models
- JSON serialization support
- CopyWith methods untuk immutability
- Validation helpers

### UI Components
- Professional Material Design 3
- Responsive layouts
- Reusable cards & widgets
- Loading, error, empty states

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - Detailed setup & installation guide
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture documentation & patterns
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick reference guide
- **[API_EXAMPLES.md](API_EXAMPLES.md)** - API endpoint examples
- **[IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)** - Testing checklist

## 🔌 API Integration

Aplikasi mengharapkan API dengan endpoint berikut:

```
CUSTOMERS
GET/POST/PUT/DELETE /api/customers
GET /api/customers/{id}

ACCOUNTS
GET/POST/PUT/DELETE /api/accounts
GET /api/customers/{customerId}/accounts

TRANSACTIONS
POST /api/transactions/deposit
POST /api/transactions/withdraw
GET /api/accounts/{accountId}/transactions

DEPOSITO TYPES
GET /api/deposito-types
GET /api/deposito-types/{id}
```

Lihat [API_EXAMPLES.md](API_EXAMPLES.md) untuk format request/response.

## 🎨 UI Preview

- **Color Scheme**: Professional blue (#1F77D2) dengan accent colors
- **Typography**: Material Design 3 typography scale
- **Layout**: Card-based design dengan clear information hierarchy
- **Responsive**: Adaptif di mobile, tablet, dan landscape modes

## 🔐 Features

### Customer Management
- ✅ View all customers
- ✅ Add new customer (form validation)
- ✅ Edit customer details
- ✅ Delete customer (confirmation)
- ✅ Email & phone validation

### Account Management
- ✅ View all accounts
- ✅ Create account dengan customer selection
- ✅ Support 3 jenis akun (Tabungan, Giro, Deposito)
- ✅ Deposito type selection
- ✅ Edit & delete accounts

### Transaction
- ✅ Deposit (setoran)
- ✅ Withdrawal (penarikan)
- ✅ Date picker untuk transaction date
- ✅ Amount validation
- ✅ Description/notes

### Result View
- ✅ Transaction detail display
- ✅ Success/error status
- ✅ Saldo before/after
- ✅ Bunga calculation untuk deposito
- ✅ Navigation options

## 🧪 Testing

### Manual Testing
1. Test semua CRUD operations
2. Test date picker functionality
3. Test form validation
4. Test error handling
5. Test offline scenarios

### API Testing
- Use Postman atau cURL
- Verify response format sesuai API_EXAMPLES.md
- Test error responses
- Test edge cases

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Missing .g.dart files | `flutter pub run build_runner build` |
| Build errors | `flutter clean && flutter pub get` |
| API connection failed | Update base URL, check internet |
| UI not updating | Ensure `notifyListeners()` is called |

## 🚀 Performance

- Efficient state management dengan Provider
- Lazy loading untuk long lists
- Optimized UI rebuilding
- Error boundaries untuk stability

## 📱 Platform Support

- ✅ Android (SDK 21+)
- ✅ iOS (11.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ⚠️ Desktop (partial support)

## 🔐 Best Practices

✅ Clear MVC separation
✅ Type-safe models
✅ Comprehensive error handling
✅ Input validation
✅ Responsive design
✅ Reusable components
✅ Well-documented code
✅ Consistent naming conventions

## 🎓 Learning Resources

- [Flutter Official Docs](https://flutter.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)
- [Dart Documentation](https://dart.dev/guides)

## 📝 License

MIT License - feel free to use this project for your purposes.

## 💬 Support

Untuk questions atau issues:
1. Check documentation files
2. Review QUICK_REFERENCE.md
3. Check TROUBLESHOOTING di IMPLEMENTATION_CHECKLIST.md

## 🎉 Getting Help

1. **Setup Issues** → See [SETUP.md](SETUP.md)
2. **Architecture Questions** → See [ARCHITECTURE.md](ARCHITECTURE.md)
3. **Quick Help** → See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
4. **API Issues** → See [API_EXAMPLES.md](API_EXAMPLES.md)
5. **Testing** → See [IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)

## 🚀 Next Steps

1. ✅ Setup project
2. ✅ Configure API endpoint
3. ✅ Test API endpoints
4. ✅ Run application
5. ✅ Perform user testing
6. ✅ Deploy to production

## 👨‍💻 Development Team

Developed with ❤️ using Flutter & Dart

---

**Version**: 1.0.0  
**Last Updated**: April 2024  
**Status**: Ready for Implementation ✅
