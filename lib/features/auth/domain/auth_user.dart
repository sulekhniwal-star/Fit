class AuthUser {
  final String id;
  final String? phone;
  final String? email;
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    this.phone,
    this.email,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phone == other.phone &&
          email == other.email &&
          createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ phone.hashCode ^ email.hashCode ^ createdAt.hashCode;

  @override
  String toString() => 'AuthUser(id: $id, phone: $phone, email: $email, createdAt: $createdAt)';
}

