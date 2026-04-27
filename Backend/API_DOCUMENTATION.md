# Bank Savings API Documentation

Dokumentasi lengkap untuk Bank Savings System API.

## Setup Awal

### 1. Instalasi Dependencies
```bash
npm install
```

### 2. Konfigurasi Environment
Buat file `.env` di root project:
```env
NODE_ENV=development
PORT=3000
MONGODB_URL=mongodb://localhost:27017/bank-savings
JWT_SECRET=your_jwt_secret_key
JWT_ACCESS_EXPIRATION_MINUTES=30
JWT_REFRESH_EXPIRATION_DAYS=30
```

### 3. Seed Data Awal
Jalankan script untuk menambahkan data DepositoType awal:
```bash
node src/seeds/seed-deposito-types.js
```

### 4. Jalankan Server
```bash
npm run dev
```

Server akan berjalan di `http://localhost:3000`

---

## API Endpoints

### Deposito Types (Tipe Deposito)

#### 1. Buat Tipe Deposito
```
POST /v1/deposito-types
Content-Type: application/json

{
  "name": "Platinum",
  "yearlyReturn": 9
}
```

**Response (201):**
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "name": "Platinum",
  "yearlyReturn": 9,
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

#### 2. Dapatkan Semua Tipe Deposito
```
GET /v1/deposito-types?page=1&limit=10
```

**Response (200):**
```json
{
  "results": [
    {
      "_id": "507f1f77bcf86cd799439001",
      "name": "Bronze",
      "yearlyReturn": 3
    },
    {
      "_id": "507f1f77bcf86cd799439002",
      "name": "Silver",
      "yearlyReturn": 5
    }
  ],
  "page": 1,
  "limit": 10,
  "totalResults": 3,
  "totalPages": 1
}
```

#### 3. Dapatkan Tipe Deposito Berdasarkan ID
```
GET /v1/deposito-types/:depositoTypeId
```

#### 4. Update Tipe Deposito
```
PATCH /v1/deposito-types/:depositoTypeId
Content-Type: application/json

{
  "yearlyReturn": 8
}
```

#### 5. Hapus Tipe Deposito
```
DELETE /v1/deposito-types/:depositoTypeId
```

---

### Customers (Nasabah)

#### 1. Buat Nasabah Baru
```
POST /v1/customers
Content-Type: application/json

{
  "name": "John Doe"
}
```

**Response (201):**
```json
{
  "_id": "507f1f77bcf86cd799439111",
  "name": "John Doe",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

#### 2. Dapatkan Semua Nasabah
```
GET /v1/customers?page=1&limit=10
```

#### 3. Dapatkan Nasabah Berdasarkan ID
```
GET /v1/customers/:customerId
```

#### 4. Update Data Nasabah
```
PATCH /v1/customers/:customerId
Content-Type: application/json

{
  "name": "Jane Doe"
}
```

#### 5. Hapus Nasabah
```
DELETE /v1/customers/:customerId
```

---

### Accounts (Akun Tabungan)

#### 1. Buat Akun Baru
```
POST /v1/accounts
Content-Type: application/json

