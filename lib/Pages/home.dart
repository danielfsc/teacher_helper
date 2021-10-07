import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageMask(
      body: Column(
        children: const [Text('TExTo no centro')],
      ),
      title: 'Inicio',
    );
  }
}
