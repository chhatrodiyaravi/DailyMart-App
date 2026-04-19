class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.isBlocked = false,
    this.isAdmin = false,
  });

  final String id;
  final String name;
  final String email;
  final bool isBlocked;
  final bool isAdmin;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    bool? isBlocked,
    bool? isAdmin,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isBlocked: isBlocked ?? this.isBlocked,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
