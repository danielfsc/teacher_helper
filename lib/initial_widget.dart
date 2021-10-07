import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';

import 'Pages/configuracao/configuracao.dart';
import 'Pages/home.dart';

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
                brightness: AppController.instance.isDark
                    ? Brightness.dark
                    : Brightness.light,
              ),
              initialRoute: '/',
              routes: {
                '/': (context) => const HomePage(),
                '/configuracoes': (context) => const ConfiguracaoPage(),
              });
        });
  }
}
