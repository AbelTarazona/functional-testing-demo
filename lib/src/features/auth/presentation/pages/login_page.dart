import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:demo_testing/src/features/auth/presentation/bloc/login_bloc.dart';
import 'package:demo_testing/src/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepository: context.read<AuthRepository>(),
        ),
        child: const LoginForm(),
      ),
    );
  }
}
