# Bank Savings System - Implementation Summary

## ✅ Implementasi Lengkap

Backend API untuk sistem simpanan bank telah berhasil dibuat dengan arsitektur MVC menggunakan Node.js Express dan MongoDB.

---

## 📁 File yang Telah Dibuat

### 1. Models (3 files)

| File | Deskripsi |
|------|-----------|
| [src/models/customer.model.js](src/models/customer.model.js) | Model Customer dengan field: id, name |
| [src/models/account.model.js](src/models/account.model.js) | Model Account dengan relationships ke Customer & DepositoType |
| [src/models/deposito-type.model.js](src/models/deposito-type.model.js) | Model DepositoType dengan name & yearlyReturn |

**Update:** [src/models/index.js](src/models/index.js) - Export semua models

### 2. Services (4 files)

| File | Deskripsi |
|------|-----------|
| [src/services/customer.service.js](src/services/customer.service.js) | Business logic CRUD Customer |
| [src/services/account.service.js](src/services/account.service.js) | Business logic CRUD Account dengan validasi relationships |
| [src/services/deposito-type.service.js](src/services/deposito-type.service.js) | Business logic CRUD DepositoType |
| [src/services/withdraw.service.js](src/services/withdraw.service.js) | **Logika penarikan dengan rumus bunga otomatis** |

**Rumus Withdraw:**
```
Ending Balance = Starting Balance * Total Months * (Yearly Return / 12 / 100)
```

**Update:** [src/services/index.js](src/services/index.js) - Export semua services

### 3. Controllers (3 files)

| File | Deskripsi |
|------|-----------|
| [src/controllers/customer.controller.js](src/controllers/customer.controller.js) | Handler CRUD Customer |
| [src/controllers/account.controller.js](src/controllers/account.controller.js) | Handler CRUD Account + calculateWithdrawal + withdraw |
| [src/controllers/deposito-type.controller.js](src/controllers/deposito-type.controller.js) | Handler CRUD DepositoType |

**Update:** [src/controllers/index.js](src/controllers/index.js) - Export semua controllers

### 4. Validations (3 files)

| File | Deskripsi |
|------|-----------|
| [src/validations/customer.validation.js](src/validations/customer.validation.js) | Schema validasi Customer dengan Joi |
| [src/validations/account.validation.js](src/validations/account.validation.js) | Schema validasi Account + withdraw operations |
| [src/validations/deposito-type.validation.js](src/validations/deposito-type.validation.js) | Schema validasi DepositoType |

**Update:** [src/validations/index.js](src/validations/index.js) - Export semua validations

### 5. Routes (3 files)

| File | Deskripsi |
|------|-----------|
| [src/routes/v1/customer.route.js](src/routes/v1/customer.route.js) | Routes untuk customer endpoints |
| [src/routes/v1/account.route.js](src/routes/v1/account.route.js) | Routes untuk account endpoints + withdraw |
| [src/routes/v1/deposito-type.route.js](src/routes/v1/deposito-type.route.js) | Routes untuk deposito-type endpoints |

**Update:** [src/routes/v1/index.js](src/routes/v1/index.js) - Include semua routes baru

### 6. Seeding (1 file)

| File | Deskripsi |
|------|-----------|
| [src/seeds/seed-deposito-types.js](src/seeds/seed-deposito-types.js) | Script untuk seed data awal (Bronze 3%, Silver 5%, Gold 7%) |

### 7. Documentation (4 files)

| File | Deskripsi |
|------|-----------|
| [API_DOCUMENTATION.md](API_DOCUMENTATION.md) | **Dokumentasi API lengkap dengan contoh request/response** |
| [BANK_SAVINGS_README.md](BANK_SAVINGS_README.md) | **README khusus Bank Savings System** |
| [TESTING_GUIDE.md](TESTING_GUIDE.md) | **Panduan testing dengan cURL, Postman, VS Code REST Client** |
| [POSTMAN_COLLECTION.json](POSTMAN_COLLECTION.json) | **Postman collection siap import untuk testing** |

---

