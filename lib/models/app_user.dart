class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.address = '',
    this.isBlocked = false,
    this.isAdmin = false,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final bool isBlocked;
  final bool isAdmin;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    bool? isBlocked,
    bool? isAdmin,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isBlocked: isBlocked ?? this.isBlocked,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'isBlocked': isBlocked,
      'isAdmin': isAdmin,
    };
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      isBlocked: map['isBlocked'] ?? false,
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
