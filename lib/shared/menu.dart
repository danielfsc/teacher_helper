import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/data/opcoes.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);

  final List<OpcoesModelo> _opcoes =
      [OpcoesModelo(Icons.home, 'Início', '/', true, Colors.black)] + opcoes;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: _opcoes.map((value) {
          return value.active
              ? ListTile(
                  leading: Icon(value.icon),
                  title: Text(value.title),
                  onTap: () {
                    Navigator.of(context).pushNamed(value.route);
                  },
                )
              : const SizedBox.shrink();
        }).toList(),
      ),
    );
  }
}
