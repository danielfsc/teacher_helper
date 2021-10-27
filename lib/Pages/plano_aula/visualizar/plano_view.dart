import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:teacher_helper/Pages/plano_aula/editor/plano_editor.dart';
import 'package:teacher_helper/Pages/plano_aula/executar/plano_executar.dart';
import 'package:teacher_helper/shared/data/nivel_escolar.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';
import 'package:teacher_helper/shared/utils/gera_plano.dart';
import 'package:teacher_helper/shared/widgets/display_utils.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

class PlanoView extends StatefulWidget {
  const PlanoView({Key? key, required this.plano, this.isPrivate = true})
      : super(key: key);
  final dynamic plano;
  final bool isPrivate;

  @override
  State<PlanoView> createState() => _PlanoViewState();
}

class _PlanoViewState extends State<PlanoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plano: ${widget.plano['titulo']}'),
        actions: [_menu(context, widget.plano)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              viewBox(context,
                  title: 'Disciplina: ', text: widget.plano['disciplina']),
              viewBox(context,
                  title: 'Nível: ',
                  text: nivelEnsino.values[widget.plano['nivel']].extenso),
              borderListBox(
                context,
                title: 'Preparação:',
                lista: [Text(widget.plano['preparacao'])],
              ),
              borderListBox(
                context,
                title: 'Recursos:',
                lista: symbolList(widget.plano['recursos'], previousText: '- '),
              ),
              borderListBox(
                context,
                title: 'Conteúdos:',
                lista: numeratedList(widget.plano['conteudos']),
              ),
              borderListBox(
                context,
                title: 'Objetivos:',
                lista: numeratedList(widget.plano['objetivos']),
              ),
              borderListBox(
                context,
                title: 'Atividades:',
                lista: atividadeCardList(widget.plano['atividades']),
              ),
              borderListBox(
                context,
                title: 'Bibliografias:',
                lista: numeratedList(widget.plano['bibliografias']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> atividadeCardList(List lista) {
    return lista.map((e) {
      return atividadeCard(e);
    }).toList();
  }

  Widget atividadeCard(atividade) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleText('${atividade['titulo']}', ''),
            space(8),
            titleText('Duração: ', '${atividade['duracao']}min'),
            space(8),
            boldText('Descrição: '),
            space(8),
            Text(atividade['descricao']),
          ],
        ),
      ),
    );
  }

  _deletePlano(id) {
    CollectionReference planos =
        FirebaseFirestore.instance.collection('planosaula');
    planos.doc(id).delete();
    Navigator.of(context).pop();
  }

  Widget _menu(BuildContext context, data) {
    var menuItens = [
      IconMenu('Duplicar', Icons.copy),
      IconMenu('Agendar', Icons.event, isPrivate: widget.isPrivate),
      IconMenu('Gerar Word', Icons.document_scanner),
      IconMenu('Executar Plano', Icons.play_arrow),
    ];
    return PopupMenuButton(
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
                _deletePlano(data.id);
                Navigator.of(context).pop();
              }
            });
            break;
          case 'Gerar Word':
            geraPlano(widget.plano);
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
}
