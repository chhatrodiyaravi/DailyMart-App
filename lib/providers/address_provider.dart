import '../models/app_user.dart';
import 'deferred_change_notifier.dart';

class AddressProvider extends DeferredChangeNotifier {
  String _selectedAddress = '';
  String _selectedLabel = 'Home';
  String? _syncedUserId;

  String get selectedAddress => _selectedAddress;
  String get selectedLabel => _selectedLabel;
  bool get hasSelectedAddress => _selectedAddress.trim().isNotEmpty;

  void syncFromUser(AppUser? user) {
    if (user == null) {
      clear();
      return;
    }

    final bool shouldRefresh =
        _syncedUserId != user.id || _selectedAddress.trim().isEmpty;
    if (!shouldRefresh) {
      return;
    }

    _syncedUserId = user.id;
    _selectedAddress = user.address.trim();
    _selectedLabel = _selectedAddress.isEmpty ? 'Home' : 'Saved Address';
    safeNotifyListeners();
  }

  void setSelectedAddress(String address, {String? label}) {
    _selectedAddress = address.trim();
    _selectedLabel =
        label ?? (_selectedAddress.isEmpty ? 'Home' : 'Saved Address');
    safeNotifyListeners();
  }

  void clear() {
    _selectedAddress = '';
    _selectedLabel = 'Home';
    _syncedUserId = null;
    safeNotifyListeners();
  }
}
