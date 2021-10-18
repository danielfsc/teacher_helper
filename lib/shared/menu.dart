import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/data/opcoes.dart';

import 'modelos/opcao_menu.dart';

class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);

  final List<OpcaoMenu> _opcoes =
      [OpcaoMenu(Icons.home, 'Início', '/', true, Colors.black)] + opcoes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: _opcoes.map((value) {
          return value.active
              ? ListTile(
                  leading: Icon(
                    value.icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  title: Text(
                    value.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed(value.route);
                  },
                )
              : const SizedBox.shrink();
        }).toList(),
      ),
    );
  }
}
