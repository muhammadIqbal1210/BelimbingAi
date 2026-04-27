# API Mock Data Examples

Berikut adalah contoh struktur response dari API Bank yang diharapkan oleh aplikasi.

## 1. Get All Customers

**Endpoint**: `GET /api/customers`

**Response 200 OK**:
```json
{
  "status": 200,
  "message": "Success",
  "data": [
    {
      "customer_id": 1,
      "customer_name": "John Doe",
      "customer_address": "Jl. Merdeka No. 123, Jakarta",
      "customer_phone": "08123456789",
      "customer_email": "john@example.com"
    },
    {
      "customer_id": 2,
      "customer_name": "Jane Smith",
      "customer_address": "Jl. Sudirman No. 456, Bandung",
      "customer_phone": "08987654321",
      "customer_email": "jane@example.com"
    }
  ]
}
```

## 2. Create Customer

**Endpoint**: `POST /api/customers`

**Request Body**:
```json
{
  "customer_name": "New Customer",
  "customer_address": "Jl. Gatot Subroto",
  "customer_phone": "08555666777",
  "customer_email": "newcustomer@example.com"
}
```

**Response 201 Created**:
```json
{
  "status": 201,
  "message": "Customer created successfully",
  "data": {
    "customer_id": 3,
    "customer_name": "New Customer",
    "customer_address": "Jl. Gatot Subroto",
    "customer_phone": "08555666777",
    "customer_email": "newcustomer@example.com"
  }
}
```

## 3. Get All Accounts

**Endpoint**: `GET /api/accounts`

**Response 200 OK**:
```json
{
  "status": 200,
  "message": "Success",
  "data": [
    {
      "account_id": 1,
      "account_number": "1234567890",
      "account_type": "Tabungan",
      "account_balance": 5000000,
      "customer_id": 1,
      "deposito_type_id": null,
      "account_created_date": "2024-01-15"
    },
    {
      "account_id": 2,
      "account_number": "0987654321",
      "account_type": "Deposito",
      "account_balance": 50000000,
      "customer_id": 1,
      "deposito_type_id": 1,
      "account_created_date": "2024-02-20"
    }
  ]
}
```

## 4. Get Accounts by Customer ID

**Endpoint**: `GET /api/customers/1/accounts`

**Response 200 OK**:
```json
{
  "status": 200,
  "message": "Success",
  "data": [
    {
      "account_id": 1,
      "account_number": "1234567890",
      "account_type": "Tabungan",
      "account_balance": 5000000,
      "customer_id": 1,
      "deposito_type_id": null,
      "account_created_date": "2024-01-15"
    }
  ]
}
```

## 5. Create Account

**Endpoint**: `POST /api/accounts`

**Request Body**:
```json
{
  "account_number": "1111222233",
  "account_type": "Tabungan",
  "account_balance": 0,
  "customer_id": 1,
  "deposito_type_id": null
}
```

**Response 201 Created**:
```json
{
  "status": 201,
  "message": "Account created successfully",
  "data": {
    "account_id": 3,
    "account_number": "1111222233",
    "account_type": "Tabungan",
    "account_balance": 0,
    "customer_id": 1,
    "deposito_type_id": null,
    "account_created_date": "2024-04-22"
  }
}
```

## 6. Get All Deposito Types

**Endpoint**: `GET /api/deposito-types`

**Response 200 OK**:
```json
{
  "status": 200,
  "message": "Success",
  "data": [
    {
      "deposito_type_id": 1,
      "deposito_type_name": "Deposito 3 Bulan",
      "deposito_tenor_month": 3,
      "deposito_bunga": 3.5
    },
    {
      "deposito_type_id": 2,
      "deposito_type_name": "Deposito 6 Bulan",
      "deposito_tenor_month": 6,
      "deposito_bunga": 4.0
    },
    {
      "deposito_type_id": 3,
      "deposito_type_name": "Deposito 12 Bulan",
      "deposito_tenor_month": 12,
      "deposito_bunga": 4.5
    }
  ]
}
```

## 7. Deposit Transaction

**Endpoint**: `POST /api/transactions/deposit`

**Request Body**:
```json
{
  "account_id": 1,
  "transaction_type": "Deposit",
  "transaction_amount": 1000000,
  "transaction_date": "2024-04-22",
  "transaction_description": "Setoran tunai"
}
```

**Response 201 Created**:
```json
{
  "status": 201,
  "message": "Deposit successful",
  "data": {
    "transaction_id": 1,
    "account_id": 1,
    "transaction_type": "Deposit",
    "transaction_amount": 1000000,
    "transaction_date": "2024-04-22",
    "transaction_description": "Setoran tunai"
  }
}
```

## 8. Withdraw Transaction

**Endpoint**: `POST /api/transactions/withdraw`

**Request Body**:
```json
{
  "account_id": 2,
  "transaction_type": "Withdraw",
  "transaction_amount": 5000000,
  "transaction_date": "2024-04-22",
  "transaction_description": "Penarikan untuk kebutuhan"
}
```

**Response 201 Created** (untuk Deposito dengan perhitungan bunga):
```json
{
  "status": 201,
  "message": "Withdrawal successful",
  "data": {
    "transaction_id": 2,
    "account_id": 2,
    "transaction_type": "Withdraw",
    "transaction_amount": 5000000,
    "transaction_date": "2024-04-22",
    "transaction_description": "Penarikan untuk kebutuhan",
    "success": true,
    "bunga": 175000,
    "final_balance": 45175000,
    "saldo_sebelum": 50000000,
    "saldo_sesudah": 45000000
  }
}
```

**Response 400 Bad Request** (insufficient balance):
```json
{
  "status": 400,
  "message": "Insufficient balance",
  "data": {
    "success": false,
    "required_amount": 100000000,
    "available_balance": 50000000
  }
}
```

## 9. Get Account Transactions

**Endpoint**: `GET /api/accounts/1/transactions`

**Response 200 OK**:
```json
{
  "status": 200,
  "message": "Success",
  "data": [
    {
      "transaction_id": 1,
      "account_id": 1,
      "transaction_type": "Deposit",
      "transaction_amount": 1000000,
      "transaction_date": "2024-04-22",
      "transaction_description": "Setoran tunai"
    },
    {
      "transaction_id": 3,
      "account_id": 1,
      "transaction_type": "Withdraw",
      "transaction_amount": 500000,
      "transaction_date": "2024-04-23",
      "transaction_description": "Penarikan ATM"
    }
  ]
}
```

## Error Responses

### 404 Not Found
```json
{
  "status": 404,
  "message": "Resource not found",
  "data": null
}
```

### 500 Internal Server Error
```json
{
  "status": 500,
  "message": "Internal server error",
  "data": null
}
```

### 422 Validation Error
```json
{
  "status": 422,
  "message": "Validation error",
  "data": {
    "errors": {
      "customer_email": ["Email format is invalid"],
      "customer_phone": ["Phone number must be at least 10 digits"]
    }
  }
}
```

---

**Note**: Pastikan API Anda return responses sesuai struktur di atas untuk kompatibilitas penuh dengan aplikasi Flutter.
