import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'admin/admin_shell_screen.dart';
import 'main_shell_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
    );
  }

  void _openAdmin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminShellScreen()),
    );
  }

  void _submitLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final AuthProvider auth = context.read<AuthProvider>();
    final bool isSuccess = auth.loginCustomer(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid customer credentials.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    _openHome();
  }

  void _submitAdminLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final AuthProvider auth = context.read<AuthProvider>();
    final bool isSuccess = auth.loginAdmin(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!isSuccess) {
      final AuthProvider authProvider = context.read<AuthProvider>();
      final String message = authProvider.isUsingDefaultAdminCredentials
          ? 'Invalid admin credentials. Use admin@grocery.com / Admin@123'
          : 'Invalid admin credentials. Check ADMIN_EMAIL and ADMIN_PASSWORD values.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    FocusScope.of(context).unfocus();
    _openAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 72,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Login to continue shopping fresh groceries',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final String email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!email.contains('@') || !email.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final String password = value ?? '';
                    if (password.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (password.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _submitLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: _submitAdminLogin,
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    label: const Text('Login as Admin'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().continueAsGuest();
                    _openHome();
                  },
                  child: const Text('Continue as Guest'),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
