import 'package:provider/provider.dart';
import 'package:frontend/controllers/account_controller.dart';
import 'package:frontend/controllers/customer_controller.dart';
import 'package:frontend/controllers/deposito_type_controller.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:frontend/views/widgets/index.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountController>().fetchAccounts();
      context.read<CustomerController>().fetchCustomers();
      context.read<DepositoTypeController>().fetchDepositoTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Akun'), elevation: 0),
      body: Consumer<AccountController>(
        builder: (context, accountController, _) {
          if (accountController.isLoading) {
            return const LoadingWidget(message: 'Memuat akun...');
          }

          if (accountController.errorMessage != null) {
            return ErrorWidget(
              message: accountController.errorMessage!,
              onRetry: () {
                context.read<AccountController>().fetchAccounts();
              },
            );
          }

          if (accountController.accounts.isEmpty) {
            return const EmptyWidget(
              message: 'Belum ada akun',
              icon: Icons.account_balance_wallet,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh all required data for account management
              await Future.wait([
                context.read<AccountController>().fetchAccounts(),
                context.read<CustomerController>().fetchCustomers(),
                context.read<DepositoTypeController>().fetchDepositoTypes(),
              ]);
              // Add a small delay to ensure UI updates
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              itemCount: accountController.accounts.length,
              itemBuilder: (context, index) {
                final account = accountController.accounts[index];
                return AccountCard(
                  account: account,
                  onEdit: () {
                    _showAccountForm(context, account: account);
                  },
                  onDelete: () {
                    _showDeleteConfirmation(
                      context,
                      account.accountId,
                      () async {
                        await context.read<AccountController>().deleteAccount(
                          account.accountId,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAccountForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAccountForm(BuildContext context, {dynamic account}) {
    final isEditing = account != null;
    String? selectedCustomerId = isEditing ? account.customerId : null;
    String? selectedDepositoTypeId = isEditing ? account.depositoTypeId : null;
    DateTime? selectedDepositDate = isEditing
        ? DateTime.tryParse(account.depositDate)
        : DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEditing ? 'Edit Akun Deposito' : 'Buat Akun Deposito',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      // Customer Dropdown
                      Consumer<CustomerController>(
                        builder: (context, customerController, _) {
                          return DropdownButtonFormField<String>(
                            value: selectedCustomerId,
                            decoration: const InputDecoration(
                              labelText: 'Nasabah',
                              hintText: 'Pilih nasabah',
                            ),
                            items: customerController.customers.map((customer) {
                              return DropdownMenuItem<String>(
                                value: customer.id.toString(),
                                child: Text(customer.name),
                              );
                            }).toList(),
                            onChanged: isEditing
                                ? null
                                : (value) {
                                    setState(() {
                                      selectedCustomerId = value;
                                    });
                                  },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      // Deposito Type Dropdown
                      Consumer<DepositoTypeController>(
                        builder: (context, depositoController, _) {
                          return DropdownButtonFormField<String>(
                            value: selectedDepositoTypeId,
                            decoration: const InputDecoration(
                              labelText: 'Jenis Deposito',
                              hintText: 'Pilih jenis deposito',
                            ),
                            items: depositoController.depositoTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type.depositoTypeId.toString(),
                                child: Text(
                                  '${type.depositoTypeName} - ${type.depositoBunga}%',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDepositoTypeId = value;
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      // Deposit Date Picker
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDepositDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDepositDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Tanggal Setoran',
                            hintText: 'Pilih tanggal setoran',
                          ),
                          child: Text(
                            selectedDepositDate != null
                                ? '${selectedDepositDate!.day}/${selectedDepositDate!.month}/${selectedDepositDate!.year}'
                                : 'Pilih tanggal',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Balance Display (Read-only)
                      InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Saldo Awal',
                          hintText: 'Saldo awal',
                        ),
                        child: Text(
                          'Rp 0,00',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedCustomerId == null ||
                              selectedDepositoTypeId == null ||
                              selectedDepositDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Silakan isi semua field'),
                              ),
                            );
                            return;
                          }

                          if (isEditing) {
                            await context
                                .read<AccountController>()
                                .updateAccount(
                                  accountId: account.accountId,
                                  balance: account.balance,
                                  depositoTypeId: selectedDepositoTypeId,
                                );
                            if (context.mounted) {
                              final controller = context
                                  .read<AccountController>();
                              if (controller.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error: ${controller.errorMessage}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Akun berhasil diperbarui'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            }
                          } else {
                            await context
                                .read<AccountController>()
                                .createAccount(
                                  customerId: selectedCustomerId!,
                                  depositoTypeId: selectedDepositoTypeId!,
                                  depositDate: selectedDepositDate!
                                      .toIso8601String(),
                                );
                            if (context.mounted) {
                              final controller = context
                                  .read<AccountController>();
                              if (controller.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error: ${controller.errorMessage}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Akun deposito berhasil dibuat',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: Text(
                          isEditing ? 'Update' : 'Buat Akun Deposito',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String accountId,
    Function() onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Hapus akun dengan ID "$accountId"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                await onConfirm();
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Akun berhasil dihapus')),
                  );
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
