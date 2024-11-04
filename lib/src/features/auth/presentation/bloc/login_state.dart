part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final String? errorMessage;
  final LoginStatus status;
  final bool isEmailValid;
  final bool isPasswordValid;

  const LoginState({
    this.email = '',
    this.password = '',
    this.errorMessage,
    this.status = LoginStatus.initial,
    this.isEmailValid = false,
    this.isPasswordValid = false,
  });

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    LoginStatus? status,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage,
      status: status ?? this.status,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    errorMessage,
    status,
    isEmailValid,
    isPasswordValid,
  ];
}