import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kashyap/Singleton/singleton.dart';
import 'package:kashyap/routes/routes.dart';
import 'package:kashyap/utils/navigator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Singleton.instance.getUserData();
  await Singleton.instance.getTodoList();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigatorService.navigatorKey,
        routes: AppRoutes.routes,
        initialRoute: _getRoute()

        );
  }

  String _getRoute() {
    var route = "";

    if (Singleton.instance.userID != null && Singleton.instance.userID != "") {
      route = AppRoutes.homeScreen;
    } else {
      route = AppRoutes.loginScreen;
    }
    return route;
  }
}
