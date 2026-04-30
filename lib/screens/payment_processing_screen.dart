import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import 'order_success_screen.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({
    super.key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.deliveryAddress,
  });

  final String paymentMethod;
  final double totalAmount;
  final String deliveryAddress;

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool _paymentDone = false;

  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  late AnimationController _checkAnimController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _checkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkAnimController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _upiController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    _checkAnimController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _paymentDone = true;
    });
    _checkAnimController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    final cart = context.read<CartProvider>();
    try {
      final String orderId = await context.read<OrdersProvider>().placeOrder(
            userId: auth.currentUid,
            customer: auth.currentEmail,
            products: cart.cartProducts,
            quantities: cart.items,
            amount: widget.totalAmount,
            paymentMethod: widget.paymentMethod,
            paymentStatus: 'Paid',
            deliveryAddress: widget.deliveryAddress,
          );
      cart.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(
            orderId: orderId,
            paymentMethod: widget.paymentMethod,
          ),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _paymentDone = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAmountCard(),
            const SizedBox(height: 28),
            if (_paymentDone)
              _buildSuccessView()
            else if (_isProcessing)
              _buildProcessingView()
            else
              _buildPaymentForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Total Amount',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14)),
          const SizedBox(height: 6),
          Text('Rs ${widget.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.paymentMethod == 'UPI' ? Icons.account_balance : Icons.credit_card,
                  color: Colors.white, size: 16,
                ),
                const SizedBox(width: 6),
                Text(widget.paymentMethod,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentForm() {
    final bool isUpi = widget.paymentMethod == 'UPI';
    return Form(
      key: _formKey,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isUpi ? 'Enter UPI Details' : 'Enter Card Details',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
              const SizedBox(height: 18),
              if (isUpi)
                _buildField(_upiController, 'UPI ID', 'yourname@upi', Icons.account_balance,
                    validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Please enter your UPI ID';
                  if (!v.contains('@')) return 'Enter a valid UPI ID (e.g. name@upi)';
                  return null;
                })
              else ...[
                _buildField(_cardHolderController, 'Card Holder Name', '', Icons.person_outline),
                const SizedBox(height: 14),
                _buildField(_cardNumberController, 'Card Number', '4242 4242 4242 4242',
                    Icons.credit_card,
                    keyboard: TextInputType.number, maxLen: 19, validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Please enter card number';
                  if (v.replaceAll(' ', '').length < 16) return 'Enter valid 16-digit number';
                  return null;
                }),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                      child: _buildField(
                          _expiryController, 'Expiry', 'MM/YY', Icons.calendar_today,
                          keyboard: TextInputType.datetime, maxLen: 5)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: _buildField(_cvvController, 'CVV', '•••', Icons.lock_outline,
                          keyboard: TextInputType.number, maxLen: 3, obscure: true,
                          validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.length < 3) return 'Invalid';
                    return null;
                  })),
                ]),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _processPayment,
                  icon: Icon(isUpi ? Icons.account_balance : Icons.lock, size: 20),
                  label: Text('Pay Rs ${widget.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.shield_outlined, size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text('Secured by 256-bit SSL Encryption',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, String hint, IconData icon,
      {TextInputType? keyboard,
      int? maxLen,
      bool obscure = false,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLength: maxLen,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
        counterText: '',
      ),
      validator: validator ??
          (v) {
            if (v == null || v.trim().isEmpty) return 'Please enter $label';
            return null;
          },
    );
  }

  Widget _buildProcessingView() {
    return Column(children: [
      const SizedBox(height: 40),
      SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(strokeWidth: 4, color: Colors.green.shade700)),
      const SizedBox(height: 24),
      const Text('Processing Payment...',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Text('Please wait while we verify your payment',
          style: TextStyle(color: Colors.grey.shade600)),
      const SizedBox(height: 16),
      Text('Do not close this screen',
          style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600, fontSize: 13)),
    ]);
  }

  Widget _buildSuccessView() {
    return Column(children: [
      const SizedBox(height: 40),
      ScaleTransition(
        scale: _checkAnimation,
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
          child: Icon(Icons.check_circle, size: 64, color: Colors.green.shade700),
        ),
      ),
      const SizedBox(height: 20),
      const Text('Payment Successful!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.green)),
      const SizedBox(height: 8),
      Text('Placing your order...', style: TextStyle(color: Colors.grey.shade600)),
    ]);
  }
}
