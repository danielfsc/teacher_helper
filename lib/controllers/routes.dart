import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/configuracao/configuracao.dart';
import 'package:teacher_helper/Pages/home.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => const HomePage(),
  '/configuracoes': (context) => const ConfiguracaoPage(),
};
