import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/configuracao/darkmode.dart';
import 'package:teacher_helper/Pages/configuracao/lefthandmode.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class ConfiguracaoPage extends StatelessWidget {
  const ConfiguracaoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Configurações',
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const DarkModeWidget(),
          const LeftHandedMode(),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 150,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed('/');
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Aplicar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
