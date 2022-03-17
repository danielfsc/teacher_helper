import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/plano_aula/editor/plano_editor.dart';
import 'package:teacher_helper/Pages/plano_aula/plano_body.dart';
import 'package:teacher_helper/controllers/authentication.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class PlanoAulaPage extends StatefulWidget {
  const PlanoAulaPage({Key? key}) : super(key: key);

  @override
  _PlanoAulaPageState createState() => _PlanoAulaPageState();
}

class _PlanoAulaPageState extends State<PlanoAulaPage> {
  @override
  void initState() {
    Authentication.routeGuard(context, endPoint: '/planos');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageMask(
      body: const PlanoAulaBody(),
      title: 'Meus Planos de Aula',
      floatingButton: FloatingActionButton(
        onPressed: () {
          _openPlanoEditor(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _openPlanoEditor(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlanoEditor()),
    ).then((value) {
      setState(() {});
    });
  }
}
