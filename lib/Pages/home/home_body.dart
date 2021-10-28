import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/authentication.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';

import 'home_card.dart';

class HomeBody extends StatelessWidget {
  final List<OpcaoMenu> opcoes;
  const HomeBody({Key? key, required this.opcoes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      primary: false,
      padding: const EdgeInsets.all(20),
      physics: const ScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        ...opcoes.map((value) {
          return HomeCardWidget(value);
        }).toList(),
        logoutCard(context)
      ],
    );
  }

  Widget logoutCard(context) {
    return Card(
      child: AbsorbPointer(
        absorbing: false,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () async {
            await Authentication.signOut(context: context);
            Navigator.of(context).popAndPushNamed('/');
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.logout,
                    size: 42,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Sair',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
