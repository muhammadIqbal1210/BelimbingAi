import 'package:flutter/foundation.dart';
import 'package:frontend/models/index.dart';
import 'package:frontend/services/bank_api_service.dart';

class AccountController extends ChangeNotifier {
  final BankApiService apiService;

  AccountController({required this.apiService});

  List<Account> _accounts = [];
  List<Account> _customerAccounts = [];
  Account? _selectedAccount;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Account> get accounts => _accounts;
  List<Account> get customerAccounts => _customerAccounts;
  Account? get selectedAccount => _selectedAccount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all accounts
  Future<void> fetchAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _accounts = await apiService.getAllAccounts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _accounts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get account by ID
  Future<void> fetchAccountById(String accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedAccount = await apiService.getAccountById(accountId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _selectedAccount = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get accounts by customer ID
  Future<void> fetchAccountsByCustomerId(String customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _customerAccounts = await apiService.getAccountsByCustomerId(customerId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _customerAccounts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new Deposito account
  Future<void> createAccount({
    required String customerId,
    required String depositoTypeId,
    required String depositDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newAccount = await apiService.createAccount(
        customerId: customerId,
        depositoTypeId: depositoTypeId,
        depositDate: depositDate,
      );
      _accounts.add(newAccount);
      _customerAccounts.add(newAccount);
      _selectedAccount = newAccount;
      // Refresh list from server to ensure newly created account appears on full fetch
      await fetchAccounts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update account
  Future<void> updateAccount({
    required String accountId,
    required double balance,
    String? depositoTypeId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedAccount = await apiService.updateAccount(
        accountId: accountId,
        balance: balance,
        depositoTypeId: depositoTypeId,
      );

      final index = _accounts.indexWhere((a) => a.accountId == accountId);
      if (index != -1) {
        _accounts[index] = updatedAccount;
      }

      final customerIndex = _customerAccounts.indexWhere(
        (a) => a.accountId == accountId,
      );
      if (customerIndex != -1) {
        _customerAccounts[customerIndex] = updatedAccount;
      }

      if (_selectedAccount?.accountId == accountId) {
        _selectedAccount = updatedAccount;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete account
  Future<void> deleteAccount(String accountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await apiService.deleteAccount(accountId);
      _accounts.removeWhere((a) => a.accountId == accountId);
      _customerAccounts.removeWhere((a) => a.accountId == accountId);
      if (_selectedAccount?.accountId == accountId) {
        _selectedAccount = null;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear selected account
  void clearSelectedAccount() {
    _selectedAccount = null;
    notifyListeners();
  }

  // Clear customer accounts
  void clearCustomerAccounts() {
    _customerAccounts = [];
    notifyListeners();
  }
}
