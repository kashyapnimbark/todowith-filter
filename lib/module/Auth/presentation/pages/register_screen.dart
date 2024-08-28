import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kashyap/constants/app_color.dart';
import 'package:kashyap/constants/app_constants.dart';
import 'package:kashyap/constants/app_string.dart';
import 'package:kashyap/custom_widgets/app_textfield_with_label.dart';
import 'package:kashyap/custom_widgets/icon_custom_button.dart';
import 'package:kashyap/custom_widgets/progress_button.dart';
import 'package:kashyap/module/Auth/presentation/Bloc/auth_bloc.dart';
import 'package:kashyap/routes/routes.dart';
import 'package:kashyap/utils/global_value.dart';
import 'package:kashyap/utils/navigator_service.dart';
import 'package:kashyap/utils/size_utils.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  static Widget builder(BuildContext context) {

    return BlocProvider(
      create: (context) =>AuthBloc() ,
      child: RegisterScreen(),
    );
  }

  final formKey = GlobalKey<FormState>();
  bool? isEmailError = false;
  bool? isPasswordError = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return PopScope(
          onPopInvoked: (didPop) {
            if(didPop){
              context.read<AuthBloc>().add(clearState());

            }
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: getPadding(all: 20),
                child: Column(
                  children: [
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildForm() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthRegisterState) {
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
        }
      },
      builder: (context, state) {
        var bloc = context.read<AuthBloc>();
        return Form(
          autovalidateMode: state.autoValidate!
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          key: formKey,
          child: Padding(
            padding: getPadding(left: 8, right: 8, top: 70, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    AppStrings.register,
                    style: TextStyle(
                      color: AppColors.blackFont,
                      fontSize: getSize(27),
                    ),
                  ),
                ),

                SizedBox(
                  height: getVerticalSize(10),
                ),
                AppTextFieldWithLabel(
                  validator: (value) {
                    if (GlobalValue.regexForEmail.hasMatch(value!.trim())) {
                      ///return valid
                    } else if (value.trim().isEmpty) {
                      return AppStrings.emailRequired;

                      //return;
                    } else {
                      return AppStrings.notValidEmail;
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  controller: bloc.emailCtrl,
                  textInputAction: TextInputAction.next,
                  onChanged: (p0) {},
                  labelText: "Email",
                  hintText: "Enter email",
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                AppTextFieldWithLabel(
                  validator: (value) {
                    if (GlobalValue.regexForPass.hasMatch(value!)) {
                    } else if (value.trim().isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                  controller: bloc.passCtrl,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onChanged: (p0) {},
                  suffixIcon: InkWell(
                    onTap: () {
                      context.read<AuthBloc>().add(AuthObscureText(
                            !state.isPasswordVisible!,
                          ));
                    },
                    child: Icon(
                      state.isPasswordVisible!
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                  ),
                  obscureText: state.isPasswordVisible! ? false : true,
                  labelText: AppStrings.password,
                  hintText: AppStrings.enterPassword,
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                signInCustomButton(
                  state,
                  context,
                  onPressed: () {
                    hideKeyboard();
                    state.autoValidate = true;
                    context.read<AuthBloc>().add(LoginEmitEvent());
                    _validateForm(
                        context, bloc.emailCtrl.text, bloc.passCtrl.text);
                  },
                ),

                SizedBox(
                  height: getVerticalSize(10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have a account? "),
                    InkWell(
                      onTap: () {
                        context.read<AuthBloc>().add(clearState());

                        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: AppColors.brickButtonBG),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget signInCustomButton(AuthState state, BuildContext context,
      {Function? onPressed}) {
    return ProgressButton.icon(
      maxWidth: size.width,
      minWidth: getHorizontalSize(55.0),
      radius: state.signInButton == ButtonState.idle ? 5.0 : 100.0,
      textStyle: TextStyle(
          fontSize: getFontSize(20),
          letterSpacing: 0.2,
          color: AppColors.white),
      iconCustomButton: {
        ButtonState.idle: IconCustomButton(
            text: 'Sign UP',
            icon: const Icon(
              Icons.send,
              color: Colors.transparent,
              size: 0,
            ),
            color: AppColors.sectionText),
        ButtonState.loading:
            IconCustomButton(text: "Loading", color: AppColors.sectionText),
        ButtonState.fail: const IconCustomButton(
            text: "Failed",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red),
        ButtonState.success: const IconCustomButton(
            text: 'Login Successful',
            icon: Icon(
              Icons.send,
              color: Colors.transparent,
              size: 0,
            ),
            color: Colors.green),
      },
      onPressed: onPressed,
      state: state.signInButton,
    );
  }

  _validateForm(BuildContext context, String email, String pass) async {
    if (formKey.currentState!.validate()) {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      context.read<AuthBloc>().add(RegisterButtonEvent());
    }
  }
}
