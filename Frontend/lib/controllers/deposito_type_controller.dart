import 'package:flutter/foundation.dart';
import 'package:frontend/models/index.dart';
import 'package:frontend/services/bank_api_service.dart';

class DepositoTypeController extends ChangeNotifier {
  final BankApiService apiService;

  DepositoTypeController({required this.apiService});

  List<DepositoType> _depositoTypes = [];
  DepositoType? _selectedDepositoType;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<DepositoType> get depositoTypes => _depositoTypes;
  DepositoType? get selectedDepositoType => _selectedDepositoType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all deposito types
  Future<void> fetchDepositoTypes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _depositoTypes = await apiService.getAllDepositoTypes();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _depositoTypes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get deposito type by ID
  Future<void> fetchDepositoTypeById(int depositoTypeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedDepositoType = await apiService.getDepositoTypeById(
        depositoTypeId,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _selectedDepositoType = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select deposito type
  void selectDepositoType(DepositoType depositoType) {
    _selectedDepositoType = depositoType;
    notifyListeners();
  }

  // Clear selected deposito type
  void clearSelectedDepositoType() {
    _selectedDepositoType = null;
    notifyListeners();
  }
}
