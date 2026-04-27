import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
    ).format(amount);
  }

  static String formatCurrencySimple(double amount) {
    return NumberFormat('#,##0', 'id_ID').format(amount);
  }

  static DateTime parseDate(String dateString) {
    return DateTime.parse(dateString);
  }
}

class ValidationUtil {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!value.contains('@')) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    if (value.length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }
    if (double.tryParse(value) == null) {
      return 'Jumlah harus berupa angka';
    }
    if (double.parse(value) <= 0) {
      return 'Jumlah harus lebih dari 0';
    }
    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }
}
