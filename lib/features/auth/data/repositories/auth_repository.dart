import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> currentUser();
  Future<User> signIn(String email, String password);
  Future<User> signUp({required String email, required String password, required String name});
  Future<void> signOut();
}

class MockAuthRepository implements AuthRepository {
  User? _user;
  static const _d = Duration(milliseconds: 500);
  @override Future<User?> currentUser() async { await Future<void>.delayed(_d); return _user; }
  @override Future<User> signIn(String email, String password) async {
    await Future<void>.delayed(_d);
    if (password.length < 4) throw Exception('Password too short');
    _user = User(id: 'u_${email.hashCode}', email: email, name: email.split('@').first);
    return _user!;
  }
  @override Future<User> signUp({required String email, required String password, required String name}) async {
    await Future<void>.delayed(_d);
    if (!email.contains('@')) throw Exception('Invalid email');
    _user = User(id: 'u_${email.hashCode}', email: email, name: name);
    return _user!;
  }
  @override Future<void> signOut() async { await Future<void>.delayed(_d); _user = null; }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => MockAuthRepository());
