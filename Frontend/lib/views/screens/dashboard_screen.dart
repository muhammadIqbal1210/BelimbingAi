import 'package:provider/provider.dart';
import 'package:frontend/controllers/account_controller.dart';
import 'package:frontend/controllers/customer_controller.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/views/widgets/index.dart';
import 'package:frontend/views/screens/customer_management_screen.dart';
import 'package:frontend/views/screens/account_management_screen.dart';
import 'package:flutter/material.dart' hide ErrorWidget;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    context.read<CustomerController>().fetchCustomers();
    context.read<AccountController>().fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Belimbing Bank'), elevation: 0),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Nasabah'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Akun',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const CustomerManagementScreen();
      case 2:
        return const AccountManagementScreen();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return Consumer2<AccountController, CustomerController>(
      builder: (context, accountController, customerController, _) {
        if (accountController.isLoading) {
          return const LoadingWidget(message: 'Memuat data akun...');
        }

        if (accountController.errorMessage != null) {
          return ErrorWidget(
            message: accountController.errorMessage!,
            onRetry: _loadData,
          );
        }

        if (accountController.accounts.isEmpty) {
          return const EmptyWidget(
            message: 'Belum ada akun',
            icon: Icons.account_balance_wallet,
          );
        }

        // Calculate total balance
        double totalBalance = 0;
        for (var account in accountController.accounts) {
          totalBalance += account.balance;
        }

        return RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: ListView(
            children: [
              // Balance Summary Card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.blue[600],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Saldo',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateTimeUtil.formatCurrency(totalBalance),
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryItem(
                              context,
                              'Akun',
                              accountController.accounts.length.toString(),
                              Colors.white70,
                            ),
                            _buildSummaryItem(
                              context,
                              'Nasabah',
                              customerController.customers.length.toString(),
                              Colors.white70,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Accounts List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Daftar Akun',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accountController.accounts.length,
                itemBuilder: (context, index) {
                  final account = accountController.accounts[index];
                  return AccountCard(
                    account: account,
                    onTap: () {
                      // Navigasi ke transaction page
                      Navigator.pushNamed(
                        context,
                        '/transaction',
                        arguments: account,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    Color textColor,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