## 🚀 API Endpoints

### Deposito Types
```
POST   /v1/deposito-types              - Create deposito type
GET    /v1/deposito-types              - Get all deposito types
GET    /v1/deposito-types/:id          - Get deposito type by ID
PATCH  /v1/deposito-types/:id          - Update deposito type
DELETE /v1/deposito-types/:id          - Delete deposito type
```

### Customers
```
POST   /v1/customers                   - Create customer
GET    /v1/customers                   - Get all customers
GET    /v1/customers/:id               - Get customer by ID
PATCH  /v1/customers/:id               - Update customer
DELETE /v1/customers/:id               - Delete customer
```

### Accounts
```
POST   /v1/accounts                    - Create account
GET    /v1/accounts                    - Get all accounts
GET    /v1/accounts/:id                - Get account by ID
GET    /v1/accounts/customer/:customerId - Get customer's accounts
PATCH  /v1/accounts/:id                - Update account
DELETE /v1/accounts/:id                - Delete account
```

### Withdrawal (Fitur Utama)
```
POST   /v1/accounts/:id/calculate-withdrawal  - Simulasi penarikan (tanpa modifikasi)
POST   /v1/accounts/:id/withdraw              - Lakukan penarikan (modifikasi saldo)
```

---

## ✨ Fitur Implementasi

### 1. ✅ Entitas Lengkap
- **Customer**: id, name, createdAt, updatedAt
- **Account**: id, customer_id, deposito_type_id, balance, depositDate
- **DepositoType**: id, name, yearlyReturn

### 2. ✅ Aturan Bisnis
- Satu nasabah bisa memiliki lebih dari satu akun
- Satu akun hanya boleh memiliki satu tipe deposito
- Perhitungan bunga otomatis: `Ending Balance = Starting Balance * Total Months * (Yearly Return / 12 / 100)`
- Input meliputi tanggal setoran dan tanggal penarikan

### 3. ✅ Error Handling
- Validasi saldo tidak cukup
- Validasi data tidak ditemukan
- Validasi tanggal penarikan (tidak boleh sebelum tanggal setoran)
- Validasi input dengan Joi schema
- Response error format JSON yang konsisten

### 4. ✅ Output JSON
Semua response dalam format JSON terstruktur dengan:
```json
{
  "_id": "...",
  "customerId": "...",
  "depositoTypeId": "...",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z",
  "createdAt": "...",
  "updatedAt": "..."
}
```

### 5. ✅ Arsitektur MVC
- **Models**: Database schema definition dengan Mongoose
- **Controllers**: Request handling & response
- **Services**: Business logic & database operations
- **Routes**: API endpoints definition
- **Validations**: Input validation schemas
- **Middlewares**: Error handling & validation

---

## 📊 Struktur Folder

```
src/
├── models/
│   ├── customer.model.js              ✅ Created
│   ├── account.model.js               ✅ Created
│   ├── deposito-type.model.js         ✅ Created
│   └── index.js                       ✅ Updated
├── controllers/
│   ├── customer.controller.js         ✅ Created
│   ├── account.controller.js          ✅ Created
│   ├── deposito-type.controller.js    ✅ Created
│   └── index.js                       ✅ Updated
├── services/
│   ├── customer.service.js            ✅ Created
│   ├── account.service.js             ✅ Created
│   ├── deposito-type.service.js       ✅ Created
│   ├── withdraw.service.js            ✅ Created
│   └── index.js                       ✅ Updated
├── validations/
│   ├── customer.validation.js         ✅ Created
│   ├── account.validation.js          ✅ Created
│   ├── deposito-type.validation.js    ✅ Created
│   └── index.js                       ✅ Updated
├── routes/
│   └── v1/
│       ├── customer.route.js          ✅ Created
│       ├── account.route.js           ✅ Created
│       ├── deposito-type.route.js     ✅ Created
│       └── index.js                   ✅ Updated
├── seeds/
│   └── seed-deposito-types.js         ✅ Created
└── app.js                             (existing)
```

---

## 🎯 Contoh Penggunaan

