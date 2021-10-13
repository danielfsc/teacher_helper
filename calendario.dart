import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario.dart';
import 'package:teacher_helper/Pages/eventoedit.dart';
import 'package:teacher_helper/shared/page_mask.dart';

class CalendarioPage extends StatelessWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageMask(
      floatingButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.blueGrey,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => eventEdit()))),
      body: SfCalendar(
        view: CalendarView.month,
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.transparent,
      ),
      title: 'Calendario',
    );
  }
}
