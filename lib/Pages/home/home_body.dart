import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/data/opcoes.dart';

import 'home_card.dart';

class HomeBody extends StatelessWidget {
  final List<OpcoesModelo> opcoes;
  const HomeBody({Key? key, required this.opcoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      physics: const ScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: opcoes.map((value) {
        return HomeCardWidget(value);
      }).toList(),
    );
  }
}
