import 'package:provider/provider.dart';
import 'package:frontend/controllers/customer_controller.dart';
import 'package:frontend/views/widgets/index.dart';
import 'package:flutter/material.dart' hide ErrorWidget;

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({Key? key}) : super(key: key);

  @override
  State<CustomerManagementScreen> createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Nasabah'), elevation: 0),
      body: Consumer<CustomerController>(
        builder: (context, customerController, _) {
          print(customerController.customers.length);
          if (customerController.isLoading &&
              customerController.customers.isEmpty) {
            return const LoadingWidget(message: 'Memuat nasabah...');
          }

          if (customerController.errorMessage != null &&
              customerController.customers.isEmpty) {
            return ErrorWidget(
              message: customerController.errorMessage!,
              onRetry: () => customerController.fetchCustomers(),
            );
          }

          if (customerController.customers.isEmpty) {
            return const EmptyWidget(
              message: 'Belum ada nasabah',
              icon: Icons.people_outline,
            );
          }

          return RefreshIndicator(
            onRefresh: () => customerController.fetchCustomers(),
            child: ListView.builder(
              // Tambahkan AlwaysScrollable agar RefreshIndicator selalu bisa ditarik
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: customerController.customers.length,
              itemBuilder: (context, index) {
                final customer = customerController.customers[index];
                return CustomerCard(
                  customer: customer,
                  onEdit: () => _showCustomerForm(context, customer: customer),
                  onDelete: () {
                    _showDeleteConfirmation(
                      context,
                      customer.name,
                      () => customerController.deleteCustomer(customer.id),
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
          _showCustomerForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCustomerForm(BuildContext context, {dynamic customer}) {
    final isEditing = customer != null;
    final nameController = TextEditingController(
      text: isEditing ? customer.name : '',
    );
    final addressController = TextEditingController(
      text: isEditing ? (customer.address ?? '') : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? (customer.phone ?? '') : '',
    );
    final emailController = TextEditingController(
      text: isEditing ? (customer.email ?? '') : '',
    );

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isEditing ? 'Edit Nasabah' : 'Tambah Nasabah',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Nasabah',
                      hintText: 'Masukkan nama nasabah',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      hintText: 'Masukkan alamat',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      hintText: 'Masukkan nomor telepon',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Masukkan email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (isEditing) {
                        await context.read<CustomerController>().updateCustomer(
                          id: customer.id,
                          name: nameController.text,
                          address: addressController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                        );
                        if (context.mounted) {
                          final controller = context.read<CustomerController>();
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
                                content: Text('Nasabah berhasil diperbarui'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        await context.read<CustomerController>().createCustomer(
                          name: nameController.text,
                          address: addressController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                        );
                        if (context.mounted) {
                          final controller = context.read<CustomerController>();
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
                                content: Text('Nasabah berhasil ditambahkan'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    child: Text(isEditing ? 'Update' : 'Tambah'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String name,
    Function() onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Hapus nasabah "$name"?'),
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
                    const SnackBar(content: Text('Nasabah berhasil dihapus')),
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
