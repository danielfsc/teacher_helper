import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController._();
  // SharedPreferences? prefs;
  bool isDark = false;
  bool isLeftHanded = false;

  User? _user;

  User get user {
    return _user!;
  }

  set user(User? user) {
    _user = user;
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

  // _startSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print(prefs.getBool('isDark'));
  //   isDark = prefs.getBool('isDark') == true;
  // }

  brightness() {
    return isDark ? Brightness.dark : Brightness.light;
  }
}
