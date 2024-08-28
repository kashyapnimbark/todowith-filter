import 'dart:convert';
import 'dart:developer';

import 'package:kashyap/constants/preference_keys.dart';
import 'package:kashyap/module/home/data/model/todo_model.dart';
import 'package:kashyap/routes/routes.dart';
import 'package:kashyap/utils/navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  static Singleton get instance => _instance;
  dynamic userID;
  List<TodoModel> todoListObj = [];
  bool isFilterByDueDate = false;
  bool isFilterCompletedTask = false;
  bool isDefault = true;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future setLoginData(String? obj) async {
    final SharedPreferences pref = await _prefs;
    await pref.setString(PreferenceKeys.authLoginData, obj!);
    Singleton.instance.userID = obj;
  }

  Future setTodoListToLocal(String? obj) async {
    final SharedPreferences pref = await _prefs;
    await pref.setString(PreferenceKeys.todoListData, obj!);
  }

  Future getTodoList() async {
    final SharedPreferences prefs = await _prefs;
    var data = prefs.getString(PreferenceKeys.todoListData);
    if (data == null) {
    } else {
      List<dynamic> decodedList = jsonDecode(data);
      var todoList =
          decodedList.map((e) => TodoModel.fromMap(e, e['id'])).toList();
      Singleton.instance.todoListObj = todoList;
    }
  }

  Future getUserData() async {
    final SharedPreferences prefs = await _prefs;
    var data = prefs.getString(PreferenceKeys.authLoginData);
    if (data == null) {
    } else {
      Singleton.instance.userID = jsonDecode(data);
    }
  }

  logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.clear();
    Singleton.instance.userID = null;
    NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
  }
}
