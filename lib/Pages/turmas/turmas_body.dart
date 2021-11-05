import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

class TurmasBody extends StatefulWidget {
  const TurmasBody({Key? key}) : super(key: key);

  @override
  _TurmasBodyState createState() => _TurmasBodyState();
}

class _TurmasBodyState extends State<TurmasBody> {
  CollectionReference turmas = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.email}/turmas');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: turmas.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return loading();
              } else if (snapshot.data.docs.length == 0) {
                return semregistro('Nenhuma turma cadastrada.');
              }
              return _listaTurmas(snapshot.data.docs);
            },
          ),
        ),
      ],
    );
  }

  Widget _listaTurmas(List data) {
    List<Turma> turmas = data.map((e) => Turma.fromJson(e)).toList();
    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: turmas.map((t) => t.card(context)).toList(),
      ),
    );
    // itemCount: turmas.length,
    // itemBuilder: (context, index) {
    //   return turmas[index].card(context);
    // });
  }
}
