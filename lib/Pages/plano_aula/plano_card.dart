import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario/calendario_picker.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';
import 'package:teacher_helper/shared/widgets/display_utils.dart';

class PlanoCard extends StatefulWidget {
  const PlanoCard({Key? key, required this.plano, this.isPrivate = true})
      : super(key: key);
  final bool isPrivate;

  final PlanoAula plano;

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
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5 > 350
            ? 350
            : double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _header(context, widget.plano),
                _info(context, widget.plano),
                _conteudo(context, widget.plano)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _conteudo(BuildContext context, PlanoAula plano) {
    return ExpansionTile(
      title: Text('Conteúdos (${plano.conteudos.length})'),
      controlAffinity: ListTileControlAffinity.trailing,
      children: plano.conteudos
          .map((e) => ListTile(
                title: Text(e),
                leading: Icon(
                  Icons.done,
                  size: 18,
                ),
              ))
          .toList(),
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
        boldText(plano.titulo),
        _menu(context, plano),
      ],
    );
  }

  Widget _menu(BuildContext context, PlanoAula plano) {
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
            plano.edit(context);
            break;
          case 'Visualizar':
            plano.view(context, isPrivate: widget.isPrivate);
            break;
          case 'Duplicar':
            plano.duplicate(context);
            break;
          case 'Executar Plano':
            plano.execute(context);
            break;
          case 'Deletar':
            plano.destroy(context);
            break;
          case 'Agendar':
            CalendarTapDetails? evento = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarioPicker()),
            );
            if (evento != null) {
              await _registraPlanoATurma(evento.appointments![0]);
            }
            break;
        }
      },
    );
  }

  Future<void> _registraPlanoATurma(Appointment evento) async {
    String turmaId = (evento.resourceIds![0] as Map)['docId'];

    Turma turma = Turma.fromJson(
      await FirebaseFirestore.instance
          .collection('usuarios/${AppController.instance.user.email}/turmas')
          .doc(turmaId)
          .get(),
    );

    turma.eventosPlanos!.add({
      'planoId': widget.plano.docId,
      'planoTitulo': widget.plano.titulo,
      'startTime': evento.startTime,
      'endTime': evento.endTime,
    });

    await FirebaseFirestore.instance
        .collection('usuarios/${AppController.instance.user.email}/turmas')
        .doc(turmaId)
        .update(turma.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plano agendado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _info(context, plano) {
    return Column(
      children: [
        const Divider(),
        textTitleValue('Duração: ', '${plano.fullTime()} min'),
        const SizedBox(height: 10),
        textTitleValue('Disciplina: ', plano.disciplina),
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
}
