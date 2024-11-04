import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:demo_testing/src/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/features/auth/domain/repositories/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(),
        ),
      ],
      child: MaterialApp(
        title: 'Login Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const Scaffold(
                body: Center(
                  child: Text('Home Page'),
                ),
              ),
        },
      ),
    );
  }
}
