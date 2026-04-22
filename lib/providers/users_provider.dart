import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UsersProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<AppUser> _users = [];

  List<AppUser> get users => List<AppUser>.unmodifiable(_users);

  int get activeCustomers =>
      _users.where((user) => !user.isAdmin && !user.isBlocked).length;

  /// Fetch all users from Firestore 'users' collection
  Future<void> fetchUsers() async {
    final QuerySnapshot snapshot = await _db.collection('users').get();
    _users = snapshot.docs
        .map((doc) =>
            AppUser.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  /// Block/Unblock a user in Firestore
  Future<void> setBlocked(String userId, bool blocked) async {
    await _db.collection('users').doc(userId).update({'isBlocked': blocked});
    final int index = _users.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isBlocked: blocked);
      notifyListeners();
    }
  }
}
