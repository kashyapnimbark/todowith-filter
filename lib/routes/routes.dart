import 'package:flutter/cupertino.dart';
import 'package:kashyap/module/Auth/presentation/pages/login_screen.dart';
import 'package:kashyap/module/Auth/presentation/pages/register_screen.dart';
import 'package:kashyap/module/home/presentation/pages/add_todo.dart';
import 'package:kashyap/module/home/presentation/pages/home_screen.dart';

class AppRoutes {
  ///Auth
  static const String loginScreen = '/loginScreen';
  static const String homeScreen = '/homeScreen';
  static const String registerScreen = '/registerScreen';
  static const String todoForm = '/TodoForm';

  static Map<String, WidgetBuilder> get routes => {
        ///PARENT
        loginScreen: LoginScreen.builder,
        homeScreen: HomeScreen.builder,
        registerScreen: RegisterScreen.builder,
        todoForm: TodoForm.builder,
        //editChildProfile: EditChildProfile.builder,
      };
}
