import 'package:demo_testing/src/features/auth/domain/models/user.dart';
import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // Simulamos una llamada a API
    await Future.delayed(const Duration(seconds: 1));

    if (email != 'test@example.com' || password != 'password123') {
      throw Exception('Invalid credentials');
    }

    return User(
      id: '1',
      email: email,
      name: 'Test User',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}