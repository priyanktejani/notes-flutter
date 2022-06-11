// import 'package:flutter_test/flutter_test.dart';
// import 'package:notes/services/auth/auth_exceptions.dart';
// import 'package:notes/services/auth/auth_provider.dart';
// import 'package:notes/services/auth/auth_user.dart';

// void main() {
// }

// class NotInitializedException implements Exception {}

// class MockAuthProvider implements AuthProvider {
//   AuthUser? _user;

//   var _isInitialized = false;
//   bool get isInitialized => _isInitialized;

//   @override
//   Future<AuthUser?> creatrUser({
//     required email,
//     required password,
//   }) async {
//     if (!isInitialized) throw NotInitializedException();
//     await Future.delayed(const Duration(seconds: 2));
//     return logIn(
//       email: email,
//       password: password,
//     );
//   }

//   @override
//   AuthUser? get currentUser => _user;

//   @override
//   Future<void> initialize() async {
//     await Future.delayed(const Duration(seconds: 2));
//     _isInitialized = true;
//   }

//   @override
//   Future<AuthUser?> logIn({required email, required password}) {
//     if (!isInitialized) throw NotInitializedException();
//     if (email == 'foo@bar.com') throw UserNotFoundAuthException();
//     if (password == 'foobarbaz') throw WrongPasswordException();
//     const user = AuthUser(isEmailVerified: false);
//     _user = user;
//     return Future.value(user);
//   }

//   @override
//   Future<void> logout() async {
//     if (!isInitialized) throw NotInitializedException();
//     if (_user == null) throw UserNotFoundAuthException();
//     await Future.delayed(const Duration(seconds: 2));
//     _user = null;
//   }

//   @override
//   Future<void> sendEmailVerification() async {
//     if (!isInitialized) throw NotInitializedException();
//     final user = _user;
//     if (user == null) throw UserNotFoundAuthException();
//     const newUser = AuthUser(isEmailVerified: true);
//     _user = newUser;
//   }
// }
