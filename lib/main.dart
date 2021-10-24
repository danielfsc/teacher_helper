import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'initial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const InitialWidget());
}
