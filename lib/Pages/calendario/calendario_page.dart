import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario/eventos.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/turma.dart';
import 'package:teacher_helper/shared/page_mask.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  CollectionReference turmas = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.user.email!}/turmas');

  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Calendário',
      body: StreamBuilder(
        stream: turmas.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return loading();
          } else if (snapshot.data.docs.length == 0) {
            return semregistro('Nenhuma turma cadastrada.');
          }
          return _calendario(
            snapshot.data.docs
                .map((e) => Turma.fromJson(e))
                .cast<Turma>()
                .toList(),
          );
        },
      ),
    );
  }

  Widget _calendario(List<Turma> turmas) {
    return SfCalendar(
      view: CalendarView.week,
      showNavigationArrow: true,
      firstDayOfWeek: 7,
      initialDisplayDate: DateTime.now(),
      initialSelectedDate: DateTime.now(),
      todayHighlightColor: Theme.of(context).primaryColor,
      dataSource: MeetingDataSource(eventosTurmas(turmas)),
    );
  }
}
