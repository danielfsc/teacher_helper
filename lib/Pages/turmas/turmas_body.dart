import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_card.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/turma.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

class TurmasBody extends StatefulWidget {
  const TurmasBody({Key? key}) : super(key: key);

  @override
  _TurmasBodyState createState() => _TurmasBodyState();
}

class _TurmasBodyState extends State<TurmasBody> {
  CollectionReference turmas = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.user.email!}/turmas');

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

  void _delete(String documentId) async {
    await turmas.doc(documentId).delete();
    log('Deletei o documento $documentId');
    setState(() {});
  }

  Widget _listaTurmas(List data) {
    List<Turma> turmas = data.map((e) => Turma.fromJson(e)).toList();
    return ListView.builder(
        itemCount: turmas.length,
        itemBuilder: (context, index) {
          return TurmasCard(
            turma: turmas[index],
            docId: data[index].id,
            onDelete: (String documentId) => _delete(documentId),
          );
        });
  }
}
