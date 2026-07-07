class User {
  final String id;
  final String email;
  final String name;
  const User({required this.id, required this.email, required this.name});
  User copyWith({String? id, String? email, String? name}) =>
      User(id: id ?? this.id, email: email ?? this.email, name: name ?? this.name);
  @override
  bool operator ==(Object other) => other is User && other.id == id;
  @override
  int get hashCode => id.hashCode;
}

class AuthSession {
  final User user;
  final DateTime expiresAt;
  const AuthSession({required this.user, required this.expiresAt});
}
