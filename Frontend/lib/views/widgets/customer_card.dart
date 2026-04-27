import 'package:flutter/material.dart';
import 'package:frontend/models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomerCard({
    Key? key,
    required this.customer,
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
                          customer.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer.email ?? '',
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
                customer.address ?? '',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                customer.phone ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
