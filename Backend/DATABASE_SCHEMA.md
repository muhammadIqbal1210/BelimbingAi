# Database Schema & Relationships

Penjelasan lengkap struktur database dan relationships antar entitas dalam Bank Savings System.

## 📊 Entity Relationship Diagram

```
┌─────────────────┐
│   DepositoType  │
├─────────────────┤
│ _id (PK)        │
│ name            │◄──┐
│ yearlyReturn    │   │
│ createdAt       │   │
│ updatedAt       │   │
└─────────────────┘   │
                      │ (1:M)
┌─────────────────┐   │
│    Account      │   │
├─────────────────┤   │
│ _id (PK)        │   │
│ customerId (FK) ├──►│ DepositoType
│ depositoTypeId  ├───┘
│ balance         │
│ depositDate     │
│ createdAt       │
│ updatedAt       │
└─────────────────┘
        ▲
        │ (1:M)
        │
┌─────────────────┐
│   Customer      │
├─────────────────┤
│ _id (PK)        │
│ name            │
│ createdAt       │
│ updatedAt       │
└─────────────────┘
```

---

## 📋 Schema Details

### 1. DepositoType Collection

**Purpose**: Menyimpan tipe-tipe deposito dengan return rate yang berbeda

**Fields:**
```javascript
{
  _id: ObjectId,           // Auto-generated MongoDB ID
  name: String,            // Unique: "Bronze", "Silver", "Gold", dll
  yearlyReturn: Number,    // Percentage: 3, 5, 7, dll
  createdAt: Date,         // Auto-generated
  updatedAt: Date          // Auto-generated
}
```

**Constraints:**
- `name` harus unik (unique index)
- `yearlyReturn` harus antara 0-100

**Example:**
```json
{
  "_id": "507f1f77bcf86cd799439001",
  "name": "Bronze",
  "yearlyReturn": 3,
  "createdAt": "2024-01-15T10:30:00Z",
  "updatedAt": "2024-01-15T10:30:00Z"
}
```

**Default Data (Seed):**
- Bronze: 3% per tahun
- Silver: 5% per tahun
- Gold: 7% per tahun

---

### 2. Customer Collection

**Purpose**: Menyimpan data nasabah/pelanggan

**Fields:**
```javascript
{
  _id: ObjectId,           // Auto-generated MongoDB ID
  name: String,            // Nama nasabah
  createdAt: Date,         // Auto-generated
  updatedAt: Date          // Auto-generated
}
```

**Constraints:**
- `name` wajib diisi
- Tidak ada constraint unique (multiple customers bisa punya nama sama)

**Example:**
```json
{
  "_id": "507f1f77bcf86cd799439111",
  "name": "John Doe",
  "createdAt": "2024-01-15T10:35:00Z",
  "updatedAt": "2024-01-15T10:35:00Z"
}
```

**Relationship:**
- Satu Customer dapat memiliki **banyak Account** (1:M)

---

### 3. Account Collection

**Purpose**: Menyimpan data akun tabungan/deposito

**Fields:**
```javascript
{
  _id: ObjectId,              // Auto-generated MongoDB ID
  customerId: ObjectId,       // Foreign Key ke Customer
  depositoTypeId: ObjectId,   // Foreign Key ke DepositoType
  balance: Number,            // Saldo awal tabungan
  depositDate: Date,          // Tanggal setoran awal
  createdAt: Date,            // Auto-generated
  updatedAt: Date             // Auto-generated
}
```

**Constraints:**
- `customerId` wajib diisi dan harus valid Customer ID
- `depositoTypeId` wajib diisi dan harus valid DepositoType ID
- `balance` harus >= 0
- `depositDate` wajib diisi

**Example:**
```json
{
  "_id": "507f1f77bcf86cd799439211",
  "customerId": "507f1f77bcf86cd799439111",
  "depositoTypeId": "507f1f77bcf86cd799439001",
  "balance": 1000000,
  "depositDate": "2024-01-01T00:00:00Z",
  "createdAt": "2024-01-15T10:40:00Z",
  "updatedAt": "2024-01-15T10:40:00Z"
}
```

