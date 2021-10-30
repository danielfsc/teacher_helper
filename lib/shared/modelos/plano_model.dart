import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:teacher_helper/Pages/calendario/calendario_picker.dart';
import 'package:teacher_helper/Pages/plano_aula/editor/plano_editor.dart';
import 'package:teacher_helper/Pages/plano_aula/executar/plano_executar.dart';
import 'package:teacher_helper/Pages/plano_aula/visualizar/plano_view.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';
import 'package:teacher_helper/shared/utils/gera_plano.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

class PlanoAula {
  String? docId;
  String titulo;
  String? disciplina;
  int nivel;
  String? preparacao;
  bool publico = false;
  List<String> recursos = [];
  List<String> conteudos = [];
  List<String> objetivos = [];
  List<String> bibliografias = [];
  List<Map<String, dynamic>> atividades = [];
  String? userMail;

  PlanoAula({
    this.docId,
    this.disciplina,
    this.preparacao,
    this.userMail,
    required this.titulo,
    required this.nivel,
    required this.publico,
    required this.objetivos,
    required this.recursos,
    required this.bibliografias,
    required this.atividades,
  });

  factory PlanoAula.empty() {
    return PlanoAula(
        titulo: '',
        nivel: 0,
        publico: false,
        objetivos: [],
        recursos: [],
        bibliografias: [],
        atividades: []);
  }

  save() async {
    if (docId != null) {
      userMail = AppController.instance.email;
      await FirebaseFirestore.instance
          .collection('planosaula')
          .doc(docId)
          .update(toJson());
    } else {
      userMail = AppController.instance.email;
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('planosaula')
          .add(toJson());
      docId = docRef.id;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'disciplina': disciplina,
      'preparacao': preparacao,
      'userMail': userMail,
      'titulo': titulo,
      'nivel': nivel,
      'publico': publico,
      'objetivos': objetivos,
      'recursos': recursos,
      'bibliografias': bibliografias,
      'atividades': atividades,
    };
  }

  factory PlanoAula.fromJson(json) {
    return PlanoAula(
      docId: json.id,
      disciplina: json['disciplina'],
      preparacao: json['preparacao'],
      userMail: json['userMail'],
      titulo: json['titulo'],
      nivel: json['nivel'],
      publico: json['publico'],
      objetivos: List<String>.from(json['objetivos']),
      recursos: List<String>.from(json['recursos']),
      bibliografias: List<String>.from(json['recursos']),
      atividades: List.from(json['atividades']),
    );
  }
  @override
  String toString() => json.encode(toJson());

  factory PlanoAula.fromString(String source) =>
      PlanoAula.fromJson(json.decode(source));

  PlanoAula copy() {
    PlanoAula fake = this;
    fake.docId = null;
    return fake;
  }

  int fullTime() {
    int total = 0;
    for (var atividade in atividades) {
      total += atividade['duracao'] as int;
    }
    return total;
  }

  Future<void> duplicate(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanoEditor(plano: copy())),
    );
  }

  Future<void> edit(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlanoEditor(plano: this),
        ));
  }

  Future<void> execute(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlanoExecutar(plano: this),
        ));
  }

  Future<void> view(BuildContext context, {bool isPrivate = true}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlanoView(plano: this, isPrivate: isPrivate)),
    );
  }

  Future<void> destroy(BuildContext context) async {
    if (await showAlert(
      context,
      title: 'Deletar Plano de Aula',
      message: 'Essa ação não pode ser desfeita.\n Tem certeza?',
      cancelTitle: 'CANCELAR',
    )) {
      await FirebaseFirestore.instance
          .collection('planosaula')
          .doc(docId)
          .delete();
    }
  }

  Future<void> schedule(BuildContext context) async {
    CalendarTapDetails? evento = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarioPicker()),
    );
    if (evento != null) {
      if (evento.appointments != null && evento.appointments!.isNotEmpty) {
        await schedulePlanoToTurma(evento.appointments![0], this);
      }
    }
  }

  Future<void> convertToDocx() async {
    await geraPlano(this);
  }
}

Future<void> schedulePlanoToTurma(
    Appointment appointment, PlanoAula plano) async {
  String turmaId = (appointment.resourceIds![0] as Map)['docId'];
  Turma turma = Turma.fromJson(
    await FirebaseFirestore.instance
        .collection('usuarios/${AppController.instance.user.email}/turmas')
        .doc(turmaId)
        .get(),
  );
  await turma.addEventoPlano(plano, appointment);
}
