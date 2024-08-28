part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  bool isLoading;
  bool? isPasswordVisible;
  final ButtonState signInButton;
  bool? autoValidate;

  AuthState(
      {this.isLoading = false,
      this.isPasswordVisible = false,
      this.signInButton = ButtonState.idle,
      this.autoValidate = false});
}

class AuthInitial extends AuthState {
  AuthInitial({ButtonState? signInButton, bool? autoValidate})
      : super(signInButton: signInButton!, autoValidate: autoValidate);
}

class AuthLoadingState extends AuthState {
  AuthLoadingState(
      {bool? isLoading,
      super.isPasswordVisible = null,
      bool? autoValidate,
      ButtonState? signInButton})
      : super(
            isLoading: isLoading!,
            signInButton: signInButton!,
            autoValidate: autoValidate);
}

class AuthSuccessState extends AuthState {
  AuthSuccessState(
      {bool? isLoading,
      super.isPasswordVisible = null,
      bool? autoValidate,
      ButtonState? signInButton})
      : super(
            isLoading: isLoading!,
            signInButton: signInButton!,
            autoValidate: autoValidate);
}

class AuthLoadedState extends AuthState {
  // LoginAuthParent? AuthParentData;

  AuthLoadedState({
    bool? isLoading,
    super.isPasswordVisible = null,
    bool? autoValidate,
    ButtonState? signInButton,
    /*this.AuthParentData*/
  }) : super(
            isLoading: isLoading!,
            signInButton: signInButton!,
            autoValidate: autoValidate);
}

class AuthRegisterState extends AuthState {
  // LoginAuthParent? AuthParentData;

  AuthRegisterState({
    bool? isLoading,
    super.isPasswordVisible = null,
    bool? autoValidate,
    ButtonState? signInButton,
    /*this.AuthParentData*/
  }) : super(
            isLoading: isLoading!,
            signInButton: signInButton!,
            autoValidate: autoValidate);
}

class AuthErrorState extends AuthState {
  AuthErrorState(
      {bool? isLoading,
      bool? autoValidate,
      super.isPasswordVisible = null,
      ButtonState? signInButton})
      : super(
            isLoading: isLoading!,
            autoValidate: autoValidate,
            signInButton: signInButton!);
}
