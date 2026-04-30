import 'package:flutter/material.dart';

import 'main_shell_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({
    super.key,
    this.orderId,
    this.paymentMethod,
  });

  final String? orderId;
  final String? paymentMethod;

  @override
  Widget build(BuildContext context) {
    final String displayId = orderId != null
        ? 'DM-${orderId!.substring(0, orderId!.length > 8 ? 8 : orderId!.length).toUpperCase()}'
        : '';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 70,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Order Placed Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
              ),
              if (displayId.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Order #$displayId',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
              if (paymentMethod != null) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      paymentMethod == 'Cash on Delivery'
                          ? Icons.money
                          : paymentMethod == 'UPI'
                              ? Icons.account_balance
                              : Icons.credit_card,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      paymentMethod == 'Cash on Delivery'
                          ? 'Pay on Delivery'
                          : 'Paid via $paymentMethod',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Your groceries are being packed and will arrive soon.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainShellScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Continue Shopping'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    side: BorderSide(color: Colors.green.shade700),
                  ),
                  onPressed: () {
                    // Navigate to profile (tab index 3) to see order history
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainShellScreen(initialTab: 3),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'View My Orders',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
