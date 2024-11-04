import 'package:demo_testing/src/features/auth/domain/models/user.dart';
import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:demo_testing/src/features/auth/presentation/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginBloc loginBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginBloc = LoginBloc(
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    loginBloc.close();
  });

  test('initial state is correct', () {
    expect(loginBloc.state, const LoginState());
  });

  group('LoginEmailChanged', () {
    blocTest<LoginBloc, LoginState>(
      'emits valid email state when email is valid',
      build: () => loginBloc,
      act: (bloc) => bloc.add(LoginEmailChanged('test@example.com')),
      expect: () => [
        const LoginState(
          email: 'test@example.com',
          isEmailValid: true,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits invalid email state when email is invalid',
      build: () => loginBloc,
      act: (bloc) => bloc.add(LoginEmailChanged('invalid-email')),
      expect: () => [
        const LoginState(
          email: 'invalid-email',
          isEmailValid: false,
        ),
      ],
    );
  });

  group('LoginPasswordChanged', () {
    blocTest<LoginBloc, LoginState>(
      'emits valid password state when password length >= 6',
      build: () => loginBloc,
      act: (bloc) => bloc.add(LoginPasswordChanged('password123')),
      expect: () => [
        const LoginState(
          password: 'password123',
          isPasswordValid: true,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits invalid password state when password length < 6',
      build: () => loginBloc,
      act: (bloc) => bloc.add(LoginPasswordChanged('pass')),
      expect: () => [
        const LoginState(
          password: 'pass',
          isPasswordValid: false,
        ),
      ],
    );
  });

  group('LoginSubmitted', () {
    blocTest<LoginBloc, LoginState>(
      'does nothing when form is invalid',
      build: () => loginBloc,
      act: (bloc) => bloc.add(LoginSubmitted()),
      expect: () => [],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading, success] when login succeeds',
      setUp: () {
        when(
              () => mockAuthRepository.login(any(), any()),
        ).thenAnswer((_) async => User(id: '1', email: 'test@example.com', name: 'Test'));
      },
      build: () => loginBloc,
      seed: () => const LoginState(
        email: 'test@example.com',
        password: 'password123',
        isEmailValid: true,
        isPasswordValid: true,
      ),
      act: (bloc) => bloc.add(LoginSubmitted()),
      expect: () => [
        const LoginState(
          email: 'test@example.com',
          password: 'password123',
          isEmailValid: true,
          isPasswordValid: true,
          status: LoginStatus.loading,
        ),
        const LoginState(
          email: 'test@example.com',
          password: 'password123',
          isEmailValid: true,
          isPasswordValid: true,
          status: LoginStatus.success,
        ),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading, failure] when login fails',
      setUp: () {
        when(
              () => mockAuthRepository.login(any(), any()),
        ).thenThrow(Exception('Authentication failed'));
      },
      build: () => loginBloc,
      seed: () => const LoginState(
        email: 'test@example.com',
        password: 'password123',
        isEmailValid: true,
        isPasswordValid: true,
      ),
      act: (bloc) => bloc.add(LoginSubmitted()),
      expect: () => [
        const LoginState(
          email: 'test@example.com',
          password: 'password123',
          isEmailValid: true,
          isPasswordValid: true,
          status: LoginStatus.loading,
        ),
        const LoginState(
          email: 'test@example.com',
          password: 'password123',
          isEmailValid: true,
          isPasswordValid: true,
          status: LoginStatus.failure,
          errorMessage: 'Exception: Authentication failed',
        ),
      ],
    );
  });
}