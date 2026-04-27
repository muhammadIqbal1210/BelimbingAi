import 'package:flutter/foundation.dart';
import 'package:frontend/models/index.dart';
import 'package:frontend/services/bank_api_service.dart';

class TransactionController extends ChangeNotifier {
  final BankApiService apiService;

  TransactionController({required this.apiService});

  List<Transaction> _transactions = [];
  List<Transaction> _accountTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _transactionResult;

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Transaction> get accountTransactions => _accountTransactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get transactionResult => _transactionResult;

  // Fetch all transactions
  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await apiService.getAllTransactions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get transactions for specific account
  Future<void> fetchAccountTransactions(String accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _accountTransactions = await apiService.getAccountTransactions(accountId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _accountTransactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Perform deposit
  Future<void> performDeposit({
    required String accountId,
    required double amount,
    required String date,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _transactionResult = null;
    notifyListeners();

    try {
      final transaction = await apiService.deposit(
        accountId: accountId,
        amount: amount,
        date: date,
        description: description,
      );
      _transactions.add(transaction);
      _accountTransactions.add(transaction);

      _transactionResult = {
        'success': true,
        'type': 'Deposit',
        'amount': amount,
        'date': date,
        'message': 'Setoran berhasil dilakukan',
      };
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _transactionResult = {'success': false, 'message': _errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Perform withdrawal
  Future<void> performWithdrawal({
    required String accountId,
    required double amount,
    required String date,
    String? description,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _transactionResult = null;
    notifyListeners();

    try {
      final result = await apiService.withdraw(
        accountId: accountId,
        amount: amount,
        date: date,
        description: description,
      );

      _transactionResult = result;
      _errorMessage = null;

      // Refresh account transactions
      await fetchAccountTransactions(accountId);
    } catch (e) {
      _errorMessage = e.toString();
      _transactionResult = {'success': false, 'message': _errorMessage};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear account transactions
  void clearAccountTransactions() {
    _accountTransactions = [];
    notifyListeners();
  }

  // Clear transaction result
  void clearTransactionResult() {
    _transactionResult = null;
    notifyListeners();
  }
}
