import 'package:demo_testing/src/features/auth/domain/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
}