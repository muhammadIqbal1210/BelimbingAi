import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/controllers/transaction_controller.dart';
// Removed unused import
import 'package:frontend/models/account.dart';
import 'package:frontend/utils/helpers.dart';

class ResultViewScreen extends StatefulWidget {
  final Account account;
  final String transactionType;
  final double amount;
  final DateTime date;
  final String? description;

  const ResultViewScreen({
    Key? key,
    required this.account,
    required this.transactionType,
    required this.amount,
    required this.date,
    this.description,
  }) : super(key: key);

  @override
  State<ResultViewScreen> createState() => _ResultViewScreenState();
}

class _ResultViewScreenState extends State<ResultViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateAndPerform();
    });
  }

  void _calculateAndPerform() {
    // Perform withdrawal with calculation
    context.read<TransactionController>().performWithdrawal(
      accountId: widget.account.accountId,
      amount: widget.amount,
      date: widget.date.toIso8601String().split('T')[0],
      description: widget.description ?? 'Penarikan tunai',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Transaksi'), elevation: 0),
      body: Consumer<TransactionController>(
        builder: (context, transactionController, _) {
          if (transactionController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = transactionController.transactionResult;

          if (result == null) {
            return const Center(child: Text('Tidak ada data hasil transaksi'));
          }

          final isSuccess = result['success'] ?? false;

          if (!isSuccess) {
            return _buildErrorView(context, result);
          }

          return _buildSuccessView(context, result);
        },
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, Map<String, dynamic> result) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 24),
            // Success Message
            Text(
              'Penarikan Berhasil',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Transaksi Anda telah berhasil diproses',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Transaction Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Transaksi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      'ID Akun',
                      widget.account.accountId,
                    ),
                    _buildDetailRow(
                      context,
                      'Jumlah Penarikan',
                      DateTimeUtil.formatCurrency(widget.amount),
                      isAmount: true,
                    ),
                    _buildDetailRow(
                      context,
                      'Tanggal Transaksi',
                      DateTimeUtil.formatDate(widget.date),
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Saldo Sebelumnya',
                      DateTimeUtil.formatCurrency(
                        widget.account.balance + widget.amount,
                      ),
                    ),
                    _buildDetailRow(
                      context,
                      'Saldo Sesudah',
                      DateTimeUtil.formatCurrency(widget.account.balance),
                      isAmount: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Calculation Details (Akun Deposito)
            _buildDepositoCalculation(context, result),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Ke Dashboard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, Map<String, dynamic> result) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.red, size: 48),
          ),
          const SizedBox(height: 24),
          Text(
            'Transaksi Gagal',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            result['message'] ?? 'Terjadi kesalahan saat memproses transaksi',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isAmount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isAmount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepositoCalculation(
    BuildContext context,
    Map<String, dynamic> result,
  ) {
    // Simulasi kalkulasi bunga deposito
    final bunga = result['bunga'] ?? 0.0;
    final finalBalance = result['final_balance'] ?? widget.account.balance;

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kalkulasi Bunga Deposito',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              'Saldo Awal',
              DateTimeUtil.formatCurrency(
                widget.account.balance + widget.amount,
              ),
            ),
            _buildDetailRow(
              context,
              'Jumlah Penarikan',
              DateTimeUtil.formatCurrency(widget.amount),
              isAmount: true,
            ),
            _buildDetailRow(
              context,
              'Bunga Deposito',
              DateTimeUtil.formatCurrency(bunga),
              isAmount: true,
            ),
            const Divider(height: 24),
            _buildDetailRow(
              context,
              'Saldo Akhir',
              DateTimeUtil.formatCurrency(finalBalance),
              isAmount: true,
            ),
          ],
        ),
      ),
    );
  }
}
