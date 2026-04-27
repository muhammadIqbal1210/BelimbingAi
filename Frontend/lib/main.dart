import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/services/bank_api_service.dart';
import 'package:frontend/controllers/customer_controller.dart';
import 'package:frontend/controllers/account_controller.dart';
import 'package:frontend/controllers/transaction_controller.dart';
import 'package:frontend/controllers/deposito_type_controller.dart';
import 'package:frontend/constants/app_theme.dart';
import 'package:frontend/views/screens/index.dart';
import 'package:frontend/models/account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // API Service
        Provider<BankApiService>(create: (_) => BankApiService()),
        // Controllers
        ChangeNotifierProvider<CustomerController>(
          create: (context) =>
              CustomerController(apiService: context.read<BankApiService>()),
        ),
        ChangeNotifierProvider<AccountController>(
          create: (context) =>
              AccountController(apiService: context.read<BankApiService>()),
        ),
        ChangeNotifierProvider<TransactionController>(
          create: (context) =>
              TransactionController(apiService: context.read<BankApiService>()),
        ),
        ChangeNotifierProvider<DepositoTypeController>(
          create: (context) => DepositoTypeController(
            apiService: context.read<BankApiService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Belimbing Bank',
        theme: AppTheme.lightTheme,
        home: const DashboardScreen(),
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/customers': (context) => const CustomerManagementScreen(),
          '/accounts': (context) => const AccountManagementScreen(),
          '/transaction': (context) {
            final account =
                ModalRoute.of(context)!.settings.arguments as Account;
            return TransactionScreen(account: account);
          },
          '/result': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return ResultViewScreen(
              account: args['account'],
              transactionType: args['transactionType'],
              amount: args['amount'],
              date: args['date'],
              description: args['description'],
            );
          },
        },
      ),
    );
  }
}
