import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/data/opcoes.dart';
import 'package:teacher_helper/controllers/authentication.dart';

import 'data/custom_colors.dart';
import 'modelos/opcao_menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final User _user = AppController.instance.user;

  bool _estaSaindo = false;

  @override
  void initState() {
    super.initState();
  }

  final List<OpcaoMenu> _opcoes =
      [OpcaoMenu(Icons.home, 'Início', '/home', true, Colors.black)] + opcoes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.topLeft,
          colors: [
            Colors.blueGrey,
            Colors.blueAccent,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _cabecalhoWidget(),
              const Divider(),
              _menuOpcoes(),
              _botaoSair(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecalhoWidget() {
    if (_user.photoURL != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Material(
                color: CustomColors.firebaseGrey.withOpacity(0.3),
                child: Image.network(
                  _user.photoURL!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _user.displayName!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      );
    }
    return ClipOval(
      child: Material(
        color: CustomColors.firebaseGrey.withOpacity(0.3),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(
            Icons.person,
            size: 60,
            color: CustomColors.firebaseGrey,
          ),
        ),
      ),
    );
  }

  Widget _menuOpcoes() {
    return Expanded(
      child: ListView(
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

  Widget _botaoSair() {
    if (_estaSaindo) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      title: Text(
        'Sair',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      onTap: () async {
        setState(() {
          _estaSaindo = true;
        });
        await Authentication.signOut(context: context);
        setState(() {
          _estaSaindo = false;
        });
      },
    );
  }
}
