import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/controllers/authentication.dart';
import 'package:teacher_helper/shared/data/routes.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

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
            Colors.indigo,
            Colors.blue,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
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
                color: Colors.grey,
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: _user.photoURL!,
                  placeholder: (context, url) => loading(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
        color: Colors.grey.withOpacity(0.3),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(
            Icons.person,
            size: 60,
            color: Colors.grey,
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
      return loading();
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
