import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_editor/ajusta_hora.dart';
import 'package:teacher_helper/controllers/turmas_controller.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma.dart';

class TurmaEditor extends StatefulWidget {
  const TurmaEditor({Key? key, this.turma}) : super(key: key);

  final Turma? turma;

  @override
  State<TurmaEditor> createState() => _TurmaEditorState();
}

class _TurmaEditorState extends State<TurmaEditor> {
  Turma? _turma;

  TurmasController dbTurmas = TurmasController();

  final _nome = TextEditingController();
  final _escola = TextEditingController();
  final _disciplina = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<DiaAula> dias = [];

  Semana? _diaSelecionado = Semana.domingo;

  @override
  void initState() {
    super.initState();
    if (widget.turma != null) {
      log('Vou definir os valores iniciais');

      _turma = widget.turma;
      _nome.text = _turma!.nome;
      _escola.text = _turma!.escola ?? '';
      _disciplina.text = _turma!.disciplina ?? '';

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
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              TextFormField(
                decoration: _decoration('Nome da Turma*'),
                controller: _nome,
                //initialValue: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, dê um nome para a turma';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: _decoration('Escola'),
                controller: _escola,
                // initialValue: turma.escola,
              ),
              TextFormField(
                decoration: _decoration('Disciplina'),
                controller: _disciplina,
                // initialValue: turma.disciplina,
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
    );
  }

  void _salvaTurma(context) {
    Turma turma = Turma(
        nome: _nome.text,
        escola: _escola.text,
        disciplina: _disciplina.text,
        dias: dias);
    if (widget.turma != null) {
      dbTurmas.delete(widget.turma!);
    }
    dbTurmas.insere(turma);
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

  InputDecoration _decoration(String label) {
    return InputDecoration(
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
