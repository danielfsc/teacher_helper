import 'package:flutter/material.dart';

List<OpcoesModelo> opcoes = [
  OpcoesModelo(Icons.school, 'Turmas', '/turmas', true, Colors.blueAccent),
  OpcoesModelo(Icons.event, 'Calendário', '/calendario', true, Colors.red),
  OpcoesModelo(
      Icons.menu_book, 'Planos de Aula', '/planos', true, Colors.orange),
  OpcoesModelo(Icons.search, 'Procurar', '/procurar', false, Colors.green),
  OpcoesModelo(
      Icons.category, 'Atividades', '/atividades', false, Colors.indigo),
  OpcoesModelo(
      Icons.settings, 'Configuraçoes', '/configuracoes', true, Colors.brown),
];

List teste = [];

class OpcoesModelo {
  final IconData icon;
  final String title;
  final String route;
  final bool active;
  final Color color;

  OpcoesModelo(this.icon, this.title, this.route, this.active, this.color);
}
