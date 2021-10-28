import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';

// @Deprecated - criei outra função;
List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];

  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 19, 0, 0);

  meetings.add(
    Appointment(
        startTime: startTime, //evento de duas horas com recorrencia
        endTime: startTime.add(const Duration(minutes: 50)),
        subject: 'Aula Programação - Daniel',
        color: Colors.red,
        recurrenceRule: 'FREQ=WEEKLY;BYDAY:TH, WE, FR, SA'),
  );
  //UMA AULA NESSE DIA DA SEMANA A CADA 7 DIAS POR 6 SEMANAS*/

  meetings.add(Appointment(
      //evento dentro de um mesmo dia com duração
      startTime: DateTime(2021, 10, 12, 13),
      endTime: DateTime.now().add(const Duration(hours: 4)),
      subject: 'Dia do Aprendizado',
      color: Colors.green));

  meetings.add(Appointment(
      startTime: DateTime(2021, 11, 12, 14), //evento mais de um dia
      endTime: DateTime(2021, 11, 15, 17),
      subject: 'Data final de entrega dos projetos',
      color: Colors.black));

  return meetings;
}

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
          startTime: startTime, //evento de duas horas com recorrencia
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
