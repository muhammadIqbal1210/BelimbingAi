import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/controllers/account_controller.dart';
import 'package:frontend/controllers/transaction_controller.dart';
import 'package:frontend/controllers/deposito_type_controller.dart';
import 'package:frontend/models/account.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/constants/app_constants.dart';

class TransactionScreen extends StatefulWidget {
  final Account account;

  const TransactionScreen({Key? key, required this.account}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  DateTime? selectedDate;
  String? selectedTransactionType;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    descriptionController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTransactionType = transactionTypeDeposit;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi'), elevation: 0),
      body: Consumer<TransactionController>(
        builder: (context, transactionController, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Account Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Akun Deposito',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID Akun:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            widget.account.accountId,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jenis:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Deposito',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saldo:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            DateTimeUtil.formatCurrency(widget.account.balance),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Transaction Type Selection
              Text(
                'Pilih Jenis Transaksi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTransactionType = transactionTypeDeposit;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedTransactionType == transactionTypeDeposit
                            ? Colors.green
                            : Colors.grey,
                      ),
                      child: const Text('Setoran'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedTransactionType = transactionTypeWithdraw;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedTransactionType == transactionTypeWithdraw
                            ? Colors.red
                            : Colors.grey,
                      ),
                      child: const Text('Penarikan'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Amount Input
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Transaksi',
                  hintText: 'Masukkan jumlah',
                  prefixText: 'Rp. ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal Transaksi',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedDate != null
                                ? DateTimeUtil.formatDate(selectedDate!)
                                : 'Pilih tanggal',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Opsional)',
                  hintText: 'Masukkan keterangan transaksi',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              // Submit Button
              Consumer<TransactionController>(
                builder: (context, transactionController, _) {
                  return ElevatedButton(
                    onPressed: transactionController.isLoading
                        ? null
                        : () {
                            _submitTransaction(context);
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: transactionController.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Kirim Transaksi'),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitTransaction(BuildContext context) {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jumlah tidak valid')));
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal terlebih dahulu')),
      );
      return;
    }

    if (selectedTransactionType == transactionTypeWithdraw) {
      // Navigate to result screen for withdrawal
      Navigator.pushNamed(
        context,
        '/result',
        arguments: {
          'account': widget.account,
          'transactionType': selectedTransactionType,
          'amount': amount,
          'date': selectedDate,
          'description': descriptionController.text,
        },
      );
    } else {
      // Perform deposit
      context.read<TransactionController>().performDeposit(
        accountId: widget.account.accountId,
        amount: amount,
        date: selectedDate!.toIso8601String().split('T')[0],
        description: descriptionController.text,
      );

      // Show success dialog
      _showSuccessDialog(context, amount);
    }
  }

  void _showSuccessDialog(BuildContext context, double amount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Setoran Berhasil'),
          content: Text(
            'Setoran sebesar ${DateTimeUtil.formatCurrency(amount)} berhasil dilakukan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
