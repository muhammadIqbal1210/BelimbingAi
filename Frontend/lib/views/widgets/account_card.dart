import 'package:flutter/material.dart';
import 'package:frontend/models/index.dart';
import 'package:frontend/utils/helpers.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AccountCard({
    Key? key,
    required this.account,
    this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Akun Deposito',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${account.accountId}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          PopupMenuItem(
                            child: const Text('Edit'),
                            onTap: onEdit,
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            child: const Text('Hapus'),
                            onTap: onDelete,
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Saldo: ${DateTimeUtil.formatCurrency(account.balance)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tanggal Setoran: ${DateTimeUtil.formatDate(DateTime.parse(account.depositDate))}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Customer ID: ${account.customerId}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Deposito Type ID: ${account.depositoTypeId}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