**Relationships:**
- Belongs to **Customer** (Many to One)
- Belongs to **DepositoType** (Many to One)

**Population (dalam query):**
```javascript
// Query dengan populate
Account.find()
  .populate('customerId')
  .populate('depositoTypeId')

// Result:
{
  _id: "507f1f77bcf86cd799439211",
  customerId: {
    _id: "507f1f77bcf86cd799439111",
    name: "John Doe"
  },
  depositoTypeId: {
    _id: "507f1f77bcf86cd799439001",
    name: "Bronze",
    yearlyReturn: 3
  },
  balance: 1000000,
  depositDate: "2024-01-01T00:00:00Z"
}
```

---

## 🔄 Relationship Rules

### 1. One Customer → Many Accounts
```
Customer (1)  ──────────  (M)  Account
     ▼                           ▼
   John Doe      Account 1    Bronze 3%
                 Account 2    Silver 5%
                 Account 3    Gold 7%
```

- Satu customer dapat membuka multiple accounts
- Setiap account independent dengan own balance & deposito type

### 2. Many Accounts → One DepositoType
```
DepositoType (1)  ──────────  (M)  Account
      ▼                            ▼
   Bronze 3%       Account 1    Customer A
                   Account 2    Customer B
                   Account 3    Customer C
```

- Banyak accounts bisa menggunakan same deposito type
- Satu account hanya bisa memiliki satu deposito type

### 3. Full Picture
```
                    ┌──── Customer (John Doe)
                    │
Account 1          │        ┌──── Bronze 3%
┌─────────────────┐│       │
│ Bronze 3%       ├┴──────┤
│ Rp 1.000.000    │        └──── Shared DepositoType
└─────────────────┘                      │
                                         │
Account 2          ┌──────────────┐     │
┌─────────────────┐│ Customer    │     │
│ Silver 5%       ├┼─────────────┤     │
│ Rp 2.000.000    ││ John Doe    │     │
└─────────────────┘│ (ID: ...)   │     │
                    └──────────────┘     │
Account 3                               │
┌─────────────────┐                     │
│ Gold 7%         ├─────────────────────┤
│ Rp 3.000.000    │                     │
└─────────────────┘                     │
                                  ┌─────┴─────┐
                                  │Gold 7%    │
                                  │Silver 5%  │
                                  │Bronze 3%  │
                                  └───────────┘
                              DepositoTypes (Shared)
```

---

## 💾 Index Strategy

### Indexes untuk Performance

```javascript
// Customer Collection
db.customers.createIndex({ name: 1 })

// DepositoType Collection
db.depositotypes.createIndex({ name: 1 }, { unique: true })

// Account Collection
db.accounts.createIndex({ customerId: 1 })
db.accounts.createIndex({ depositoTypeId: 1 })
db.accounts.createIndex({ customerId: 1, depositoTypeId: 1 })
```

---

## 🔐 Data Validation Rules

### DepositoType Validation
```javascript
{
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  yearlyReturn: {
    type: Number,
    required: true,
    min: 0,
    max: 100
  }
}
```

### Customer Validation
```javascript
{
  name: {
    type: String,
    required: true,
    trim: true
  }
}
```

### Account Validation
```javascript
{
  customerId: {
    type: ObjectId,
    ref: 'Customer',
    required: true
  },
  depositoTypeId: {
    type: ObjectId,
    ref: 'DepositoType',
    required: true
  },
  balance: {
    type: Number,
    required: true,
    default: 0,
    min: 0
  },
  depositDate: {
    type: Date,
    required: true
  }
}
```

---

## 📝 Business Logic Relationships

### Workflow: Create Account
```
1. Validate Customer exists
   └─> Query: Customer.findById(customerId)
   └─> If not found: Throw Error 404

2. Validate DepositoType exists
   └─> Query: DepositoType.findById(depositoTypeId)
   └─> If not found: Throw Error 404

3. Create Account
   └─> Insert: { customerId, depositoTypeId, balance, depositDate }
   └─> Return: Created account document
```