### 1. Setup Awal
```bash
# Install dependencies
npm install

# Seed data deposito types
node src/seeds/seed-deposito-types.js

# Start server
npm run dev
```

### 2. Create Customer
```bash
curl -X POST http://localhost:3000/v1/customers \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe"}'
```

### 3. Create Account
```bash
curl -X POST http://localhost:3000/v1/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": "CUSTOMER_ID",
    "depositoTypeId": "DEPOSITO_TYPE_ID",
    "balance": 1000000,
    "depositDate": "2024-01-01T00:00:00Z"
  }'
```

### 4. Hitung Penarikan (Simulasi)
```bash
curl -X POST http://localhost:3000/v1/accounts/ACCOUNT_ID/calculate-withdrawal \
  -H "Content-Type: application/json" \
  -d '{"withdrawalDate": "2024-12-31T00:00:00Z"}'
```

**Response:**
```json
{
  "accountId": "...",
  "depositoTypeName": "Bronze",
  "yearlyReturn": 3,
  "totalMonths": 11,
  "startingBalance": 1000000,
  "interest": 27500,
  "endingBalance": 1027500
}
```

### 5. Lakukan Penarikan (Aktual)
```bash
curl -X POST http://localhost:3000/v1/accounts/ACCOUNT_ID/withdraw \
  -H "Content-Type: application/json" \
  -d '{"withdrawalDate": "2024-12-31T00:00:00Z"}'
```

---

## 📚 Dokumentasi Lengkap

Lihat file-file dokumentasi untuk detail lebih lanjut:

1. **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)**
   - Setup awal
   - Detail semua endpoints
   - Contoh request/response
   - Error handling
   - Aturan bisnis

2. **[BANK_SAVINGS_README.md](BANK_SAVINGS_README.md)**
   - Overview project
   - Tech stack
   - Instalasi & setup
   - Struktur project

3. **[TESTING_GUIDE.md](TESTING_GUIDE.md)**
   - Setup MongoDB
   - Testing dengan cURL
   - Testing dengan Postman
   - Testing dengan VS Code REST Client
   - Skenario lengkap

4. **[POSTMAN_COLLECTION.json](POSTMAN_COLLECTION.json)**
   - Siap import ke Postman
   - Semua endpoints sudah dikonfigurasi

---

## ✅ Checklist Implementasi

- [x] Create DepositoType model
- [x] Create Customer model
- [x] Create Account model dengan relationships
- [x] Create deposit-type service
- [x] Create customer service
- [x] Create account service
- [x] Create withdraw service dengan formula bunga
- [x] Create deposit-type controller
- [x] Create customer controller
- [x] Create account controller dengan withdraw logic
- [x] Create deposit-type validation
- [x] Create customer validation
- [x] Create account validation
- [x] Create deposit-type routes
- [x] Create customer routes
- [x] Create account routes
- [x] Update main routes (v1/index.js)
- [x] Create seed data script
- [x] Create API documentation
- [x] Create testing guide
- [x] Create Postman collection

---

## 🚀 Next Steps (Opsional)

1. **Add Authentication**
   - JWT token untuk secure endpoints

2. **Add Rate Limiting**
   - Per user rate limiting

3. **Add Transaction History**
   - Log semua transaksi

4. **Add Testing**
   - Unit tests dengan Jest
   - Integration tests

5. **Add Email Notifications**
   - Notifikasi withdrawal sukses

6. **Add API Documentation**
   - Swagger/OpenAPI integration

---

## 📝 Notes

- Database yang digunakan: **MongoDB**
- Driver: **Mongoose**
- Pagination sudah built-in menggunakan plugin
- Error handling menggunakan custom `ApiError` class
- Input validation menggunakan `Joi`
- Seeding data bisa dilakukan dengan script: `node src/seeds/seed-deposito-types.js`

---

## 🎉 Status: SIAP DIGUNAKAN

Backend API sudah lengkap dan siap untuk:
- ✅ Development
- ✅ Testing
- ✅ Deployment

Selamat menggunakan! 🚀
