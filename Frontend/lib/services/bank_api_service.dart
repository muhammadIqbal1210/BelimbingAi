import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/index.dart';

class BankApiService {
  // Base URL API bank
  static const String baseUrl =
      'http://localhost:3000/v1'; // Sesuaikan dengan URL API

  final http.Client httpClient;

  BankApiService({http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  // ==================== CUSTOMER ====================

  /// Mengambil semua customer
  Future<List<Customer>> getAllCustomers() async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/customers'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonList = [];
        if (decoded is Map) {
          if (decoded['data'] is List) {
            jsonList = decoded['data'];
          } else if (decoded['results'] is List) {
            jsonList = decoded['results'];
          } else if (decoded['data'] is Map &&
              decoded['data']['docs'] is List) {
            jsonList = decoded['data']['docs'];
          }
        } else if (decoded is List) {
          jsonList = decoded;
        }

        return jsonList.map((json) => Customer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load customers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching customers: $e');
    }
  }

  /// Mengambil customer berdasarkan ID
  Future<Customer> getCustomerById(String customerId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/customers/$customerId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        return Customer.fromJson(jsonData);
      } else {
        throw Exception('Failed to load customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching customer: $e');
    }
  }

  /// Membuat customer baru
  Future<Customer> createCustomer({
    required String name,
    String? address,
    String? phone,
    String? email,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/customers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'address': address,
          'phone': phone,
          'email': email,
        }),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Mengambil data dari 'data' field seperti endpoint lainnya
        final jsonData = responseBody['data'];
        if (jsonData == null) {
          throw Exception('No data in response: ${response.body}');
        }

        return Customer.fromJson(jsonData as Map<String, dynamic>);
      } else {
        throw Exception('Gagal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating customer: $e');
    }
  }

  /// Update customer
  Future<Customer> updateCustomer({
    required String customerId,
    required String name,
    String? address,
    String? phone,
    String? email,
  }) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl/customers/$customerId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'address': address,
          'phone': phone,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        return Customer.fromJson(jsonData);
      } else {
        throw Exception('Failed to update customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating customer: $e');
    }
  }

  /// Hapus customer
  Future<void> deleteCustomer(String customerId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/customers/$customerId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete customer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting customer: $e');
    }
  }

  // ==================== ACCOUNT ====================

  /// Mengambil semua akun
  Future<List<Account>> getAllAccounts() async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/accounts'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonList = [];
        if (decoded is Map) {
          if (decoded['data'] is List) {
            jsonList = decoded['data'];
          } else if (decoded['results'] is List) {
            jsonList = decoded['results'];
          } else if (decoded['data'] is Map &&
              decoded['data']['docs'] is List) {
            jsonList = decoded['data']['docs'];
          }
        } else if (decoded is List) {
          jsonList = decoded;
        }

        return jsonList.map((json) => Account.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load accounts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching accounts: $e');
    }
  }

  /// Mengambil akun berdasarkan ID
  Future<Account> getAccountById(String accountId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/accounts/$accountId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        return Account.fromJson(jsonData);
      } else {
        throw Exception('Failed to load account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching account: $e');
    }
  }

  /// Mengambil akun berdasarkan customer ID
  Future<List<Account>> getAccountsByCustomerId(String customerId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/customers/$customerId/accounts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'] ?? [];
        return jsonList.map((json) => Account.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load customer accounts: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching customer accounts: $e');
    }
  }

  /// Membuat akun Deposito baru
  Future<Account> createAccount({
    required String customerId,
    required String depositoTypeId,
    required String depositDate,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        'customerId': customerId,
        'depositoTypeId': depositoTypeId,
        'balance': 0,
        'depositDate': depositDate,
      };

      final response = await httpClient.post(
        Uri.parse('$baseUrl/accounts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body)['data'];
        return Account.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Failed to create account: ${errorData['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating account: $e');
    }
  }

  /// Update akun Deposito
  Future<Account> updateAccount({
    required String accountId,
    required double balance,
    String? depositoTypeId,
  }) async {
    try {
      Map<String, dynamic> requestBody = {'balance': balance};

      if (depositoTypeId != null && depositoTypeId.isNotEmpty) {
        requestBody['depositoTypeId'] = depositoTypeId;
      }

      final response = await httpClient.put(
        Uri.parse('$baseUrl/accounts/$accountId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        return Account.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          'Failed to update account: ${errorData['message'] ?? response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating account: $e');
    }
  }

  /// Hapus akun
  Future<void> deleteAccount(String accountId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/accounts/$accountId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete account: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting account: $e');
    }
  }

  // ==================== TRANSACTION ====================

  /// Mengambil semua transaksi
  Future<List<Transaction>> getAllTransactions() async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/transactions'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'] ?? [];
        return jsonList.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  /// Mengambil transaksi untuk akun tertentu
  Future<List<Transaction>> getAccountTransactions(String accountId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/accounts/$accountId/transactions'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'] ?? [];
        return jsonList.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load account transactions: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching account transactions: $e');
    }
  }

  /// Melakukan Deposit
  Future<Transaction> deposit({
    required String accountId,
    required double amount,
    required String date,
    String? description,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/transactions/deposit'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'account_id': accountId,
          'transaction_type': 'Deposit',
          'transaction_amount': amount,
          'transaction_date': date,
          'transaction_description': description ?? 'Setoran tunai',
        }),
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body)['data'];
        return Transaction.fromJson(jsonData);
      } else {
        throw Exception('Failed to create deposit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating deposit: $e');
    }
  }

  /// Melakukan Withdrawal
  Future<Map<String, dynamic>> withdraw({
    required String accountId,
    required double amount,
    required String date,
    String? description,
  }) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/transactions/withdraw'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'account_id': accountId,
          'transaction_type': 'Withdraw',
          'transaction_amount': amount,
          'transaction_date': date,
          'transaction_description': description ?? 'Penarikan tunai',
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create withdrawal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating withdrawal: $e');
    }
  }

  // ==================== DEPOSITO TYPE ====================

  /// Mengambil semua jenis deposito
  Future<List<DepositoType>> getAllDepositoTypes() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/deposito-types'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonList = [];
        if (decoded is Map) {
          if (decoded['data'] is List) {
            jsonList = decoded['data'];
          } else if (decoded['results'] is List) {
            jsonList = decoded['results'];
          } else if (decoded['data'] is Map &&
              decoded['data']['docs'] is List) {
            jsonList = decoded['data']['docs'];
          }
        } else if (decoded is List) {
          jsonList = decoded;
        }

        return jsonList.map((json) => DepositoType.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load deposito types: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching deposito types: $e');
    }
  }

  /// Mengambil jenis deposito berdasarkan ID
  Future<DepositoType> getDepositoTypeById(int depositoTypeId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/deposito-types/$depositoTypeId'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        return DepositoType.fromJson(jsonData);
      } else {
        throw Exception('Failed to load deposito type: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching deposito type: $e');
    }
  }
}
