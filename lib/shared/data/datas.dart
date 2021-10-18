enum Semana { domingo, segunda, terca, quarta, quinta, sexta, sabado }

extension SemanaText on Semana {
  List<Semana> get values {
    return [
      Semana.domingo,
      Semana.segunda,
      Semana.terca,
      Semana.quarta,
      Semana.quinta,
      Semana.sexta,
      Semana.sabado
    ];
  }

  String get extenso {
    switch (this) {
      case Semana.domingo:
        return 'Domingo';
      case Semana.segunda:
        return 'Segunda';
      case Semana.terca:
        return 'Terça';
      case Semana.quarta:
        return 'Quarta';
      case Semana.quinta:
        return 'Quinta';
      case Semana.sexta:
        return 'Sexta';
      case Semana.sabado:
        return 'Sábado';
    }
  }

  String get longo {
    switch (this) {
      case Semana.domingo:
        return 'Domingo';
      case Semana.segunda:
        return 'Segunda-Feira';
      case Semana.terca:
        return 'Terça-Feira';
      case Semana.quarta:
        return 'Quarta-Feira';
      case Semana.quinta:
        return 'Quinta-Feira';
      case Semana.sexta:
        return 'Sexta-Feira';
      case Semana.sabado:
        return 'Sábado';
    }
  }

  String get curto {
    switch (this) {
      case Semana.domingo:
        return 'Dom';
      case Semana.segunda:
        return 'Seg';
      case Semana.terca:
        return 'Ter';
      case Semana.quarta:
        return 'Qua';
      case Semana.quinta:
        return 'Qui';
      case Semana.sexta:
        return 'Sex';
      case Semana.sabado:
        return 'Sab';
    }
  }
}
