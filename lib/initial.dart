import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/data/routes.dart';

class InitialWidget extends StatelessWidget {
  const InitialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            brightness: AppController.instance.brightness(),
          ),
          initialRoute: '/',
          routes: routes,
        );
      },
    );
  }
}
