class Address {
  const Address({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    this.isDefault = false,
  });

  final String id;
  final String label; // e.g., Home, Work, Other
  final String fullAddress;
  final String city;
  final String state;
  final String pincode;
  final String phone;
  final bool isDefault;

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'fullAddress': fullAddress,
      'city': city,
      'state': state,
      'pincode': pincode,
      'phone': phone,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(String id, Map<String, dynamic> map) {
    return Address(
      id: id,
      label: map['label'] ?? 'Home',
      fullAddress: map['fullAddress'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      phone: map['phone'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  Address copyWith({
    String? id,
    String? label,
    String? fullAddress,
    String? city,
    String? state,
    String? pincode,
    String? phone,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      fullAddress: fullAddress ?? this.fullAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
