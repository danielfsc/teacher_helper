// import 'dart:convert';

class PlanoAula {
  String? id;
  String? disciplina;
  String? preparacao;
  String? userMail;
  String titulo;
  int nivel;
  bool publico = false;
  List<String> objetivos = [];
  List<String> competenciasBNCC = [];
  List<String> recursos = [];
  List<Map<String, dynamic>> bibliografia = [];
  List<Map<String, dynamic>> atividades = [];
  PlanoAula({
    this.id,
    this.disciplina,
    this.preparacao,
    this.userMail,
    required this.titulo,
    required this.nivel,
    required this.publico,
    required this.objetivos,
    required this.competenciasBNCC,
    required this.recursos,
    required this.bibliografia,
    required this.atividades,
  });

  saveInFireStore() {}
}

transformaDataEmPlano(data, id) {
  return {
    'id': id,
    'userMail': data['userMail'],
    'titulo': data['titulo'],
    'publico': data['publico'],
    'disciplina': data['disciplina'],
    'nivel': data['nivel'],
    'preparacao': data['preparacao'],
    'conteudos': data['conteudos'],
    'objetivos': data['objetivos'],
    'recursos': data['recursos'],
    'atividades': data['atividades'],
    'bibliografias': data['bibliografias'],
  };
}
