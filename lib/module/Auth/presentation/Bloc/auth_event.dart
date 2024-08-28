part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginEmitEvent extends AuthEvent {
  LoginEmitEvent();
}

class AuthObscureText extends AuthEvent {
  bool isPasswordVisible = false;

  AuthObscureText(
    this.isPasswordVisible,
  );
}

class LoginButtonEvent extends AuthEvent {
  LoginButtonEvent();
}

class ButtonIdleEvent extends AuthEvent {
  ButtonIdleEvent();
}

class clearState extends AuthEvent {
  clearState();
}

class RegisterButtonEvent extends AuthEvent {
  RegisterButtonEvent();
}
