import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/procura/procurar_body.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class ProcurarPage extends StatefulWidget {
  const ProcurarPage({Key? key}) : super(key: key);

  @override
  _ProcurarPageState createState() => _ProcurarPageState();
}

class _ProcurarPageState extends State<ProcurarPage> {
  @override
  Widget build(BuildContext context) {
    return const PageMask(
      title: 'Procurar Planos',
      body: ProcurarBody(),
    );
  }
}
