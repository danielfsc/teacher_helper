import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/calendario/calendario_page.dart';
import 'package:teacher_helper/Pages/configuracao/configuracao_page.dart';
import 'package:teacher_helper/Pages/home/home_page.dart';
import 'package:teacher_helper/Pages/login/login_page.dart';
import 'package:teacher_helper/Pages/turmas/turmas_page.dart';

var routes = <String, WidgetBuilder>{
  '/home': (context) => HomePage(),
  '/configuracoes': (context) => const ConfiguracaoPage(),
  '/calendario': (context) => const CalendarioPage(),
  '/turmas': (context) => const TurmasPage(),
  '/': (context) => const LoginPage(),
};
