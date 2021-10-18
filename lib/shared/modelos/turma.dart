import 'package:flutter/material.dart';

import 'package:teacher_helper/shared/data/datas.dart';

class Turma {
  String nome;
  String? escola;
  String? disciplina;
  List<DiaAula> dias = [];

  Turma({
    required this.nome,
    this.escola,
    this.disciplina,
    required this.dias,
  });

  factory Turma.fromJson(Map<String, dynamic> json) {
    List<DiaAula> dias = [];
    json['dias'].forEach((element) {
      dias.add(DiaAula.fromJson(element));
    });

    return Turma(
      nome: json["nome"],
      escola: json["escola"],
      disciplina: json["disciplina"],
      dias: dias,
    );
  }

  Map<String, dynamic> toJson() {
    // print(dias);
    // dias.map((value) => print('Teste'));
    return {
      'nome': nome,
      'escola': escola,
      'disciplina': disciplina,
      'dias': dias.map((value) => value.toJson()).toList(growable: false),
    };
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

  factory DiaAula.fromJson(Map<String, dynamic> json) => DiaAula(
        dia: Semana.values[json['dia']],
        inicioHora: json["inicioHora"],
        inicioMinuto: json["inicioMinuto"],
        fimHora: json["fimHora"],
        fimMinuto: json["fimMinuto"],
      );

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

  String intervalo(context) {
    return '${inicio.format(context)}-${fim.format(context)} ';
  }
}