import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:teacher_helper/Pages/turmas/turma_editor/ajusta_hora.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/color_picker.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';

class TurmaEditor extends StatefulWidget {
  const TurmaEditor({Key? key, this.turma, this.docId}) : super(key: key);

  final Turma? turma;
  final String? docId;

  @override
  State<TurmaEditor> createState() => _TurmaEditorState();
}

class _TurmaEditorState extends State<TurmaEditor> {
  Turma? _turma;

  bool _isLoading = false;
  CollectionReference turmas = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.user.email!}/turmas');

  final _nome = TextEditingController();
  final _escola = TextEditingController();
  final _disciplina = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _cor = 4283215696;

  List<DiaAula> dias = [];

  Semana? _diaSelecionado = Semana.domingo;

  @override
  void initState() {
    super.initState();
    if (widget.docId != null) {
      _turma = widget.turma;
      _nome.text = _turma!.nome;
      _escola.text = _turma!.escola ?? '';
      _disciplina.text = _turma!.disciplina ?? '';
      _cor = _turma!.cor;
      dias = _turma!.dias;
    }
  }

  Map<String, TimeOfDay> intervalo = {
    'inicio': TimeOfDay.now(),
    'fim': TimeOfDay.now(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Turma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                const SizedBox(height: 0),
                TextFormField(
                  decoration: _decoration('Nome da Turma*'),
                  controller: _nome,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, dê um nome para a turma';
                    }
                    return null;
                  },
                ),
                _escolaField(),
                TextFormField(
                  decoration: _decoration('Disciplina'),
                  controller: _disciplina,
                ),
                ColorPicker(
                  onSelectColor: (Color color) {
                    _cor = color.value;
                  },
                  initialColor: Color(_cor),
                ),
                InputDecorator(
                  decoration: _decoration('Adicionar Aula'),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      DropdownButton<Semana>(
                        value: _diaSelecionado,
                        onChanged: (Semana? newvalue) {
                          setState(() {
                            _diaSelecionado = newvalue;
                          });
                        },
                        items: Semana.values.map((Semana dia) {
                          return DropdownMenuItem<Semana>(
                            value: dia,
                            child: Text(dia.longo),
                          );
                        }).toList(),
                      ),
                      AjustaHora(
                        title: 'Início',
                        time: intervalo['inicio']!,
                        onChange: (TimeOfDay value) {
                          setState(() {
                            intervalo['inicio'] = value;
                          });
                        },
                      ),
                      AjustaHora(
                        title: 'Fim',
                        time: intervalo['fim']!,
                        onChange: (TimeOfDay value) {
                          setState(() {
                            intervalo['fim'] = value;
                          });
                        },
                      ),
                      IconButton(
                        onPressed: () => _adicionaDias(),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                InputDecorator(
                  decoration: _decoration('Dias de Aula'),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: dias.map((d) {
                      var indice = dias.indexOf(d);
                      return Card(
                        child: ListTile(
                          title: Text(d.dia.extenso),
                          subtitle: Text(d.intervalo(context)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _removeDias(indice);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _salvaTurma(context);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _escolaField() {
    return TypeAheadField<String?>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _escola,
        decoration: _decoration('Escola', suffixIcon: const Icon(Icons.search)),
      ),
      suggestionsCallback: procuraEscola,
      itemBuilder: (context, String? suggestion) {
        return ListTile(
          title: Text(suggestion ?? ''),
        );
      },
      onSuggestionSelected: (String? suggestion) {
        _escola.text = suggestion!;
      },
      noItemsFoundBuilder: (context) {
        return Center(
          child: SizedBox(
            height: 60,
            child: _isLoading
                ? const CircularProgressIndicator()
                : Text(
                    _escola.text.length > 5
                        ? 'Nenhuma escola com esse nome'
                        : 'Digite mais para procurar',
                    style: const TextStyle(fontSize: 24),
                  ),
          ),
        );
      },
    );
  }

  Future<List<String>> procuraEscola(String nome) async {
    if (nome.length > 5) {
      try {
        _isLoading = true;
        final url = Uri.parse(
            'http://educacao.dadosabertosbr.com/api/escolas?nome=$nome');
        final response = await http.get(url);
        final converted = jsonDecode(response.body);

        final List<String> filtered = converted[1]
            .map((e) {
              return e['nome'];
            })
            .cast<String>()
            .toList();

        _isLoading = false;
        return filtered;
      } catch (e) {
        return ['Tive um problema com a rede! \nContinue digitando.'];
      }
    }
    return [];
  }

  void _salvaTurma(context) {
    Turma turma = Turma(
      nome: _nome.text,
      cor: _cor,
      escola: _escola.text,
      disciplina: _disciplina.text,
      dias: dias,
    );
    if (widget.docId != null) {
      log('Deveria editar a turma');
      turmas.doc(widget.docId).set(turma.toJson());
    } else {
      log('Vou adicionar nova turma');
      turmas.add(turma.toJson());
    }

    Navigator.of(context).pop(true);
  }

  void _snackMessage(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  _removeDias(int indice) {
    setState(() {
      dias.removeAt(indice);
    });
  }

  _adicionaDias() {
    if (inicioFimOK()) {
      setState(() {
        dias.add(DiaAula(
            dia: _diaSelecionado!,
            inicioHora: intervalo['inicio']!.hour,
            inicioMinuto: intervalo['inicio']!.minute,
            fimHora: intervalo['fim']!.hour,
            fimMinuto: intervalo['fim']!.minute));
      });
      return null;
    }
    _snackMessage(
        'O horário de início da aula deve ser antes do final da aula!',
        color: Colors.red);
  }

  int calculaDuracao() {
    var inicio = intervalo['inicio']!.hour * 60 + intervalo['inicio']!.minute;
    var fim = intervalo['fim']!.hour * 60 + intervalo['fim']!.minute;
    return fim - inicio;
  }

  InputDecoration _decoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      suffix: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      labelText: label,
    );
  }

  bool inicioFimOK() {
    return calculaDuracao() >= 0;
  }
}
