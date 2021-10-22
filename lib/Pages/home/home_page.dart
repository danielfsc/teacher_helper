import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/home/home_body.dart';
import 'package:teacher_helper/shared/data/routes.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final List<OpcaoMenu> _opcoes = opcoes;

  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Inicio',
      body: HomeBody(opcoes: _opcoes),
    );
  }
}
