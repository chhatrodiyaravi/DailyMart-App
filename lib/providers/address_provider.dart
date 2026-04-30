import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Address> _addresses = [];
  Address? _selectedAddress;

  List<Address> get addresses => List.unmodifiable(_addresses);
  Address? get selectedAddress => _selectedAddress;

  /// Fetch addresses for a specific user
  Future<void> fetchAddresses(String userId) async {
    if (userId.isEmpty) return;
    
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .get();

    _addresses = snapshot.docs
        .map((doc) => Address.fromMap(doc.id, doc.data()))
        .toList();

    // Set default selected address if available
    if (_addresses.isNotEmpty) {
      _selectedAddress = _addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => _addresses.first,
      );
    } else {
      _selectedAddress = null;
    }
    
    notifyListeners();
  }

  /// Add a new address
  Future<void> addAddress(String userId, Address address) async {
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    final docRef = await _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .add(address.toMap());

    final newAddress = address.copyWith(id: docRef.id);
    _addresses.add(newAddress);
    
    _selectedAddress ??= newAddress;
    
    notifyListeners();
  }

  /// Delete an address
  Future<void> deleteAddress(String userId, String addressId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .delete();

    _addresses.removeWhere((a) => a.id == addressId);
    
    if (_selectedAddress?.id == addressId) {
      _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
    }
    
    notifyListeners();
  }

  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }
}
