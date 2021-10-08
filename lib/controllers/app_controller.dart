import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDark = false;
  bool isLeftHanded = false;

  changeHand() {
    isLeftHanded = !isLeftHanded;
    notifyListeners();
  }

  changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  brightness() {
    return isDark ? Brightness.dark : Brightness.light;
  }
}
