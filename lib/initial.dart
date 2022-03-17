import 'package:flutter/material.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/data/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class InitialWidget extends StatelessWidget {
  const InitialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            SfGlobalLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('pt'),
            Locale('en'),
          ],
          locale: const Locale('pt'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: AppController.instance.brightness(),
          ),
          initialRoute: '/',
          routes: routes,
          title: 'Teacher\'s Helper',
        );
      },
    );
  }
}
