import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartProvider cart = context.watch<CartProvider>();
    final AuthProvider auth = context.watch<AuthProvider>();
    final double itemTotal = cart.totalPrice;
    final double deliveryFee = 25;
    final double handlingFee = 8;
    final double grandTotal = itemTotal + deliveryFee + handlingFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          _SectionCard(
            title: 'Delivery Address',
            icon: Icons.location_on_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '221B Green Street, Bangalore',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                TextButton(onPressed: () {}, child: const Text('Change')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Payment Method',
            icon: Icons.payments_outlined,
            child: Column(
              children: [
                const _PaymentTile(label: 'UPI', selected: true),
                const _PaymentTile(label: 'Credit / Debit Card'),
                const _PaymentTile(label: 'Cash on Delivery'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Order Summary',
            icon: Icons.receipt_long_outlined,
            child: Column(
              children: [
                for (final Product product in cart.cartProducts)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(product.name)),
                        Text('x${cart.quantityFor(product.id)}'),
                        const SizedBox(width: 10),
                        Text(
                          'Rs ${(product.price * cart.quantityFor(product.id)).toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 24),
                _PriceRow(label: 'Item Total', value: itemTotal),
                _PriceRow(label: 'Delivery Fee', value: deliveryFee),
                _PriceRow(label: 'Handling Fee', value: handlingFee),
                const SizedBox(height: 6),
                _PriceRow(
                  label: 'Grand Total',
                  value: grandTotal,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 50,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              onPressed: cart.totalItems == 0
                  ? null
                  : () async {
                      await context.read<OrdersProvider>().placeOrder(
                        customer: auth.currentEmail,
                        products: cart.cartProducts,
                        quantities: cart.items,
                        amount: grandTotal,
                      );
                      cart.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderSuccessScreen(),
                        ),
                      );
                    },
              child: Text('Place Order  Rs ${grandTotal.toStringAsFixed(0)}'),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final double value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
      fontSize: isBold ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text('Rs ${value.toStringAsFixed(0)}', style: style),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? Colors.green.shade700 : Colors.grey,
      ),
      title: Text(label),
    );
  }
}
