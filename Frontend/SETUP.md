# Belimbing Bank - Flutter Mobile Application

Aplikasi Flutter profesional untuk mengelola akun bank dengan arsitektur MVC yang terintegrasi dengan API bank.

## 📋 Fitur Utama

### 1. **Dashboard**
- Menampilkan ringkasan total saldo dari semua akun
- Daftar akun nasabah dengan saldo masing-masing
- Refresh untuk memperbarui data
- Navigasi ke halaman manajemen nasabah dan akun

### 2. **Manajemen Nasabah (Customer Management)**
- Melihat daftar semua nasabah
- Tambah nasabah baru
- Edit informasi nasabah
- Hapus nasabah
- Form validasi lengkap

### 3. **Manajemen Akun (Account Management)**
- Melihat daftar semua akun
- Membuat akun baru untuk nasabah
- Edit akun (nomor rekening, jenis akun, tipe deposito)
- Hapus akun
- Mendukung 3 jenis akun: Tabungan, Giro, Deposito

### 4. **Transaksi (Transaction)**
- Input setoran (Deposit)
- Input penarikan (Withdraw)
- Date picker untuk memilih tanggal transaksi
- Validasi jumlah dan data
- Keterangan transaksi

### 5. **Hasil Transaksi (Result View)**
- Tampilan detail hasil transaksi
- Kalkulasi saldo akhir
- Perhitungan bunga deposito untuk penarikan
- Status sukses/gagal dengan pesan yang jelas

## 🏗️ Arsitektur MVC

```
lib/
├── main.dart                          # Entry point aplikasi
├── models/                            # Data models dengan JSON serialization
│   ├── customer.dart                  # Model Customer
│   ├── account.dart                   # Model Account
│   ├── deposito_type.dart             # Model DepositoType
│   ├── transaction.dart               # Model Transaction
│   ├── api_response.dart              # Model API Response wrapper
│   └── index.dart                     # Export file
├── services/                          # API Services
│   ├── bank_api_service.dart          # Service untuk komunikasi dengan API
│   └── index.dart                     # Export file
├── controllers/                       # State Management (Provider)
│   ├── customer_controller.dart       # Logic untuk Customer
│   ├── account_controller.dart        # Logic untuk Account
│   ├── transaction_controller.dart    # Logic untuk Transaction
│   ├── deposito_type_controller.dart  # Logic untuk DepositoType
│   └── index.dart                     # Export file
├── views/                             # UI Layer
│   ├── screens/                       # Halaman-halaman aplikasi
│   │   ├── dashboard_screen.dart      # Dashboard utama
│   │   ├── customer_management_screen.dart    # Manajemen nasabah
│   │   ├── account_management_screen.dart     # Manajemen akun
│   │   ├── transaction_screen.dart   # Halaman transaksi
│   │   ├── result_view_screen.dart   # Hasil transaksi
│   │   └── index.dart                 # Export file
│   ├── widgets/                       # Widget reusable
│   │   ├── account_card.dart          # Card untuk display akun
│   │   ├── customer_card.dart         # Card untuk display customer
│   │   ├── state_widgets.dart         # Loading, Empty, Error widgets
│   │   └── index.dart                 # Export file
│   └── index.dart                     # Export file
├── constants/                         # Constants dan Theme
│   ├── app_constants.dart             # Konstanta aplikasi
│   ├── app_theme.dart                 # Theme dan color scheme
│   └── index.dart                     # Export file
├── utils/                             # Helper functions
│   ├── helpers.dart                   # Date, Currency, Validation utilities
│   └── index.dart                     # Export file
└── pubspec.yaml                       # Dependencies
```

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK 3.10.4 atau lebih tinggi
- Dart SDK
- API Bank endpoint yang sudah siap

### Langkah-langkah Setup

1. **Clone repository atau buka project**
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
   Jika ingin regenerate setiap kali ada perubahan:
   ```bash
   flutter pub run build_runner watch
   ```

4. **Update Base URL API**
   Edit file `lib/services/bank_api_service.dart`:
   ```dart
   static const String baseUrl = 'http://your-api-endpoint/api';
   ```

5. **Run aplikasi**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- **provider: ^6.4.0** - State Management
- **http: ^1.1.0** - HTTP Client untuk API calls
- **json_annotation: ^4.8.1** - JSON serialization annotations
- **intl: ^0.19.0** - Internationalization & formatting
- **flutter_screenutil: ^5.9.0** - Responsive UI

### Dev Dependencies
- **json_serializable: ^6.7.1** - Code generation untuk JSON
- **build_runner: ^2.4.6** - Build runner untuk code generation

## 🔌 API Integration

Aplikasi ini mengharapkan endpoint API dengan struktur berikut:

