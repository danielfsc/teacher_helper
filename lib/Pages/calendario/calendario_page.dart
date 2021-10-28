import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario/eventos.dart';
import 'package:teacher_helper/Pages/plano_aula/executar/plano_executar.dart';
import 'package:teacher_helper/Pages/plano_aula/pegar/plano_picker.dart';
import 'package:teacher_helper/Pages/plano_aula/visualizar/plano_view.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';
import 'package:teacher_helper/shared/page_mask.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  CollectionReference turmas = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.user.email!}/turmas');
  final CalendarController _controller = CalendarController();
  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Calendário',
      body: StreamBuilder(
        stream: turmas.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          return _calendario(context, snapshot.data.docs);
        },
      ),
      // floatingButton: _floatingButton(),
    );
  }

  Widget _calendario(context, List<dynamic> turmas) {
    return SfCalendar(
      view: CalendarView.week,
      showNavigationArrow: false,
      firstDayOfWeek: 7,
      allowedViews: const [
        CalendarView.month,
        CalendarView.week,
        CalendarView.day,
        CalendarView.schedule,
      ],
      controller: _controller,
      monthViewSettings: const MonthViewSettings(showAgenda: true),
      scheduleViewSettings: const ScheduleViewSettings(
        appointmentItemHeight: 100,
      ),
      initialDisplayDate: DateTime.now(),
      initialSelectedDate: DateTime.now(),
      todayHighlightColor: Theme.of(context).primaryColor,
      onLongPress: (CalendarLongPressDetails details) {
        _decideOqueFazer(context, details);
      },
      dataSource: MeetingDataSource(eventosTurmas(turmas)),
    );
  }

  _decideOqueFazer(context, CalendarLongPressDetails details) async {
    if (details.appointments != null && details.appointments!.isNotEmpty) {
      Appointment event = details.appointments![0];
      dynamic resource = event.resourceIds![0];
      switch (resource['type']) {
        case 'turma':
          _registraPlanoATurma(event);
          break;
        case 'plano':
          _decidePlano(event);
          break;
      }
    }
  }

  Future<void> _decidePlano(event) async {
    var itens = [
      IconMenu('Visualizar', Icons.visibility),
      IconMenu('Executar Plano', Icons.play_arrow),
      IconMenu('Remover Evento', Icons.delete),
    ];
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 230,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ...itens.map((e) {
                return TextButton.icon(
                  onPressed: () {
                    _escolhiAcaoPlano(
                        context: context, evento: event, acao: e.value);
                  },
                  icon: Icon(e.icon, size: 26),
                  label: Text(
                    e.value,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> _getPlanoFromEvent(Appointment evento) async {
    String planoId = (evento.resourceIds![0] as Map)['docId'];

    return (await FirebaseFirestore.instance
        .collection('planosaula')
        .doc(planoId)
        .get());
  }

  Future<void> _escolhiAcaoPlano({
    required BuildContext context,
    required Appointment evento,
    required String acao,
  }) async {
    switch (acao) {
      case 'Visualizar':
        var plano = await _getPlanoFromEvent(evento);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanoView(
                plano: plano,
              ),
            ));
        break;
      case 'Executar Plano':
        var plano = await _getPlanoFromEvent(evento);
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanoExecutar(
                plano: plano,
              ),
            ));
        break;
      case 'Remover Evento':
        await _removePlanoEvento(evento);
        break;
      default:
    }
    Navigator.pop(context);
  }

  _removePlanoEvento(Appointment evento) async {
    String planoId = (evento.resourceIds![0] as Map)['docId'];
    DateTime startTime = (evento.startTime);
    String turmaId = (evento.resourceIds![1] as Map)['docId'];

    Turma turma = Turma.fromJson(await turmas.doc(turmaId).get());
    int index = turma.eventosPlanos!.indexWhere((element) =>
        (element['planoId'] == planoId &&
            element['startTime'].toDate() == startTime));
    turma.eventosPlanos!.removeAt(index);
    turmas.doc(turmaId).update(turma.toJson());
  }

  Future<void> _registraPlanoATurma(Appointment event) async {
    if (await showAlert(
      context,
      title: 'Atribuir um plano de aula a esta aula?',
      message: 'Você precisa ter um plano seu para atribuir a essa aula.',
      cancelTitle: 'Não',
      confirmTitle: 'SIM',
    )) {
      var plano = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlanoPicker(),
          ));
      if (plano != null) {
        dynamic resource = (event.resourceIds![0]);
        String turmaId = resource['docId'];

        var turma = Turma.fromJson(await turmas.doc(turmaId).get());

        turma.eventosPlanos!.add({
          'planoId': plano.id,
          'planoTitulo': plano['titulo'],
          'startTime': event.startTime,
          'endTime': event.endTime,
        });

        await turmas.doc(turmaId).update(turma.toJson());
      }
    }
  }
}
