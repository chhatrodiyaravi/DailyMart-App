import 'package:flutter/foundation.dart';

enum AppRole { guest, customer, admin }

class AuthProvider extends ChangeNotifier {
  static const String _defaultAdminEmail = 'admin@grocery.com';
  static const String _defaultAdminPassword = 'Admin@123';

  static const String adminEmail = String.fromEnvironment(
    'ADMIN_EMAIL',
    defaultValue: _defaultAdminEmail,
  );
  static const String adminPassword = String.fromEnvironment(
    'ADMIN_PASSWORD',
    defaultValue: _defaultAdminPassword,
  );

  AppRole _role = AppRole.guest;
  String _currentEmail = 'guest@local';

  AppRole get role => _role;
  bool get isAdmin => _role == AppRole.admin;
  bool get isCustomer => _role == AppRole.customer;
  bool get isGuest => _role == AppRole.guest;
  String get currentEmail => _currentEmail;
  bool get isUsingDefaultAdminCredentials =>
      adminEmail == _defaultAdminEmail &&
      adminPassword == _defaultAdminPassword;

  bool loginCustomer({required String email, required String password}) {
    final String normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.contains('@') || password.trim().length < 6) {
      return false;
    }
    _role = AppRole.customer;
    _currentEmail = normalizedEmail;
    notifyListeners();
    return true;
  }

  bool loginAdmin({required String email, required String password}) {
    if (email.trim().toLowerCase() != adminEmail || password != adminPassword) {
      return false;
    }
    _role = AppRole.admin;
    _currentEmail = adminEmail;
    notifyListeners();
    return true;
  }

  void continueAsGuest() {
    _role = AppRole.guest;
    _currentEmail = 'guest@local';
    notifyListeners();
  }

  void logout() {
    continueAsGuest();
  }
}
