import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/home/home_card.dart';
import 'package:teacher_helper/shared/data/opcoes.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final List<OpcoesModelo> _opcoes = opcoes;

  @override
  Widget build(BuildContext context) {
    return PageMask(
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        physics: const ScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: _opcoes.map((value) {
          return HomeCardWidget(value);
        }).toList(),
      ),
      title: 'Início',
    );
  }
}
