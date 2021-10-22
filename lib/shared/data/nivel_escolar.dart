var niveisEscolares = [
  'Ensino Fundamental',
  'Ensino Médio',
  'Ensino Superior',
  'Outros'
];
enum nivelEnsino { fundamental, medio, superior, outro }

extension NivelEnsinoText on nivelEnsino {
  String get extenso {
    switch (this) {
      case nivelEnsino.fundamental:
        return 'Ensino Fundamental';
      case nivelEnsino.medio:
        return 'Ensino Médio';
      case nivelEnsino.superior:
        return 'Ensino Superior';
      case nivelEnsino.outro:
        return 'Outro';
    }
  }
}
