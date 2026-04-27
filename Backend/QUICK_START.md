# 🚀 Quick Start Guide - Bank Savings API

Panduan cepat untuk mulai menggunakan Bank Savings API.

## ⚡ 5 Menit Setup

### 1️⃣ Install Dependencies
```bash
cd "d:\Proyek_NonKuliah\Belimbing AI\Backend"
npm install
```

### 2️⃣ Buat .env File
Buat file `.env` di root directory dengan content:
```env
NODE_ENV=development
PORT=3000
MONGODB_URL=mongodb://localhost:27017/bank-savings
JWT_SECRET=your_super_secret_jwt_key
JWT_ACCESS_EXPIRATION_MINUTES=30
JWT_REFRESH_EXPIRATION_DAYS=30
```

### 3️⃣ Jalankan MongoDB
Pastikan MongoDB running:
```bash
# Windows dengan MongoDB Compass atau:
mongod --dbpath "C:\data\db"

# Atau dengan Docker:
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### 4️⃣ Seed Data Awal
```bash
node src/seeds/seed-deposito-types.js
```

Output yang diharapkan:
```
Connected to MongoDB
Cleared existing deposito types
Deposito types seeded successfully: [
  { _id: '...', name: 'Bronze', yearlyReturn: 3 },
  { _id: '...', name: 'Silver', yearlyReturn: 5 },
  { _id: '...', name: 'Gold', yearlyReturn: 7 }
]
```

### 5️⃣ Start Server
```bash
npm run dev
```

Output:
```
App listening on port 3000
Connected to MongoDB
```

## ✅ Server Berjalan!

API siap di `http://localhost:3000`

---

## 🧪 Testing Cepat (Copy-Paste)

### Terminal 1: Start Server
```bash
npm run dev
```

### Terminal 2: Copy-Paste Commands Berikut

#### 1. Create Customer
```bash
curl -X POST http://localhost:3000/v1/customers \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"John Doe\"}"
```

**Catat CUSTOMER_ID dari response**

#### 2. Get All Deposito Types
```bash
curl http://localhost:3000/v1/deposito-types
```

**Catat DEPOSITO_TYPE_ID (Bronze) dari response**

#### 3. Create Account
Ganti `CUSTOMER_ID` dan `DEPOSITO_TYPE_ID` dengan ID dari responses sebelumnya:
```bash
curl -X POST http://localhost:3000/v1/accounts \
  -H "Content-Type: application/json" \
  -d "{
    \"customerId\": \"CUSTOMER_ID\",
    \"depositoTypeId\": \"DEPOSITO_TYPE_ID\",
    \"balance\": 1000000,
    \"depositDate\": \"2024-01-01T00:00:00Z\"
  }"
```

**Catat ACCOUNT_ID dari response**

#### 4. Hitung Penarikan (Simulasi)
Ganti `ACCOUNT_ID` dengan ID dari response sebelumnya:
```bash
curl -X POST http://localhost:3000/v1/accounts/ACCOUNT_ID/calculate-withdrawal \
  -H "Content-Type: application/json" \
  -d "{\"withdrawalDate\": \"2024-12-31T00:00:00Z\"}"
```

**Expected Result:**
```json
{
  "depositoTypeName": "Bronze",
  "yearlyReturn": 3,
  "totalMonths": 11,
  "startingBalance": 1000000,
  "interest": 27500,
  "endingBalance": 1027500
}
```

#### 5. Lakukan Penarikan (Aktual)
```bash
curl -X POST http://localhost:3000/v1/accounts/ACCOUNT_ID/withdraw \
  -H "Content-Type: application/json" \
  -d "{\"withdrawalDate\": \"2024-12-31T00:00:00Z\"}"
```

---

## 📋 Verifikasi Data di MongoDB

```bash
# Connect ke MongoDB
mongosh

# Select database
use bank-savings

# Cek customers
db.customers.find()

# Cek accounts
db.accounts.find()

# Cek deposito types
db.depositotypes.find()
```

---

## 🛠️ Troubleshooting

### ❌ Error: Cannot connect to MongoDB
**Solution:**
```bash
# Start MongoDB
mongod --dbpath "path/to/data"

# Atau cek MongoDB status
# Windows: Services → MongoDB → Start
# Mac: brew services start mongodb-community
# Docker: docker start mongodb
```

### ❌ Error: Port 3000 already in use
```bash
# Find what's using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different port in .env
PORT=3001
```

### ❌ Error: ENOENT: no such file or directory '.env'
**Solution:** Buat file `.env` di root directory dengan content di atas

---

## 📚 Selanjutnya

Setelah berhasil, lihat:
- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Detail semua endpoints
- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Testing lebih lanjut
- **[POSTMAN_COLLECTION.json](POSTMAN_COLLECTION.json)** - Import ke Postman

---

## 🎯 Endpoints Utama

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | /v1/customers | Create customer |
| GET | /v1/customers | Get all customers |
| POST | /v1/deposito-types | Create deposito type |
| GET | /v1/deposito-types | Get all deposito types |
| POST | /v1/accounts | Create account |
| GET | /v1/accounts | Get all accounts |
| POST | /v1/accounts/:id/calculate-withdrawal | Hitung penarikan (simulasi) |
| POST | /v1/accounts/:id/withdraw | Lakukan penarikan |

---

## 💡 Tips

1. **Simpan IDs**: Setiap create operation mengembalikan ID, save untuk request berikutnya
2. **Format JSON**: Pastikan JSON valid dengan proper quotes
3. **Tanggal Format**: Gunakan ISO 8601 format: `YYYY-MM-DDTHH:mm:ssZ`
4. **Check Logs**: Lihat terminal saat error untuk debug info

---

## ❓ FAQ

**Q: Bagaimana jika sudah melakukan withdrawal?**
A: Balance account akan menjadi 0. Buat account baru untuk melanjutkan.

**Q: Bisa membuat multiple accounts untuk 1 customer?**
A: Ya! Setiap account bisa dengan deposito type berbeda.

**Q: Formula bunga itu apa?**
A: `Ending Balance = Starting Balance * Total Months * (Yearly Return / 12 / 100)`

**Q: Bagaimana meng-update account?**
A: Gunakan PATCH `/v1/accounts/:id` dengan field yang mau diupdate.

---

## 🎉 Selesai!

API sudah running dan siap digunakan. Enjoy! 🚀
