import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:teacher_helper/controllers/authentication.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController._();
  bool isDark = false;
  bool isLeftHanded = true;

  User? _user;

  User? get user {
    return _user;
  }

  User? getUser(BuildContext context) {
    if (_user == null) {}

    return user;
  }

  set user(user) {
    _user = user;
  }

  String get email {
    if (_user != null) {
      return _user!.email ?? '';
    }
    return '';
  }

  bool get isLoggedIn {
    return _user != null;
  }

  changeHand() {
    isLeftHanded = !isLeftHanded;
    notifyListeners();
  }

  changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = !isDark;
    prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  Future<bool> _getInitialDark() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isDark') == true;
    } catch (e) {
      return false;
    }
  }

  AppController._() {
    _getInitialDark().then((value) {
      isDark = value;
      notifyListeners();
    });
  }

  brightness() {
    return isDark ? Brightness.dark : Brightness.light;
  }
}