{
  "customerId": "507f1f77bcf86cd799439111",
  "depositoTypeId": "507f1f77bcf86cd799439001",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z"
}
```

**Response (201):**
```json
{
  "_id": "507f1f77bcf86cd799439211",
  "customerId": "507f1f77bcf86cd799439111",
  "depositoTypeId": "507f1f77bcf86cd799439001",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

#### 2. Dapatkan Semua Akun
```
GET /v1/accounts?page=1&limit=10
```

#### 3. Dapatkan Akun Berdasarkan ID
```
GET /v1/accounts/:accountId
```

**Response (200):**
```json
{
  "_id": "507f1f77bcf86cd799439211",
  "customerId": {
    "_id": "507f1f77bcf86cd799439111",
    "name": "John Doe"
  },
  "depositoTypeId": {
    "_id": "507f1f77bcf86cd799439001",
    "name": "Bronze",
    "yearlyReturn": 3
  },
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

#### 4. Dapatkan Semua Akun Nasabah
```
GET /v1/accounts/customer/:customerId
```

#### 5. Update Akun
```
PATCH /v1/accounts/:accountId
Content-Type: application/json

{
  "balance": 1500000,
  "depositoTypeId": "507f1f77bcf86cd799439002"
}
```

#### 6. Hapus Akun
```
DELETE /v1/accounts/:accountId
```

---

### Withdrawal (Penarikan Tabungan)

#### 1. Hitung Penarikan (Simulasi Tanpa Modifikasi Saldo)
```
POST /v1/accounts/:accountId/calculate-withdrawal
Content-Type: application/json

{
  "withdrawalDate": "2024-12-31T00:00:00Z"
}
```

**Response (200):**
```json
{
  "accountId": "507f1f77bcf86cd799439211",
  "customerId": "507f1f77bcf86cd799439111",
  "depositoTypeId": "507f1f77bcf86cd799439001",
  "depositoTypeName": "Bronze",
  "yearlyReturn": 3,
  "depositDate": "2024-01-01T00:00:00Z",
  "withdrawalDate": "2024-12-31T00:00:00Z",
  "totalMonths": 11,
  "startingBalance": 1000000,
  "interest": 27500,
  "endingBalance": 1027500
}
```

**Rumus Perhitungan:**
```
Total Months = Jumlah bulan antara depositDate dan withdrawalDate
Monthly Rate = Yearly Return / 12 / 100
Interest = Starting Balance * Total Months * Monthly Rate
Ending Balance = Starting Balance + Interest
```

**Contoh:**
- Starting Balance: Rp 1.000.000
- Yearly Return (Bronze): 3% per tahun
- Total Months: 11 bulan
- Monthly Rate: 3% / 12 / 100 = 0.0025
- Interest: 1.000.000 × 11 × 0.0025 = Rp 27.500
- Ending Balance: 1.000.000 + 27.500 = **Rp 1.027.500**

#### 2. Lakukan Penarikan (Modifikasi Saldo)
```
POST /v1/accounts/:accountId/withdraw
Content-Type: application/json

{
  "withdrawalDate": "2024-12-31T00:00:00Z"
}
```

**Response (200):**
```json
{
  "accountId": "507f1f77bcf86cd799439211",
  "customerId": "507f1f77bcf86cd799439111",
  "depositoTypeId": "507f1f77bcf86cd799439001",
  "depositoTypeName": "Bronze",
  "yearlyReturn": 3,
  "depositDate": "2024-01-01T00:00:00Z",
  "withdrawalDate": "2024-12-31T00:00:00Z",
  "totalMonths": 11,
  "startingBalance": 1000000,
  "interest": 27500,
  "endingBalance": 1027500,
  "message": "Penarikan berhasil. Saldo akhir: 1027500"
}
```

> **Catatan:** Setelah withdrawal, balance akun akan direset ke 0.

---

## Error Handling

### Error Response Format
```json
{
  "code": 400,
  "message": "Error message description"
}
```

### Common Errors

| Status | Message | Description |
|--------|---------|-------------|
| 400 | Bad Request | Input tidak valid atau terlalu sedikit |
| 404 | Not Found | Resource tidak ditemukan |
| 500 | Internal Server Error | Error pada server |

### Contoh Error

**Customer tidak ditemukan:**
```json
{
  "code": 404,
  "message": "Customer not found"
}
```

**Saldo tidak cukup:**
```json
{
  "code": 400,
  "message": "Insufficient balance"
}
```

**Tanggal penarikan tidak valid:**
```json
{
  "code": 400,
  "message": "Withdrawal date cannot be before deposit date"
}
```

---

## Aturan Bisnis

1. **Satu Nasabah, Banyak Akun**: Satu customer dapat memiliki lebih dari satu akun dengan tipe deposito berbeda

2. **Satu Akun, Satu Tipe Deposito**: Setiap akun hanya boleh memiliki satu tipe deposito

3. **Perhitungan Bunga**: Menggunakan formula:
   ```
   Ending Balance = Starting Balance * Total Months * (Yearly Return / 12)
   ```

4. **Validasi Tanggal**:
   - Tanggal penarikan tidak boleh sebelum tanggal setoran
   - Jika sama, total bulan adalah 0 (tidak ada bunga)

5. **Pembulatan**: Total bulan dihitung sebagai selisih lengkap bulan (0 atau lebih)

---

## Testing dengan cURL

### Create Customer
```bash
curl -X POST http://localhost:3000/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe"
  }'
```

### Get All Customers
```bash
curl http://localhost:3000/v1/customers
```

### Create Account
```bash
curl -X POST http://localhost:3000/v1/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": "YOUR_CUSTOMER_ID",
    "depositoTypeId": "YOUR_DEPOSITO_TYPE_ID",
    "balance": 1000000,
    "depositDate": "2024-01-01T00:00:00Z"
  }'
```

### Calculate Withdrawal
```bash
curl -X POST http://localhost:3000/v1/accounts/YOUR_ACCOUNT_ID/calculate-withdrawal \
  -H "Content-Type: application/json" \
  -d '{
    "withdrawalDate": "2024-12-31T00:00:00Z"
  }'
```

### Perform Withdrawal
```bash
curl -X POST http://localhost:3000/v1/accounts/YOUR_ACCOUNT_ID/withdraw \
  -H "Content-Type: application/json" \
  -d '{
    "withdrawalDate": "2024-12-31T00:00:00Z"
  }'
```

---

## Struktur Arsitektur MVC

```
src/
├── models/
│   ├── customer.model.js
│   ├── account.model.js
│   ├── deposito-type.model.js
│   └── index.js
├── controllers/
│   ├── customer.controller.js
│   ├── account.controller.js
│   ├── deposito-type.controller.js
│   └── index.js
├── services/
│   ├── customer.service.js
│   ├── account.service.js
│   ├── deposito-type.service.js
│   ├── withdraw.service.js
│   └── index.js
├── validations/
│   ├── customer.validation.js
│   ├── account.validation.js
│   ├── deposito-type.validation.js
│   └── index.js
├── routes/
│   └── v1/
│       ├── customer.route.js
│       ├── account.route.js
│       ├── deposito-type.route.js
│       └── index.js
├── middlewares/
│   └── validate.js
├── utils/
│   └── ApiError.js
└── seeds/
    └── seed-deposito-types.js
```

---

## Fitur Utama

✅ CRUD untuk Customer (Nasabah)
✅ CRUD untuk Account (Akun Tabungan)
✅ CRUD untuk DepositoType (Tipe Deposito)
✅ Perhitungan Bunga Otomatis
✅ Fitur Penarikan dengan Validasi Tanggal
✅ Error Handling Komprehensif
✅ Pagination untuk Query Results
✅ Validasi Input dengan Joi
✅ Seeding Data Awal
✅ Struktur MVC yang Rapi

---

## License

MIT
