import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AppRole { guest, customer, admin }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AppRole _role = AppRole.guest;
  User? _firebaseUser;

  AppRole get role => _role;
  bool get isAdmin => _role == AppRole.admin;
  bool get isCustomer => _role == AppRole.customer;
  bool get isGuest => _role == AppRole.guest;
  String get currentEmail => _firebaseUser?.email ?? 'guest@local';
  String get currentUid => _firebaseUser?.uid ?? '';

  /// Login existing customer with Firebase Auth
  Future<bool> loginCustomer({
    required String email,
    required String password,
  }) async {
    try {
      // If already signed in (from loginAdmin attempt), just set customer role
      if (_firebaseUser != null && _firebaseUser!.email == email.trim().toLowerCase()) {
        _role = AppRole.customer;
        notifyListeners();
        return true;
      }

      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _firebaseUser = credential.user;
      _role = AppRole.customer;
      notifyListeners();
      return true;
    } on FirebaseAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Login as admin — checks Firestore 'users' doc for isAdmin flag
  Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _firebaseUser = credential.user;

      // Check if user has admin role in Firestore
      final DocumentSnapshot userDoc =
          await _db.collection('users').doc(credential.user!.uid).get();

      if (userDoc.exists && userDoc.get('isAdmin') == true) {
        _role = AppRole.admin;
        notifyListeners();
        return true;
      } else {
        // Not an admin — but keep the session alive so loginCustomer can use it
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  /// Register new customer with Firebase Auth + save profile to Firestore
  Future<bool> registerCustomer({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Save user profile to Firestore 'users' collection
      await _db.collection('users').doc(credential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
        'isBlocked': false,
        'isAdmin': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _firebaseUser = credential.user;
      _role = AppRole.customer;
      notifyListeners();
      return true;
    } on FirebaseAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  void continueAsGuest() {
    _role = AppRole.guest;
    _firebaseUser = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _firebaseUser = null;
    _role = AppRole.guest;
    notifyListeners();
  }
}
