import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario/eventos.dart';
import 'package:teacher_helper/controllers/turmas_controller.dart';
import 'package:teacher_helper/shared/modelos/turma.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  final TurmasController turmasController = TurmasController();

  @override
  Widget build(BuildContext context) {
    return PageMask(
      title: 'Calendário',
      body: FutureBuilder<List<Turma>>(
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data!.isNotEmpty) {
              return SfCalendar(
                view: CalendarView.week,
                showNavigationArrow: true,
                firstDayOfWeek: 7,
                initialDisplayDate: DateTime.now(),
                initialSelectedDate: DateTime.now(),
                todayHighlightColor: Theme.of(context).primaryColor,
                dataSource: MeetingDataSource(eventosTurmas(snapshot.data!)),
              );
            } else {
              return const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('Sem turmas registradas'),
                  ),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: turmasController.getAll(),
      ),
    );
  }
}

class EventEditingPage {}
