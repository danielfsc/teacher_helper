import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';

List<Appointment> eventosTurmas(List<dynamic> turmas,
    {bool apenasTurmas = false}) {
  List<Appointment> eventos = <Appointment>[];
  for (var doc in turmas) {
    Turma turma = Turma.fromJson(doc);
    eventos += eventosDias(turma, doc.id);
    if (!apenasTurmas) {
      eventos += eventosPlanos(turma, doc.id);
    }
  }

  return eventos;
}

List<Appointment> eventosPlanos(Turma turma, String docId) {
  List<Appointment> eventos = <Appointment>[];
  for (var plano in turma.eventosPlanos!) {
    eventos.add(Appointment(
      startTime: plano['startTime'].toDate(),
      endTime: plano['endTime'].toDate(),
      subject: 'Plano: ${plano['planoTitulo']}',
      color: Colors.green,
      resourceIds: [
        {'type': 'plano', 'docId': plano['planoId']},
        {'type': 'turma', 'docId': docId},
      ],
    ));
  }
  return eventos;
}

List<Appointment> eventosDias(Turma turma, String docId) {
  List<Appointment> eventos = <Appointment>[];
  for (var dia in turma.dias) {
    DateTime agora = DateTime.now();
    DateTime startTime = DateTime(
        agora.year, agora.month, agora.day, dia.inicioHora, dia.inicioMinuto);
    eventos.add(
      Appointment(
          startTime: startTime,
          endTime: startTime.add(Duration(minutes: dia.duracaoMinutos)),
          subject:
              '${turma.nome}\n${turma.escola}\nDisciplina: ${turma.disciplina} ',
          color: Color(turma.cor),
          resourceIds: [
            {'type': 'turma', 'docId': docId}
          ],
          recurrenceRule: 'FREQ=WEEKLY;BYDAY:${dia.dia.byday}'),
    );
  }
  return eventos;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
