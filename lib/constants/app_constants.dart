import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

hideKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

showToast(String message, {int? time}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: time ?? 1,
      fontSize: 16.0);
}
