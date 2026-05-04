import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/address_model.dart';
import '../models/app_user.dart';

class AddressProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Address> _addresses = [];
  Address? _selectedAddress;
  String _selectedAddressText = '';
  String _selectedLabel = 'Home';
  String? _syncedUserId;

  List<Address> get addresses => List.unmodifiable(_addresses);
  Address? get selectedAddress => _selectedAddress;
  String get selectedAddressText => _selectedAddressText;
  String get selectedLabel => _selectedLabel;
  bool get hasSelectedAddressText => _selectedAddressText.trim().isNotEmpty;

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

    if (_addresses.isNotEmpty) {
      _selectedAddress = _addresses.firstWhere(
        (address) => address.isDefault,
        orElse: () => _addresses.first,
      );
      _selectedAddressText = _selectedAddress!.fullAddress;
      _selectedLabel = _selectedAddress!.label;
    } else {
      _selectedAddress = null;
      _selectedAddressText = '';
      _selectedLabel = 'Home';
    }

    notifyListeners();
  }

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
    if (_selectedAddress == newAddress) {
      _selectedAddressText = newAddress.fullAddress;
      _selectedLabel = newAddress.label;
    }

    notifyListeners();
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(addressId)
        .delete();

    _addresses.removeWhere((address) => address.id == addressId);

    if (_selectedAddress?.id == addressId) {
      _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
      _selectedAddressText = _selectedAddress?.fullAddress ?? '';
      _selectedLabel = _selectedAddress?.label ?? 'Home';
    }

    notifyListeners();
  }

  void selectAddress(Address address) {
    _selectedAddress = address;
    _selectedAddressText = address.fullAddress;
    _selectedLabel = address.label;
    notifyListeners();
  }

  void syncFromUser(AppUser? user) {
    if (user == null) {
      clear();
      return;
    }

    final bool shouldRefresh =
        _syncedUserId != user.id || _selectedAddressText.trim().isEmpty;
    if (!shouldRefresh) {
      return;
    }

    _syncedUserId = user.id;
    _selectedAddressText = user.address.trim();
    _selectedLabel = _selectedAddressText.isEmpty ? 'Home' : 'Saved Address';
    notifyListeners();
  }

  void setSelectedAddressText(String address, {String? label}) {
    _selectedAddressText = address.trim();
    _selectedLabel =
        label ?? (_selectedAddressText.isEmpty ? 'Home' : 'Saved Address');
    notifyListeners();
  }

  void clear() {
    _addresses = [];
    _selectedAddress = null;
    _selectedAddressText = '';
    _selectedLabel = 'Home';
    _syncedUserId = null;
    notifyListeners();
  }
}
