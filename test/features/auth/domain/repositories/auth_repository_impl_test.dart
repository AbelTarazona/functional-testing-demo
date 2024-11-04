import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthRepositoryImpl authRepository;

  setUp(() {
    authRepository = AuthRepositoryImpl();
  });

  group('AuthRepositoryImpl', () {
    test('login success with correct credentials', () async {
      final user = await authRepository.login(
        'test@example.com',
        'password123',
      );

      expect(user.email, equals('test@example.com'));
      expect(user.id, equals('1'));
      expect(user.name, equals('Test User'));
    });

    test('login throws exception with incorrect credentials', () async {
      expect(
            () => authRepository.login('wrong@email.com', 'wrongpass'),
        throwsA(isA<Exception>()),
      );
    });

    test('logout completes successfully', () async {
      expect(authRepository.logout(), completes);
    });
  });
}