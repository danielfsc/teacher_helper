import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario/eventos.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

class CalendarioPicker extends StatefulWidget {
  const CalendarioPicker({Key? key}) : super(key: key);

  @override
  State<CalendarioPicker> createState() => _CalendarioPickerState();
}

class _CalendarioPickerState extends State<CalendarioPicker> {
  CollectionReference turmas = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.user.email!}/turmas');

  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha a aula e turma'),
      ),
      body: StreamBuilder(
        stream: turmas.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          return _calendario(context, snapshot.data.docs);
        },
      ),
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
      onTap: (CalendarTapDetails details) {
        cliqueiNumEvento(context, details);
      },
      dataSource: MeetingDataSource(eventosTurmas(turmas, apenasTurmas: true)),
    );
  }

  Future<void> cliqueiNumEvento(
      BuildContext context, CalendarTapDetails evento) async {
    if (evento.appointments != null) {
      if (await showAlert(
        context,
        title: 'Vincular plano a essa turma?',
        // message: 'Você deseja adicionar o plano a turma?',
        cancelTitle: 'Não',
        confirmTitle: 'SIM',
      )) {
        Navigator.of(context).pop(evento);
      }
    }
  }
}

class CalendarPressDetails {}
