import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_editor/turma_editor.dart';
import 'package:teacher_helper/Pages/turmas/turmas_body.dart';
import 'package:teacher_helper/controllers/authentication.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage({Key? key}) : super(key: key);

  @override
  State<TurmasPage> createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage> {
  @override
  void initState() {
    Authentication.routeGuard(context, endPoint: '/turmas');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Minhas Turmas',
      body: const TurmasBody(),
      floatingButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _openTurmaEditor(context);
          }),
    );
  }

  void _openTurmaEditor(contex) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TurmaEditor()),
    ).then((value) {
      setState(() {});
    });
  }
}
