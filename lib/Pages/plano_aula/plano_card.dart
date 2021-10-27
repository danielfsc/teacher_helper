import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/plano_aula/executar/plano_executar.dart';
import 'package:teacher_helper/Pages/plano_aula/visualizar/plano_view.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';
import 'package:teacher_helper/shared/widgets/display_utils.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

import 'editor/plano_editor.dart';

class PlanoCard extends StatefulWidget {
  const PlanoCard({Key? key, required this.plano, this.isPrivate = true})
      : super(key: key);
  final bool isPrivate;

  final dynamic plano;

  @override
  State<PlanoCard> createState() => _PlanoCardState();
}

class _PlanoCardState extends State<PlanoCard> {
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        dynamic state = _menuKey.currentState;
        state.showButtonMenu();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _header(context, widget.plano),
              _info(context, widget.plano),
            ],
          ),
        ),
      ),
    );
  }

  final _bold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  Widget _header(context, plano) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        boldText(plano['titulo']),
        _menu(context, plano),
      ],
    );
  }

  Widget _menu(BuildContext context, data) {
    var menuItens = [
      IconMenu('Visualizar', Icons.visibility),
      IconMenu('Editar', Icons.edit, isPrivate: widget.isPrivate),
      IconMenu('Duplicar', Icons.copy),
      IconMenu('Deletar', Icons.delete, isPrivate: widget.isPrivate),
      IconMenu('Agendar', Icons.event, isPrivate: widget.isPrivate),
      IconMenu(
        'Executar Plano',
        Icons.play_arrow,
      ),
    ];
    return PopupMenuButton(
      key: _menuKey,
      child: const Icon(
        Icons.more_vert_outlined,
        size: 30,
      ),
      itemBuilder: (context) => menuItens.where((e) => e.isPrivate).map((e) {
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlanoEditor(plano: transformaDataEmPlano(data, data.id)),
                ));

            break;
          case 'Visualizar':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PlanoView(plano: data, isPrivate: widget.isPrivate)),
            );
            break;
          case 'Duplicar':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PlanoEditor(plano: transformaDataEmPlano(data, null))),
            );
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
                  _deletePlano(data.id);
                });
              }
            });
            break;
          case 'Executar Plano':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlanoExecutar(
                      plano: transformaDataEmPlano(data, data.id))),
            );
            break;
        }
      },
    );
  }

  Widget _info(context, plano) {
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

  _deletePlano(id) {
    CollectionReference planos =
        FirebaseFirestore.instance.collection('planosaula');
    planos.doc(id).delete();
  }
}
