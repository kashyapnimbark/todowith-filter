import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kashyap/Singleton/singleton.dart';
import 'package:kashyap/constants/app_constants.dart';
import 'package:kashyap/custom_widgets/progress_button.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  TextEditingController emailCtrl =
      TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  AuthBloc()
      : super(
            AuthInitial(signInButton: ButtonState.idle, autoValidate: false)) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoginEmitEvent>((event, emit) {
      emit(AuthSuccessState(
          isLoading: false,
          autoValidate: state.autoValidate,
          isPasswordVisible: state.isPasswordVisible,
          signInButton: state.signInButton));
    });
    on<AuthObscureText>((event, emit) {
      emit(AuthSuccessState(
          isLoading: false,
          autoValidate: state.autoValidate,
          isPasswordVisible: event.isPasswordVisible,
          signInButton: state.signInButton));
    });
    on<LoginButtonEvent>((event, emit) async {
      emit(AuthLoadingState(
          signInButton: ButtonState.loading,
          isLoading: true,
          autoValidate: state.autoValidate,
          isPasswordVisible: state.isPasswordVisible));
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailCtrl.text,
          password: passCtrl.text,
        )
            .then(
          (value) {
            Singleton.instance.setLoginData(jsonEncode(value.user?.uid));
            showToast("Login Successfully");

            emit(AuthLoadedState(
              isLoading: false,
              autoValidate: state.autoValidate,
              signInButton: ButtonState.success,
              isPasswordVisible: state
                  .isPasswordVisible, /* teacherParentData: data.data?.loginTeacherParent*/
            ));
            add(ButtonIdleEvent());
          },
        ).onError(
          (error, stackTrace) {
            showToast("something Went Wrong");
            emit(AuthErrorState(
                signInButton: ButtonState.fail,
                isLoading: false,
                autoValidate: state.autoValidate,
                isPasswordVisible: state.isPasswordVisible));
            add(ButtonIdleEvent());
          },
        );
        // Navigate to the next screen (e.g., home screen)
      } on FirebaseAuthException catch (e) {

        showToast("something Went Wrong");
        emit(AuthErrorState(
            signInButton: ButtonState.fail,
            isLoading: false,
            autoValidate: state.autoValidate,
            // signInButton: ButtonState.fail,
            isPasswordVisible: state.isPasswordVisible));
        add(ButtonIdleEvent());
      }
    });
    on<RegisterButtonEvent>((event, emit) async {
      emit(AuthLoadingState(
          signInButton: ButtonState.loading,
          isLoading: true,
          autoValidate: state.autoValidate,
          isPasswordVisible: state.isPasswordVisible));
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailCtrl.text,
          password: passCtrl.text,
        )
            .then(
          (value) {
            Singleton.instance.setLoginData(jsonEncode(value.user?.uid));
            showToast("Register Successfully");
            emit(AuthRegisterState(
              isLoading: false,
              autoValidate: state.autoValidate,
              signInButton: ButtonState.success,
              isPasswordVisible: state
                  .isPasswordVisible, /* teacherParentData: data.data?.loginTeacherParent*/
            ));
            add(ButtonIdleEvent());
          },
        ).onError(
          (error, stackTrace) {
            showToast("something Went Wrong");
            emit(AuthErrorState(
                signInButton: ButtonState.fail,
                isLoading: false,
                autoValidate: state.autoValidate,
                isPasswordVisible: state.isPasswordVisible));
            add(ButtonIdleEvent());
          },
        );
        // Navigate to the next screen (e.g., home screen)
      } on FirebaseAuthException catch (e) {

        showToast("something Went Wrong");
        emit(AuthErrorState(
            signInButton: ButtonState.fail,
            isLoading: false,
            autoValidate: state.autoValidate,
            // signInButton: ButtonState.fail,
            isPasswordVisible: state.isPasswordVisible));
        add(ButtonIdleEvent());
      }
    });
    on<ButtonIdleEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3))
          .then((value) => emit(AuthSuccessState(
                isLoading: false,
                autoValidate: state.autoValidate,
                signInButton: ButtonState.idle,
                isPasswordVisible: state.isPasswordVisible,
              )));
    });
    on<clearState>((event, emit) async {
      emailCtrl.clear();
      passCtrl.clear();
      emit(AuthInitial(
        autoValidate: false,
        signInButton: ButtonState.idle,
      ));
    });
  }
}
