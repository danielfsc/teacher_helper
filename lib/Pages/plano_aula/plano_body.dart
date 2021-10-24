import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/plano_aula/editor/plano_editor.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

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
          .where('userMail', isEqualTo: AppController.instance.user.email)
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

  Widget _listaPlanos(data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var plano = data[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _header(context, plano, index),
                  _info(context, plano, index),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final _bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  Widget _header(context, plano, index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          plano['titulo'],
          style: _bold,
        ),
        _menu(context, plano, index),
      ],
    );
  }

  Widget _info(context, plano, index) {
    return Column(
      children: [
        const Divider(),
        textTitleValue(
            'Duração: ', '${calculaDuracaoTotal(plano['atividades'])} min'),
        const SizedBox(height: 10),
        textTitleValue('Disciplina: ', plano['disciplina']),
      ],
    );
  }

  Widget textTitleValue(title, value) {
    return Row(
      children: [
        Text(
          title,
          style: _bold,
        ),
        Text(value),
      ],
    );
  }

  openPage(context, page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  var menuItens = [
    IconMenu('Visualizar', Icons.visibility),
    IconMenu('Editar', Icons.edit),
    IconMenu('Duplicar', Icons.copy),
    IconMenu('Deletar', Icons.delete),
    IconMenu('Agendar', Icons.event),
  ];

  Widget _menu(BuildContext context, data, int index) {
    return PopupMenuButton(
      child: const Icon(
        Icons.more_vert_outlined,
        size: 30,
      ),
      itemBuilder: (context) => menuItens.map((e) {
        return PopupMenuItem(
          value: e.value,
          child: ListTile(
            leading: Icon(e.icon),
            title: Text(e.value),
          ),
        );
      }).toList(),
      onSelected: (value) async {
        switch (value) {
          case 'Editar':
            openPage(context,
                PlanoEditor(plano: transformaDataEmPlano(data, data.id)));
            break;
          case 'Visualizar':
            // openPage(context, PlanoEditor(plano: data));
            break;
          case 'Duplicar':
            openPage(
                context, PlanoEditor(plano: transformaDataEmPlano(data, null)));
            break;
          case 'Deletar':
            showAlert(
              context,
              title: 'Deletar Plano de Aula',
              message: 'Essa ação não pode ser desfeita.\n Tem certeza?',
              cancelTitle: 'CANCELAR',
            ).then((value) {
              if (value) {
                setState(() {
                  planos.doc(data.id).delete();
                });
              }
            });
            break;
        }
      },
    );
  }

  transformaDataEmPlano(data, id) {
    return {
      'id': id,
      'userMail': data['userMail'],
      'titulo': data['titulo'],
      'publico': data['publico'],
      'disciplina': data['disciplina'],
      'nivel': data['nivel'],
      'preparacao': data['preparacao'],
      'conteudos': data['conteudos'],
      'objetivos': data['objetivos'],
      'recursos': data['recursos'],
      'atividades': data['atividades'],
      'bibliografias': data['bibliografias'],
    };
  }
}
