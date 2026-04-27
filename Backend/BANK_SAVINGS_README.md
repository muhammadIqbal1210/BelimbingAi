# Bank Savings System - Backend API

Backend API untuk sistem simpanan bank yang dibangun dengan Node.js Express, MongoDB, dan arsitektur MVC.

## 📋 Daftar Isi

- [Fitur](#fitur)
- [Tech Stack](#tech-stack)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Instalasi](#instalasi)
- [Konfigurasi](#konfigurasi)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [API Endpoints](#api-endpoints)
- [Struktur Proyek](#struktur-proyek)
- [Aturan Bisnis](#aturan-bisnis)

## ✨ Fitur

### Entitas Utama
- **Customer**: Nasabah dengan nama dan ID unik
- **Account**: Akun tabungan dengan reference ke customer dan deposito type
- **DepositoType**: Tipe deposito (Bronze 3%, Silver 5%, Gold 7%) dengan return tahunan

### Fungsionalitas
- ✅ Manajemen Customer (Create, Read, Update, Delete)
- ✅ Manajemen Account (Create, Read, Update, Delete)
- ✅ Manajemen DepositoType (Create, Read, Update, Delete)
- ✅ Perhitungan Bunga Otomatis
- ✅ Fitur Penarikan (Withdraw) dengan Validasi Tanggal
- ✅ Simulasi Penarikan tanpa modifikasi saldo
- ✅ Validasi Input Komprehensif
- ✅ Error Handling yang Robust
- ✅ Pagination untuk Query Results
- ✅ Seeding Data Awal

## 🛠 Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB dengan Mongoose ODM
- **Validasi**: Joi
- **Utilities**:
  - Helmet (Security)
  - Compression (GZIP)
  - CORS (Cross-Origin)
  - XSS-Clean (Protection)
  - Morgan (Logging)

## 💻 Persyaratan Sistem

- Node.js >= 12.0.0
- MongoDB >= 4.0
- npm atau yarn

## 📦 Instalasi

1. **Clone Repository**
   ```bash
   cd "d:\Proyek_NonKuliah\Belimbing AI\Backend"
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

## ⚙️ Konfigurasi

1. **Buat File .env** di root directory:
   ```env
   NODE_ENV=development
   PORT=3000
   MONGODB_URL=mongodb://localhost:27017/bank-savings
   JWT_SECRET=your_super_secret_jwt_key
   JWT_ACCESS_EXPIRATION_MINUTES=30
   JWT_REFRESH_EXPIRATION_DAYS=30
   JWT_RESET_PASSWORD_EXPIRATION_MINUTES=10
   JWT_VERIFY_EMAIL_EXPIRATION_MINUTES=10
   ```

2. **Seed Data Awal** (Opsional - untuk populate DepositoType default)
   ```bash
   node src/seeds/seed-deposito-types.js
   ```

## 🚀 Menjalankan Aplikasi

### Mode Development (dengan auto-reload)
```bash
npm run dev
```

### Mode Production
```bash
npm start
```

### Testing
```bash
npm test
```

Server akan berjalan di `http://localhost:3000` (atau port yang dikonfigurasi)

## 📚 API Endpoints

Untuk dokumentasi lengkap endpoint, lihat [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)

### Deposito Types
- `POST /v1/deposito-types` - Buat tipe deposito
- `GET /v1/deposito-types` - Daftar semua tipe deposito
- `GET /v1/deposito-types/:id` - Dapatkan tipe deposito
- `PATCH /v1/deposito-types/:id` - Update tipe deposito
- `DELETE /v1/deposito-types/:id` - Hapus tipe deposito

### Customers
- `POST /v1/customers` - Buat nasabah
- `GET /v1/customers` - Daftar semua nasabah
- `GET /v1/customers/:id` - Dapatkan nasabah
- `PATCH /v1/customers/:id` - Update nasabah
- `DELETE /v1/customers/:id` - Hapus nasabah

### Accounts
- `POST /v1/accounts` - Buat akun
- `GET /v1/accounts` - Daftar semua akun
- `GET /v1/accounts/:id` - Dapatkan akun
- `GET /v1/accounts/customer/:customerId` - Daftar akun nasabah
- `PATCH /v1/accounts/:id` - Update akun
- `DELETE /v1/accounts/:id` - Hapus akun
- `POST /v1/accounts/:id/calculate-withdrawal` - Simulasi penarikan
- `POST /v1/accounts/:id/withdraw` - Lakukan penarikan

## 📁 Struktur Proyek

```
src/
├── models/
│   ├── customer.model.js          # Model Customer
│   ├── account.model.js           # Model Account
│   ├── deposito-type.model.js     # Model DepositoType
│   └── index.js                   # Export models
├── controllers/
│   ├── customer.controller.js     # Controller Customer
│   ├── account.controller.js      # Controller Account
│   ├── deposito-type.controller.js # Controller DepositoType
│   └── index.js                   # Export controllers
├── services/
│   ├── customer.service.js        # Service Customer
│   ├── account.service.js         # Service Account
│   ├── deposito-type.service.js   # Service DepositoType
│   ├── withdraw.service.js        # Service Withdraw
│   └── index.js                   # Export services
├── validations/
│   ├── customer.validation.js     # Validasi Customer
│   ├── account.validation.js      # Validasi Account
│   ├── deposito-type.validation.js # Validasi DepositoType
│   └── index.js                   # Export validations
├── routes/
│   └── v1/
│       ├── customer.route.js      # Routes Customer
│       ├── account.route.js       # Routes Account
│       ├── deposito-type.route.js # Routes DepositoType
│       └── index.js               # Main routes
├── seeds/
│   └── seed-deposito-types.js     # Seed data initial
├── middlewares/
│   ├── auth.js                    # Auth middleware
│   ├── validate.js                # Validasi middleware
│   └── error.js                   # Error handling
├── utils/
│   ├── ApiError.js                # Custom error class
│   └── catchAsync.js              # Async wrapper
└── app.js                         # Express app config
```

## 📋 Aturan Bisnis

### 1. Nasabah dan Akun
- Satu nasabah dapat memiliki **lebih dari satu akun**
- Satu akun hanya boleh memiliki **satu tipe deposito**
- Setiap akun memiliki balance (saldo) dan deposit date (tanggal setoran)

### 2. Tipe Deposito
- **Bronze**: Return 3% per tahun
- **Silver**: Return 5% per tahun
- **Gold**: Return 7% per tahun

### 3. Perhitungan Bunga & Penarikan
Formula perhitungan bunga:
```
Total Months = Jumlah bulan antara depositDate dan withdrawalDate
Monthly Rate = Yearly Return / 12 / 100
Interest = Starting Balance × Total Months × Monthly Rate
Ending Balance = Starting Balance + Interest
```

**Contoh:**
- Starting Balance: Rp 1.000.000
- Deposito Type: Bronze (3% per tahun)
- Lama Simpanan: 11 bulan
- Bunga Bulanan: 3% / 12 = 0,25%
- Total Bunga: 1.000.000 × 11 × 0,25% = **Rp 27.500**
- Saldo Akhir: 1.000.000 + 27.500 = **Rp 1.027.500**

### 4. Validasi
- Tanggal penarikan tidak boleh sebelum tanggal setoran
- Jika tanggal sama, total bulan = 0 (tidak ada bunga)
- Balance harus >= 0
- Semua input harus sesuai skema validasi

### 5. Penarikan
- Fitur `calculate-withdrawal`: Simulasi perhitungan tanpa mengubah saldo
- Fitur `withdraw`: Penarikan aktual yang mengubah saldo account menjadi 0

## 🔒 Keamanan

API dilindungi dengan:
- ✅ Helmet - Set security HTTP headers
- ✅ XSS-Clean - Prevent XSS attacks
- ✅ Express Mongo Sanitize - Prevent NoSQL injection
- ✅ CORS - Control cross-origin requests
- ✅ Rate Limiting - Limit repeated requests
- ✅ Input Validation - Joi validation schema

## 🧪 Testing

Gunakan tools seperti:
- **Postman** - API testing tool
- **cURL** - Command-line tool
- **VS Code REST Client** - Extension untuk testing

Contoh request dapat dilihat di [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)

## 📝 Catatan Pengembangan

### Next Steps (Opsional)
- [ ] Add authentication/authorization
- [ ] Add rate limiting per user
- [ ] Add transaction history logging
- [ ] Add interest calculation scheduler
- [ ] Add email notifications
- [ ] Add unit & integration tests
- [ ] Add API documentation dengan Swagger/OpenAPI

## 📄 License

MIT License - Silakan gunakan dengan bebas!

## 👤 Author

Belimbing AI Project - 2024

---

**Need Help?** Lihat [API_DOCUMENTATION.md](./API_DOCUMENTATION.md) untuk dokumentasi lengkap atau jalankan `npm run dev` untuk memulai!
