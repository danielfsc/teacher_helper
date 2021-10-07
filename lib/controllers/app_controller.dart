import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDark = false;
  changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
