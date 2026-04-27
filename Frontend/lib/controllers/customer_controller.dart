import 'package:flutter/foundation.dart';
import 'package:frontend/models/index.dart';
import 'package:frontend/services/bank_api_service.dart';

class CustomerController extends ChangeNotifier {
  final BankApiService apiService;

  CustomerController({required this.apiService});

  List<Customer> _customers = [];
  Customer? _selectedCustomer;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Customer> get customers => _customers;
  Customer? get selectedCustomer => _selectedCustomer;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all customers
  Future<void> fetchCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // UI tampil loading

    try {
      final data = await apiService.getAllCustomers();
      _customers = data; 
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    
    notifyListeners(); 
  }

  // Get customer by ID
  Future<void> fetchCustomerById(String customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedCustomer = await apiService.getCustomerById(customerId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _selectedCustomer = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new customer
  Future<void> createCustomer({
    required String name,
    String? address,
    String? phone,
    String? email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCustomer = await apiService.createCustomer(
        name: name,
        address: address,
        phone: phone,
        email: email,
      );
      _customers.add(newCustomer);
      _selectedCustomer = newCustomer;
      // Refresh list from server to ensure consistency
      await fetchCustomers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update customer
  Future<void> updateCustomer({
    required String id,
    required String name,
    String? address,
    String? phone,
    String? email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCustomer = await apiService.updateCustomer(
        customerId: id,
        name: name,
        address: address,
        phone: phone,
        email: email,
      );

      final index = _customers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _customers[index] = updatedCustomer;
      }

      if (_selectedCustomer?.id == id) {
        _selectedCustomer = updatedCustomer;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete customer
  Future<void> deleteCustomer(String customerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await apiService.deleteCustomer(customerId);
      _customers.removeWhere((c) => c.id == customerId);
      if (_selectedCustomer?.id == customerId) {
        _selectedCustomer = null;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear selected customer
  void clearSelectedCustomer() {
    _selectedCustomer = null;
    notifyListeners();
  }
}
