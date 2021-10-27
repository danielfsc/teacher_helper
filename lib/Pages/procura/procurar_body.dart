import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/plano_aula/plano_card.dart';
import 'package:teacher_helper/controllers/app_controller.dart';

class ProcurarBody extends StatefulWidget {
  const ProcurarBody({Key? key}) : super(key: key);

  @override
  _ProcurarBodyState createState() => _ProcurarBodyState();
}

class _ProcurarBodyState extends State<ProcurarBody> {
  CollectionReference publicos =
      FirebaseFirestore.instance.collection('planosaula');
  String? _disciplina;

  Stream<dynamic>? temDisciplina;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          selectDisciplinas(),
          listaPlanos(),
        ],
      ),
    ));
  }

  listaPlanos() {
    return Center(
      child: StreamBuilder(
          stream: temDisciplina,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (_disciplina == null) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Text(
                  'Escolha uma disciplina para começar',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Não achei nenhum plano para essa disciplina. Ou você é o único que criou planos para essa disciplina.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var plano = snapshot.data.docs[index];
                    return PlanoCard(
                      plano: plano,
                      isPrivate: false,
                    );
                  }),
            );
          }),
    );
  }

  _getPlanos() {
    temDisciplina = publicos
        .where('publico', isEqualTo: true)
        .where('userMail', isNotEqualTo: AppController.instance.user.email)
        .where('disciplina', isEqualTo: _disciplina)
        // .orderBy('titulo')
        .snapshots();
  }

  Widget selectDisciplinas() {
    return StreamBuilder(
        stream: publicos
            .where('publico', isEqualTo: true)
            .where('userMail', isNotEqualTo: AppController.instance.user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else if (snapshot.data.docs.length == 0) {
            return const Text(
                'Ainda não temos planos no nosso sistema. \nSeja o primeiro a contribuir com a comunidade.');
          }
          return _disciplinaMenu(snapshot.data.docs);
        });
  }

  Widget _disciplinaMenu(docs) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String?>(
          hint: const Text('Escola uma disciplina'),
          isExpanded: true,
          value: _disciplina,
          onChanged: (String? newValue) {
            setState(() {
              _disciplina = newValue ?? '';
              _getPlanos();
            });
          },
          items: _disciplinasOptions(docs),
        ),
      ),
    );
  }

  _disciplinasOptions(docs) {
    return docs
        .map((d) {
          return d['disciplina'].toString().toUpperCase();
        })
        .toSet()
        .toList()
        .map((doc) {
          return DropdownMenuItem<String>(
            value: doc,
            child: Text(doc),
          );
        })
        .cast<DropdownMenuItem<String>>()
        .toList();
  }
}
