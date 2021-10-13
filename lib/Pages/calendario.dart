import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/configuracao/darkmode.dart';
import 'package:teacher_helper/Pages/configuracao/lefthandmode.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class CalendarioPage extends StatelessWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Calendario',
      body: ListView(
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
                Navigator.of(context).pushNamed('/');
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
