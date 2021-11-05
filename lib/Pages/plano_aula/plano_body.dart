import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:teacher_helper/Pages/plano_aula/plano_card.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

class PlanoAulaBody extends StatefulWidget {
  const PlanoAulaBody({Key? key}) : super(key: key);

  @override
  _PlanoAulaBodyState createState() => _PlanoAulaBodyState();
}

class _PlanoAulaBodyState extends State<PlanoAulaBody> {
  CollectionReference planos =
      FirebaseFirestore.instance.collection('planosaula');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: planos
          .where('userMail', isEqualTo: AppController.instance.email)
          .orderBy('titulo')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return loading();
        } else if (snapshot.data.docs.length == 0) {
          return semregistro('Você não tem planos de aula registrados.');
        }
        return _listaPlanos(snapshot.data.docs);
      },
    );
  }

  Widget _listaPlanos(List data) {
    List<PlanoAula> planos = data.map((e) => PlanoAula.fromJson(e)).toList();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: planos.map((p) => p.card(context)).toList(),
        ),
      ),
    );
  }
}
