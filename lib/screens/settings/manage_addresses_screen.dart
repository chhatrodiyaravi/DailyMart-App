import 'package:flutter/material.dart';

class ManageAddressesScreen extends StatelessWidget {
  const ManageAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Addresses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AddressCard(
            title: 'Home',
            address: '21 Green Park, MG Road, Bengaluru, Karnataka 560001',
          ),
          _AddressCard(
            title: 'Work',
            address: '9 Tech Plaza, Whitefield, Bengaluru, Karnataka 560066',
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add address feature coming soon.'),
                ),
              );
            },
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.title, required this.address});

  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.location_on_outlined, color: Colors.green.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(address),
        trailing: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Edit $title address is not available yet.'),
              ),
            );
          },
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}
