import 'package:bloc/bloc.dart';
import 'package:demo_testing/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = event.email;
    final isEmailValid = _isEmailValid(email);

    emit(state.copyWith(
      email: email,
      isEmailValid: isEmailValid,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = event.password;
    final isPasswordValid = _isPasswordValid(password);

    emit(state.copyWith(
      password: password,
      isPasswordValid: isPasswordValid,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      await _authRepository.login(
        state.email,
        state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } catch (error) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }
}
