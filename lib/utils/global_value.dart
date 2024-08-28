import 'package:flutter/cupertino.dart';

class GlobalValue {
  static RegExp regexForPass =
      RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[\W_]).{8,}$');
  static RegExp regexForEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
}
