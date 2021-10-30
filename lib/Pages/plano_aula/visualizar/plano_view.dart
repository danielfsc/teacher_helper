import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/data/nivel_escolar.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';
import 'package:teacher_helper/shared/widgets/display_utils.dart';

class PlanoView extends StatefulWidget {
  const PlanoView({Key? key, required this.plano, this.isPrivate = true})
      : super(key: key);
  final PlanoAula plano;
  final bool isPrivate;

  @override
  State<PlanoView> createState() => _PlanoViewState();
}

class _PlanoViewState extends State<PlanoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plano: ${widget.plano.titulo}'),
        actions: [_menu(context, widget.plano)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              viewBox(context,
                  title: 'Disciplina: ', text: widget.plano.disciplina!),
              viewBox(context,
                  title: 'Nível: ',
                  text: nivelEnsino.values[widget.plano.nivel].extenso),
              borderListBox(
                context,
                title: 'Preparação:',
                lista: [Text(widget.plano.preparacao!)],
              ),
              borderListBox(
                context,
                title: 'Recursos:',
                lista: symbolList(widget.plano.recursos, previousText: '- '),
              ),
              borderListBox(
                context,
                title: 'Conteúdos:',
                lista: numeratedList(widget.plano.conteudos),
              ),
              borderListBox(
                context,
                title: 'Objetivos:',
                lista: numeratedList(widget.plano.objetivos),
              ),
              borderListBox(
                context,
                title: 'Atividades:',
                lista: atividadeCardList(widget.plano.atividades),
              ),
              borderListBox(
                context,
                title: 'Bibliografias:',
                lista: numeratedList(widget.plano.bibliografias),
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

  Widget _menu(BuildContext context, PlanoAula plano) {
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
            plano.duplicate(context);
            break;
          case 'Deletar':
            plano.destroy(context);
            break;
          case 'Gerar Word':
            plano.convertToDocx();
            break;
          case 'Executar Plano':
            plano.execute(context);
            break;
          case 'Agendar':
            plano.schedule(context);
            break;
        }
      },
    );
  }
}
