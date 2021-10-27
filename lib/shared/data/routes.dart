import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/calendario/calendario_page.dart';
import 'package:teacher_helper/Pages/configuracao/configuracao_page.dart';
import 'package:teacher_helper/Pages/firestore/firestore_page.dart';
import 'package:teacher_helper/Pages/home/home_page.dart';
import 'package:teacher_helper/Pages/login/login_page.dart';
import 'package:teacher_helper/Pages/plano_aula/plano_page.dart';
import 'package:teacher_helper/Pages/turmas/turmas_page.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';

var routes = <String, WidgetBuilder>{
  '/': (context) => const LoginPage(),
  '/home': (context) => HomePage(),
  '/turmas': (context) => const TurmasPage(),
  '/calendario': (context) => const CalendarioPage(),
  '/planos': (context) => const PlanoAulaPage(),
  '/configuracoes': (context) => const ConfiguracaoPage(),
  '/procurar': (context) => const ConfiguracaoPage(),
  '/fire': (context) => const FirestorePage(),
};

List<OpcaoMenu> opcoes = [
  OpcaoMenu(Icons.school, 'Turmas', '/turmas', true, Colors.blueAccent),
  OpcaoMenu(Icons.event, 'Calendário', '/calendario', true, Colors.red),
  OpcaoMenu(Icons.menu_book, 'Planos de Aula', '/planos', true, Colors.orange),
  OpcaoMenu(Icons.search, 'Procurar', '/procurar', true, Colors.green),
  OpcaoMenu(
      Icons.settings, 'Configuraçoes', '/configuracoes', true, Colors.indigo),
];

  // OpcaoMenu(Icons.category, 'Atividades', '/atividades', false, Colors.indigo),
  // OpcaoMenu(Icons.fireplace, 'Teste FireStore', '/fire', true, Colors.green),