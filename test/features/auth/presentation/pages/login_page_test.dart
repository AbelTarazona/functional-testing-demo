import 'package:demo_testing/src/features/auth/domain/models/user.dart';
import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:demo_testing/src/features/auth/presentation/pages/login_page.dart';
import 'package:demo_testing/src/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('LoginPage', () {
    testWidgets('renders LoginForm', (tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(),
            ),
          ],
          child: MaterialApp(
            home: const LoginPage(),
          ),
        ),
      );

      expect(find.byType(LoginForm), findsOneWidget);
    });
  });

  group('LoginForm', () {
    testWidgets('shows validation errors for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(),
            ),
          ],
          child: MaterialApp(
            home: const LoginPage(),
          ),
        ),
      );

      await tester.enterText(
          find.byKey(const Key('loginForm_emailInput_textField')),
          'invalid-email');
      await tester.pump();

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid password',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(),
            ),
          ],
          child: MaterialApp(
            home: const LoginPage(),
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('loginForm_passwordInput_textField')),
        '123',
      );
      await tester.pump();

      expect(find.text('Invalid password'), findsOneWidget);
    });

    testWidgets('enables submit button when form is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(),
            ),
          ],
          child: MaterialApp(
            home: const LoginPage(),
          ),
        ),
      );

      final button = find.byKey(const Key('loginForm_submit_button'));
      expect(tester.widget<ElevatedButton>(button).enabled, false);

      await tester.enterText(
        find.byKey(const Key('loginForm_emailInput_textField')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginForm_passwordInput_textField')),
        'password123',
      );
      await tester.pump();

      expect(tester.widget<ElevatedButton>(button).enabled, true);
    });

    testWidgets('navigates to home on successful login',
        (WidgetTester tester) async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenAnswer(
          (_) async => User(id: '1', email: 'test@example.com', name: 'Test'));

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(),
            ),
          ],
          child: MaterialApp(
            routes: {
              '/home': (context) => const Scaffold(body: Text('Home Page')),
            },
            home: const LoginPage(),
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('loginForm_emailInput_textField')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginForm_passwordInput_textField')),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('loginForm_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('shows error message on login failure',
        (WidgetTester tester) async {
      when(
        () => mockAuthRepository.login(any(), any()),
      ).thenThrow(Exception('Authentication failed'));

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepositoryImpl(),
            ),
          ],
          child: MaterialApp(
            home: const LoginPage(),
          ),
        ),
      );

      await tester.enterText(
        find.byKey(const Key('loginForm_emailInput_textField')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginForm_passwordInput_textField')),
        'password123',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('loginForm_submit_button')));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Exception: Authentication failed'), findsOneWidget);
    });
  });
}
