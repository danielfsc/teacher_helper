import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_card.dart';
import 'package:teacher_helper/Pages/turmas/turma_editor/turma_editor.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

class Turma {
  String? docId;
  String nome;
  String? escola;
  String? disciplina;
  List<dynamic>? eventosPlanos;
  int cor;
  List<DiaAula> dias = [];

  Turma({
    required this.nome,
    required this.cor,
    this.escola,
    this.disciplina,
    required this.dias,
    this.eventosPlanos,
    this.docId,
  }) {
    eventosPlanos = eventosPlanos ?? [];
  }

  factory Turma.fromJson(json) {
    List<DiaAula> dias = [];

    json['dias'].forEach((element) {
      dias.add(DiaAula.fromJson(element));
    });

    String? id = json.id;

    int color = json['cor'] ?? 4283215696;

    var eventos = (json.data() as dynamic)['eventosPlanos'] ?? [];

    return Turma(
      docId: id,
      cor: color,
      nome: json["nome"],
      escola: json["escola"],
      disciplina: json["disciplina"],
      dias: dias,
      eventosPlanos: eventos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cor': cor,
      'escola': escola,
      'disciplina': disciplina,
      'eventosPlanos': eventosPlanos,
      'dias': dias.map((value) => value.toJson()).toList(growable: false),
    };
  }

  Widget card(BuildContext context) {
    return TurmasCard(turma: this);
  }

  Future<void> edit(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TurmaEditor(turma: this),
      ),
    );
  }

  Future<void> destroy(context) async {
    if (await showAlert(
      context,
      title: 'Deletar Turma',
      message:
          'Essa é irreversível e irá deletar todos os eventos que estão associados a essa turma. TEM CERTEZA?',
      cancelTitle: 'CANCELAR',
    )) {
      FirebaseFirestore.instance
          .collection('usuarios/${AppController.instance.email}/turmas')
          .doc(docId)
          .delete();
    }
  }

  Future<void> save() async {
    try {
      if (docId != null) {
        await FirebaseFirestore.instance
            .collection('usuarios/${AppController.instance.email}/turmas')
            .doc(docId)
            .update(toJson());
      } else {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('usuarios/${AppController.instance.email}/turmas')
            .add(toJson());
        docId = docRef.id;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class DiaAula {
  Semana dia;
  int inicioHora;
  int inicioMinuto;
  int fimHora;
  int fimMinuto;
  DiaAula({
    required this.dia,
    required this.inicioHora,
    required this.inicioMinuto,
    required this.fimHora,
    required this.fimMinuto,
  });

  String get curto {
    return dia.curto;
  }

  factory DiaAula.fromJson(json) => DiaAula(
        dia: Semana.values[json['dia']],
        inicioHora: json["inicioHora"],
        inicioMinuto: json["inicioMinuto"],
        fimHora: json["fimHora"],
        fimMinuto: json["fimMinuto"],
      );

  int get duracaoMinutos {
    return (fimHora * 60 + fimMinuto) - (inicioHora * 60 + inicioMinuto);
  }

  Map<String, dynamic> toJson() => {
        'dia': dia.index,
        'inicioHora': inicioHora,
        'inicioMinuto': inicioMinuto,
        'fimHora': fimHora,
        'fimMinuto': fimMinuto,
      };

  TimeOfDay _horario(int hora, int minuto) {
    TimeOfDay time = TimeOfDay(hour: hora, minute: minuto);
    return time;
  }

  TimeOfDay get inicio {
    return _horario(inicioHora, inicioMinuto);
  }

  TimeOfDay get fim {
    return _horario(fimHora, fimMinuto);
  }

  String intervalo(context, {String? separator}) {
    separator = separator ?? '-';
    return '${inicio.format(context)} $separator ${fim.format(context)} ';
  }
}
