# Bank Savings API - Testing Guide

Panduan lengkap untuk testing Bank Savings API menggunakan berbagai tools.

## 📋 Table of Contents

1. [Setup MongoDB Lokal](#setup-mongodb-lokal)
2. [Inisialisasi Aplikasi](#inisialisasi-aplikasi)
3. [Testing dengan cURL](#testing-dengan-curl)
4. [Testing dengan Postman](#testing-dengan-postman)
5. [Testing dengan VS Code REST Client](#testing-dengan-vs-code-rest-client)
6. [Skenario Testing Lengkap](#skenario-testing-lengkap)

---

## Setup MongoDB Lokal

### Option 1: MongoDB Community Server
```bash
# Windows - Menggunakan MongoDB Compass (GUI)
# Download dari: https://www.mongodb.com/try/download/compass

# Atau menggunakan command line MongoDB
mongod --dbpath "C:\data\db"
```

### Option 2: Docker
```bash
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

Verifikasi koneksi:
```bash
mongo
> use bank-savings
> db.customers.find()
```

---

## Inisialisasi Aplikasi

### 1. Install Dependencies
```bash
npm install
```

### 2. Setup Environment
Buat `.env` file dengan konfigurasi sesuai kebutuhan.

### 3. Start Server
```bash
npm run dev
```

Output yang diharapkan:
```
Server running on port 3000
Connected to MongoDB
```

### 4. Seed Data Awal
Di terminal lain:
```bash
node src/seeds/seed-deposito-types.js
```

Output:
```
Connected to MongoDB
Cleared existing deposito types
Deposito types seeded successfully: [...]
Disconnected from MongoDB
```

---

## Testing dengan cURL

### 1. Create Deposito Types (Seed)
```bash
curl -X POST http://localhost:3000/v1/deposito-types \
  -H "Content-Type: application/json" \
  -d '{"name":"Bronze","yearlyReturn":3}'

curl -X POST http://localhost:3000/v1/deposito-types \
  -H "Content-Type: application/json" \
  -d '{"name":"Silver","yearlyReturn":5}'

curl -X POST http://localhost:3000/v1/deposito-types \
  -H "Content-Type: application/json" \
  -d '{"name":"Gold","yearlyReturn":7}'
```

### 2. Get All Deposito Types
```bash
curl -X GET "http://localhost:3000/v1/deposito-types?page=1&limit=10"
```

**Response:**
```json
{
  "results": [
    {
      "_id": "507f1f77bcf86cd799439001",
      "name": "Bronze",
      "yearlyReturn": 3,
      "createdAt": "2024-01-15T10:30:00Z"
    }
  ],
  "page": 1,
  "limit": 10,
  "totalResults": 3,
  "totalPages": 1
}
```

### 3. Create Customer
```bash
curl -X POST http://localhost:3000/v1/customers \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe"}'
```

**Response:**
```json
{
  "_id": "507f1f77bcf86cd799439111",
  "name": "John Doe",
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

### 4. Get Customer by ID
```bash
curl -X GET http://localhost:3000/v1/customers/507f1f77bcf86cd799439111
```

### 5. Create Account
Sebelum membuat account, siapkan:
- `CUSTOMER_ID` dari step 3
- `DEPOSITO_TYPE_ID` dari step 2 (Bronze)

```bash
curl -X POST http://localhost:3000/v1/accounts \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": "507f1f77bcf86cd799439111",
    "depositoTypeId": "507f1f77bcf86cd799439001",
    "balance": 1000000,
    "depositDate": "2024-01-01T00:00:00Z"
  }'
```

**Response:**
```json
{
  "_id": "507f1f77bcf86cd799439211",
  "customerId": "507f1f77bcf86cd799439111",
  "depositoTypeId": "507f1f77bcf86cd799439001",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### 6. Calculate Withdrawal (Simulasi)
```bash
curl -X POST http://localhost:3000/v1/accounts/507f1f77bcf86cd799439211/calculate-withdrawal \
  -H "Content-Type: application/json" \
  -d '{
    "withdrawalDate": "2024-12-31T00:00:00Z"
  }'
```

**Response:**
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

### 7. Perform Withdrawal (Penarikan Nyata)
```bash
curl -X POST http://localhost:3000/v1/accounts/507f1f77bcf86cd799439211/withdraw \
  -H "Content-Type: application/json" \
  -d '{
    "withdrawalDate": "2024-12-31T00:00:00Z"
  }'
```

---

## Testing dengan Postman

### Import Collection
1. Buka Postman
2. Klik **Import** → **Upload Files**
3. Pilih file `POSTMAN_COLLECTION.json` dari project folder
4. Collection akan ter-import otomatis

### Cara Testing
1. Set base URL menjadi `http://localhost:3000` di environment
2. Ganti placeholder `<CUSTOMER_ID>`, `<DEPOSITO_TYPE_ID>`, `<ACCOUNT_ID>` dengan ID yang sebenarnya
3. Jalankan requests sesuai urutan:
   - Seed Deposito Types
   - Create Customer
   - Create Account
   - Calculate Withdrawal
   - Perform Withdrawal

---

## Testing dengan VS Code REST Client

### Install Extension
1. Buka VS Code
2. Klik **Extensions** (Ctrl+Shift+X)
3. Cari `REST Client` oleh Huachao Mao
4. Klik **Install**

### Buat Test File
Buat file `test-api.http` di root project:

```http
### Variables
@baseUrl = http://localhost:3000
@customerId =
@depositoTypeId =
@accountId =

### 1. Get All Deposito Types
GET {{baseUrl}}/v1/deposito-types

### 2. Create Bronze Deposito Type
POST {{baseUrl}}/v1/deposito-types
Content-Type: application/json

{
  "name": "Bronze",
  "yearlyReturn": 3
}

### 3. Create Customer
POST {{baseUrl}}/v1/customers
Content-Type: application/json

{
  "name": "John Doe"
}

### 4. Get Customer
GET {{baseUrl}}/v1/customers/@customerId

### 5. Create Account
POST {{baseUrl}}/v1/accounts
Content-Type: application/json

{
  "customerId": "@customerId",
  "depositoTypeId": "@depositoTypeId",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z"
}

### 6. Calculate Withdrawal
POST {{baseUrl}}/v1/accounts/@accountId/calculate-withdrawal
Content-Type: application/json

{
  "withdrawalDate": "2024-12-31T00:00:00Z"
}

### 7. Perform Withdrawal
POST {{baseUrl}}/v1/accounts/@accountId/withdraw
Content-Type: application/json

{
  "withdrawalDate": "2024-12-31T00:00:00Z"
}
```

### Cara Menggunakan
1. Buka file `test-api.http`
2. Klik **Send Request** di atas setiap request atau gunakan shortcut **Ctrl+Alt+R**
3. Response akan muncul di panel kanan
4. Update variabel `@customerId`, `@depositoTypeId`, `@accountId` dengan ID dari responses

---

## Skenario Testing Lengkap

### Skenario 1: Create New Customer with Single Account

**Step 1: Create Deposito Type**
```json
POST /v1/deposito-types
{
  "name": "Silver",
  "yearlyReturn": 5
}
Response: depositoTypeId = "id_silver"
```

**Step 2: Create Customer**
```json
POST /v1/customers
{
  "name": "Alice Smith"
}
Response: customerId = "id_alice"
```

**Step 3: Create Account**
```json
POST /v1/accounts
{
  "customerId": "id_alice",
  "depositoTypeId": "id_silver",
  "balance": 5000000,
  "depositDate": "2024-06-01T00:00:00Z"
}
Response: accountId = "id_account1"
```

**Step 4: Calculate Withdrawal after 6 months**
```json
POST /v1/accounts/id_account1/calculate-withdrawal
{
  "withdrawalDate": "2024-12-01T00:00:00Z"
}
```

**Expected Response:**
```json
{
  "totalMonths": 6,
  "startingBalance": 5000000,
  "interest": 125000,
  "endingBalance": 5125000
}
```

---

### Skenario 2: Customer with Multiple Accounts

**Step 1-2: Create Customer (seperti di skenario 1)**

**Step 3: Create First Account (Bronze - 3%)**
```json
POST /v1/accounts
{
  "customerId": "id_alice",
  "depositoTypeId": "id_bronze",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z"
}
Response: accountId1 = "id_acc_bronze"
```

**Step 4: Create Second Account (Gold - 7%)**
```json
POST /v1/accounts
{
  "customerId": "id_alice",
  "depositoTypeId": "id_gold",
  "balance": 2000000,
  "depositDate": "2024-03-01T00:00:00Z"
}
Response: accountId2 = "id_acc_gold"
```

**Step 5: Get All Accounts for Customer**
```
GET /v1/accounts/customer/id_alice
```

**Expected Response:** Array dengan 2 accounts

**Step 6: Calculate Withdrawal untuk masing-masing account**

Account 1 (Bronze):
```json
POST /v1/accounts/id_acc_bronze/calculate-withdrawal
{
  "withdrawalDate": "2024-12-01T00:00:00Z"
}
```
Expected interest: 1.000.000 × 11 × (3% / 12) = 27.500

Account 2 (Gold):
```json
POST /v1/accounts/id_acc_gold/calculate-withdrawal
{
  "withdrawalDate": "2024-12-01T00:00:00Z"
}
```
Expected interest: 2.000.000 × 9 × (7% / 12) = 105.000

---

### Skenario 3: Withdrawal pada Hari yang Sama

```json
POST /v1/accounts/id_account1/calculate-withdrawal
{
  "withdrawalDate": "2024-01-01T00:00:00Z"
}
```

**Expected Response:** totalMonths = 0, interest = 0

---

### Skenario 4: Error Handling

#### Error 1: Invalid Withdrawal Date (Before Deposit Date)
```json
POST /v1/accounts/id_account1/calculate-withdrawal
{
  "withdrawalDate": "2023-12-31T00:00:00Z"
}
```

**Expected Error:**
```json
{
  "code": 400,
  "message": "Withdrawal date cannot be before deposit date"
}
```

#### Error 2: Account Not Found
```
GET /v1/accounts/invalid_id
```

**Expected Error:**
```json
{
  "code": 404,
  "message": "Account not found"
}
```

#### Error 3: Missing Required Field
```json
POST /v1/accounts
{
  "customerId": "id_alice"
  // depositoTypeId missing
}
```

**Expected Error:**
```json
{
  "code": 400,
  "message": "\"depositoTypeId\" is required"
}
```

---

## Tips & Tricks

1. **Simpan Response IDs**: Setelah membuat resource, copy ID dari response untuk request berikutnya
2. **Gunakan Environment Variables**: Di Postman, gunakan `{{variable}}` untuk menghindari hardcoding
3. **Test Error Cases**: Pastikan aplikasi handle errors dengan baik
4. **Monitor Console**: Lihat logs di terminal saat request dilakukan
5. **Check Database**: Gunakan MongoDB Compass untuk verify data di database

---

## Troubleshooting

### Server tidak berjalan
```bash
# Check if port 3000 is in use
lsof -i :3000

# Kill process
kill -9 <PID>

# Restart server
npm run dev
```

### MongoDB Connection Error
```bash
# Check MongoDB status
mongosh

# If error, start MongoDB
mongod --dbpath "path/to/data"
```

### Invalid Request Error
- Check JSON format (valid JSON harus punya escape characters yang benar)
- Check header `Content-Type: application/json`
- Check required fields sesuai schema

---

Selamat testing! 🎉