### Customer Endpoints
- `GET /api/customers` - Get all customers
- `GET /api/customers/{id}` - Get customer by ID
- `POST /api/customers` - Create new customer
- `PUT /api/customers/{id}` - Update customer
- `DELETE /api/customers/{id}` - Delete customer

### Account Endpoints
- `GET /api/accounts` - Get all accounts
- `GET /api/accounts/{id}` - Get account by ID
- `GET /api/customers/{customerId}/accounts` - Get accounts by customer
- `POST /api/accounts` - Create new account
- `PUT /api/accounts/{id}` - Update account
- `DELETE /api/accounts/{id}` - Delete account

### Transaction Endpoints
- `GET /api/transactions` - Get all transactions
- `GET /api/accounts/{accountId}/transactions` - Get transactions by account
- `POST /api/transactions/deposit` - Make deposit
- `POST /api/transactions/withdraw` - Make withdrawal

### Deposito Type Endpoints
- `GET /api/deposito-types` - Get all deposito types
- `GET /api/deposito-types/{id}` - Get deposito type by ID

## 🎨 UI/UX Features

### Design System
- Material Design 3
- Consistent color scheme (Primary: Blue, Secondary: Cyan)
- Professional typography
- Responsive layout

### Widgets & Components
- **AccountCard** - Display account information with action buttons
- **CustomerCard** - Display customer information with action buttons
- **LoadingWidget** - Loading indicator dengan message
- **EmptyWidget** - Display ketika tidak ada data
- **ErrorWidget** - Display error message dengan retry button

## 📱 Screens & Navigation

1. **Dashboard** (Home)
   - Bottom navigation dengan 3 tab
   - Tab 0: Dashboard (current)
   - Tab 1: Manajemen Nasabah
   - Tab 2: Manajemen Akun

2. **Customer Management**
   - List semua nasabah
   - FAB untuk tambah nasabah
   - Swipe/menu untuk edit dan delete

3. **Account Management**
   - List semua akun
   - FAB untuk tambah akun
   - Swipe/menu untuk edit dan delete

4. **Transaction**
   - Pilih jenis transaksi (Deposit/Withdraw)
   - Input jumlah
   - Date picker
   - Keterangan

5. **Result View**
   - Menampilkan hasil transaksi
   - Kalkulasi bunga jika Deposito
   - Opsi kembali ke dashboard

## 🔄 State Management Flow

```
View (Widget)
    ↓
Consumer<Controller> (mengakses data)
    ↓
Controller (ChangeNotifier)
    ↓
BankApiService (API calls)
    ↓
API Server
```

## ✅ Error Handling

- Try-catch di semua API calls
- Error messages user-friendly
- Retry button di error widget
- Validasi input sebelum submit

## 🔐 Data Validation

- **Email**: Format validation
- **Phone**: Minimum 10 digits
- **Amount**: Must be positive number
- **Date**: Valid date selection

## 📊 Data Models

### Customer
```dart
- customerId: int
- customerName: String
- customerAddress: String
- customerPhone: String
- customerEmail: String
```

### Account
```dart
- accountId: int
- accountNumber: String
- accountType: String (Tabungan/Giro/Deposito)
- accountBalance: double
- customerId: int
- depositoTypeId: int? (nullable untuk non-deposito)
- accountCreatedDate: String
```

### Transaction
```dart
- transactionId: int?
- accountId: int
- transactionType: String (Deposit/Withdraw)
- transactionAmount: double
- transactionDate: String
- transactionDescription: String?
```

### DepositoType
```dart
- depositoTypeId: int
- depositoTypeName: String
- depositoTenorMonth: int
- depositoBunga: double (dalam persen)
```

## 🎯 Best Practices

1. **Separation of Concerns** - Model, View, Controller terpisah jelas
2. **Reusable Widgets** - Component dapat digunakan di berbagai tempat
3. **Error Handling** - Semua error ditangani dengan graceful
4. **Validation** - Input validation sebelum submit
5. **Loading States** - User awareness untuk long operations
6. **Responsive Design** - Adaptif di berbagai ukuran screen

## 🐛 Troubleshooting

### Build Error: "Missing generated files"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### API Connection Error
- Pastikan base URL sudah benar
- Cek koneksi internet
- Verifikasi API server status

### State tidak update
- Ensure menggunakan `Consumer` atau `context.read()`
- Pastikan `notifyListeners()` dipanggil di controller

## 📝 Notes

- Pastikan API bank sudah running sebelum menjalankan aplikasi
- Untuk development, gunakan `flutter pub run build_runner watch` untuk auto-generation
- Semua data yang ditampilkan mengambil dari API, bukan hardcoded
- Format currency menggunakan Rupiah (Rp.)

## 🚀 Next Steps

1. Setup API endpoint configuration
2. Test dengan data real dari API
3. Customize theme sesuai brand
4. Add authentication jika diperlukan
5. Implement local caching untuk offline support

---

**Developed with ❤️ using Flutter**
