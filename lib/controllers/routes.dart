import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/calendario/calendario_page.dart';
import 'package:teacher_helper/Pages/configuracao/configuracao_page.dart';
import 'package:teacher_helper/Pages/firestore/firestore_page.dart';
import 'package:teacher_helper/Pages/home/home_page.dart';
import 'package:teacher_helper/Pages/login/login_page.dart';
import 'package:teacher_helper/Pages/turmas/turmas_page.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => const LoginPage(),
  '/home': (context) => HomePage(),
  '/turmas': (context) => const TurmasPage(),
  '/calendario': (context) => const CalendarioPage(),
  '/configuracoes': (context) => const ConfiguracaoPage(),
  '/fire': (context) => const FirestorePage(),
};
