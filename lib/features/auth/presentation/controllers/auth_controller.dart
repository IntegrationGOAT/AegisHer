import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class AuthState {
  final User? user;
  final bool loading;
  final String? error;
  const AuthState({this.user, this.loading = false, this.error});
  AuthState copyWith({User? user, bool? loading, String? error, bool clearUser = false, bool clearError = false}) =>
      AuthState(user: clearUser ? null : (user ?? this.user), loading: loading ?? this.loading, error: clearError ? null : (error ?? this.error));
}

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;
  AuthController(this._ref) : super(const AuthState()) { _bootstrap(); }
  Future<void> _bootstrap() async { final u = await _ref.read(authRepositoryProvider).currentUser(); if (mounted) state = state.copyWith(user: u); }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    try { final u = await _ref.read(authRepositoryProvider).signIn(email, password); state = state.copyWith(user: u, loading: false); }
    catch (e) { state = state.copyWith(loading: false, error: e.toString()); }
  }
  Future<void> signUp({required String email, required String password, required String name}) async {
    state = state.copyWith(loading: true, clearError: true);
    try { final u = await _ref.read(authRepositoryProvider).signUp(email: email, password: password, name: name); state = state.copyWith(user: u, loading: false); }
    catch (e) { state = state.copyWith(loading: false, error: e.toString()); }
  }
  Future<void> signOut() async { await _ref.read(authRepositoryProvider).signOut(); state = state.copyWith(clearUser: true); }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) => AuthController(ref));
