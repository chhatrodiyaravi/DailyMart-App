import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/product_catalog_provider.dart';
import 'admin/admin_shell_screen.dart';
import 'main_shell_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _loadAndNavigate();
  }

  Future<void> _loadAndNavigate() async {
    // Preload products from Firestore during splash — with timeout so app doesn't hang
    try {
      await context.read<ProductCatalogProvider>().fetchProducts().timeout(
        const Duration(seconds: 10),
      );
    } catch (_) {
      // If Firestore is unreachable, continue anyway — app will work in offline mode
    }

    final AuthProvider authProvider = context.read<AuthProvider>();
    await authProvider.restoreSession();

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final Widget nextScreen = authProvider.isAdmin
        ? const AdminShellScreen()
        : authProvider.isCustomer
        ? const MainShellScreen()
        : const LoginScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scale,
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.green.shade700,
                  size: 56,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'DailyMart ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
