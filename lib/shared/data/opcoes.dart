import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';

List<OpcaoMenu> opcoes = [
  // OpcaoMenu(Icons.fireplace, 'Teste FireStore', '/fire', true, Colors.green),
  OpcaoMenu(Icons.school, 'Turmas', '/turmas', true, Colors.blueAccent),
  OpcaoMenu(Icons.event, 'Calendário', '/calendario', true, Colors.red),
  OpcaoMenu(Icons.menu_book, 'Planos de Aula', '/planos', false, Colors.orange),
  OpcaoMenu(Icons.search, 'Procurar', '/procurar', false, Colors.green),
  OpcaoMenu(Icons.category, 'Atividades', '/atividades', false, Colors.indigo),
  OpcaoMenu(
      Icons.settings, 'Configuraçoes', '/configuracoes', true, Colors.brown),
];

List teste = [];
