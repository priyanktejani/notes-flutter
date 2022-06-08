import 'package:notes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;

  Future<AuthUser?> logIn({
    required email,
    required password,
  });

  Future<AuthUser?> creatrUser({
    required email,
    required password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();
}
