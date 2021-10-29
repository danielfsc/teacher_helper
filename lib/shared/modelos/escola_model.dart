import 'dart:convert';

class Escola {
  String nome;
  String estado;
  String cidade;
  Escola({
    required this.nome,
    required this.estado,
    required this.cidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'estado': estado,
      'cidade': cidade,
    };
  }

  factory Escola.fromJson(Map<String, dynamic> map) {
    return Escola(
      nome: map['nome'],
      estado: map['estado'],
      cidade: map['cidade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Escola.fromString(String source) =>
      Escola.fromJson(json.decode(source));
}