### Workflow: Withdrawal
```
1. Get Account with Relationships
   └─> Query: Account.findById(accountId)
      .populate('customerId')
      .populate('depositoTypeId')

2. Get DepositoType Info
   └─> Use: depositoTypeId.yearlyReturn

3. Calculate Total Months
   └─> Formula: months = (endDate - startDate) in months

4. Calculate Interest
   └─> Formula: interest = balance × months × (yearlyReturn / 12 / 100)

5. Calculate Ending Balance
   └─> Formula: endingBalance = balance + interest

6. Update Account
   └─> Set: balance = 0
   └─> Set: updatedAt = now()
```

---

## 🔄 Data Flow Examples

### Example 1: Create Multiple Accounts for One Customer

**Sequence:**
```
1. Create Customer
   POST /v1/customers
   { name: "Alice" }
   → Created: customer._id = "cust_001"

2. Get DepositoTypes
   GET /v1/deposito-types
   → Found:
     - "type_001" = Bronze
     - "type_002" = Silver
     - "type_003" = Gold

3. Create Account 1 (Bronze)
   POST /v1/accounts
   {
     customerId: "cust_001",
     depositoTypeId: "type_001",
     balance: 1000000,
     depositDate: "2024-01-01"
   }
   → Created: account._id = "acc_001"

4. Create Account 2 (Silver)
   POST /v1/accounts
   {
     customerId: "cust_001",
     depositoTypeId: "type_002",
     balance: 2000000,
     depositDate: "2024-06-01"
   }
   → Created: account._id = "acc_002"

5. Get All Customer Accounts
   GET /v1/accounts/customer/cust_001
   → Returns: [acc_001, acc_002]

6. Withdraw from acc_001
   POST /v1/accounts/acc_001/withdraw
   { withdrawalDate: "2024-12-31" }
   → Result: endingBalance = 1027500
   → Updated: acc_001.balance = 0
```

---

## 🗂️ MongoDB Collections

Setelah implementasi lengkap, MongoDB akan punya struktur:

```
bank-savings (Database)
├── customers (Collection)
│   └── Indexes: name
├── depositotypes (Collection)
│   └── Indexes: name (unique)
├── accounts (Collection)
│   └── Indexes: customerId, depositoTypeId
└── tokens (Collection)
```

---

## 📊 Query Examples

### Get Customer dengan Semua Accountnya
```javascript
const customer = await Customer.findById(customerId);
const accounts = await Account.find({ customerId })
  .populate('depositoTypeId');
```

### Get Account Details
```javascript
const account = await Account.findById(accountId)
  .populate('customerId')
  .populate('depositoTypeId');
```

### Get Total Balance for Customer
```javascript
const accounts = await Account.find({ customerId });
const totalBalance = accounts.reduce((sum, acc) => sum + acc.balance, 0);
```

### Get Accounts by DepositoType
```javascript
const bronzeAccounts = await Account.find({ depositoTypeId: bronzeTypeId })
  .populate('customerId');
```

---

## ✅ Data Integrity

### Foreign Key Constraints
Dalam Mongoose, constraints diterapkan melalui:
1. **Validation di Service Layer**: Cek exist sebelum create
2. **Ref di Schema**: Mongoose akan track relationships
3. **Middleware**: Custom validation functions

### Cascade Delete Prevention
- **Customer dihapus**: Accounts tetap ada (orphaned)
- **DepositoType dihapus**: Accounts tetap ada
- **Account dihapus**: No cascading needed

### Recommendations
- Implementasikan soft delete (add `deletedAt` field)
- Atau implement cascade delete logic di application layer
- Atau enforce foreign key constraints di MongoDB (transaction)

---

## 🔍 Schema Monitoring

### Check Current Schema
```bash
mongosh
use bank-savings
db.customers.findOne()
db.depositotypes.findOne()
db.accounts.findOne()
```

### Create Indexes Manually
```bash
db.depositotypes.createIndex({ name: 1 }, { unique: true })
db.accounts.createIndex({ customerId: 1 })
db.accounts.createIndex({ depositoTypeId: 1 })
```

---

Dokumentasi schema lengkap selesai! 📚
