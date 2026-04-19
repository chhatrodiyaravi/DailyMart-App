import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class UsersProvider extends ChangeNotifier {
  final List<AppUser> _users = <AppUser>[
    const AppUser(
      id: 'u-admin',
      name: 'Store Admin',
      email: 'admin@grocery.com',
      isAdmin: true,
    ),
    const AppUser(id: 'u-101', name: 'Neha Singh', email: 'neha@email.com'),
    const AppUser(id: 'u-102', name: 'Aakash Jain', email: 'aakash@email.com'),
    const AppUser(
      id: 'u-103',
      name: 'Maya Rao',
      email: 'maya@email.com',
      isBlocked: true,
    ),
  ];

  List<AppUser> get users => List<AppUser>.unmodifiable(_users);

  int get activeCustomers =>
      _users.where((user) => !user.isAdmin && !user.isBlocked).length;

  void addCustomer({required String name, required String email}) {
    final String normalizedEmail = email.trim().toLowerCase();
    final int existingIndex = _users.indexWhere(
      (u) => u.email == normalizedEmail,
    );
    if (existingIndex != -1) {
      return;
    }

    _users.add(
      AppUser(
        id: 'u-${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: normalizedEmail,
      ),
    );
    notifyListeners();
  }

  void setBlocked(String userId, bool blocked) {
    final int index = _users.indexWhere((user) => user.id == userId);
    if (index == -1 || _users[index].isAdmin) {
      return;
    }
    _users[index] = _users[index].copyWith(isBlocked: blocked);
    notifyListeners();
  }
}
