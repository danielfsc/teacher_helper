// import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:teacher_helper/Pages/plano_aula/editor/plano_atividade_editor.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/data/nivel_escolar.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';

class PlanoEditor extends StatefulWidget {
  const PlanoEditor({Key? key, this.plano}) : super(key: key);

  final dynamic plano;

  @override
  _PlanoEditorState createState() => _PlanoEditorState();
}

class _PlanoEditorState extends State<PlanoEditor> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _disciplina = TextEditingController();
  final _preparacao = TextEditingController();
  final Map<String, List<dynamic>> listas = {
    'conteudos': [],
    'objetivos': [],
    'recursos': [],
    'bibliografias': []
  };
  List<dynamic> atividades = [];

  int nivel = 0;
  bool publico = false;
  int _index = 0;

  @override
  void initState() {
    if (widget.plano != null) {
      _titulo.text = widget.plano!['titulo'];
      _disciplina.text = widget.plano!['disciplina'];
      _preparacao.text = widget.plano!['preparacao'];
      listas['conteudos'] = widget.plano!['conteudos'];
      listas['objetivos'] = widget.plano!['objetivos'];
      listas['recursos'] = widget.plano!['recursos'];
      listas['bibliografias'] = widget.plano!['bibliografias'];
      atividades = widget.plano!['atividades'];
      nivel = widget.plano!['nivel'];
      publico = widget.plano!['publico'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Plano de Aula'),
      ),
      body: Form(
        key: _formKey,
        child: _stepper(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _salvaPlano(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _stepper(context) {
    return Stepper(
      currentStep: _index,
      controlsBuilder: (BuildContext context,
              {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) =>
          const SizedBox.shrink(),
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: [
        Step(
          title: const Text('Geral'),
          content: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              const SizedBox.shrink(),
              TextFormField(
                decoration: _decoration('Título*'),
                controller: _titulo,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O Título é obrigatório';
                  }
                  return null;
                },
              ),

              //PUBLICO
              Container(
                decoration: boxDecoration,
                child: SwitchListTile(
                  value: publico,
                  title: Text(
                      'Deixar o plano de aula público? \n${publico ? "SIM" : "NÃO"}'),
                  onChanged: (value) {
                    setState(() {
                      publico = !publico;
                    });
                  },
                ),
              ),
              //DISCIPLINA
              TextFormField(
                decoration: _decoration('Disciplina ${publico ? "*" : ""}'),
                controller: _disciplina,
                validator: (value) {
                  if (publico && (value == null || value.isEmpty)) {
                    return "Disciplina é obrigatória para plano público";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        Step(
          title: const Text('Pré-Aula'),
          content: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _nivel(),
              //PREPARACAO
              TextFormField(
                decoration: _decoration('Preparação para a aula'),
                controller: _preparacao,
                maxLines: null,
              ),
              _lista(context, 'recursos',
                  title: 'Recurso',
                  subtitle:
                      'Descreva quais serão os recursos necessários para a aula'),
            ],
          ),
        ),
        Step(
          title: const Text('Conteúdos/Objetivos'),
          content: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _lista(context, 'conteudos', title: 'Conteúdo'),
              _lista(context, 'objetivos', title: 'Objetivo'),
            ],
          ),
        ),
        Step(
          title: const Text('Desenvolvimento'),
          content: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _atividades(context),
            ],
          ),
        ),
        Step(
          title: const Text('Bibliografia'),
          content: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _lista(context, 'bibliografias', title: 'Bibliografia'),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration boxDecoration = BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(5.0),
  );

  Widget _nivel() {
    return Container(
      decoration: boxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<int>(
          isExpanded: true,
          value: nivel,
          onChanged: (int? newValue) {
            setState(() {
              nivel = newValue!;
            });
          },
          items: niveisEscolares.map<DropdownMenuItem<int>>((String value) {
            return DropdownMenuItem<int>(
              value: niveisEscolares.indexOf(value),
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _atividades(context) {
    return Container(
      decoration: boxDecoration,
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Atividades',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Duração: ${calculaDuracaoTotal(atividades)} min ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addAtividade(context);
              },
            ),
          ),
          Column(
            children: atividades.map((e) {
              return Card(
                child: ListTile(
                  title: Text(e['titulo']),
                  subtitle: Text('${e['duracao']} min'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () =>
                            _editaAtividade(context, atividades.indexOf(e), e),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () =>
                            _deleteAtividade(context, atividades.indexOf(e)),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _editaAtividade(context, index, atividade) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlanoAtividadeEditor(atividade: atividade)),
    ).then((value) {
      if (value != null) {
        setState(() => atividades[index] = value);
      }
    });
  }

  _deleteAtividade(context, int index) async {
    showAlert(
      context,
      title: 'Deletar Atividade',
      message: 'Essa ação não pode ser desfeita.\n Tem certeza?',
      cancelTitle: 'CANCELAR',
    ).then((value) {
      if (value) {
        setState(() {
          atividades.removeAt(index);
        });
      }
    });
  }

  _addAtividade(context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlanoAtividadeEditor()),
    ).then((value) {
      if (value != null) {
        setState(() => atividades.add(value));
      }
    });
  }

  Widget _lista(context, String list, {String title = '', String? subtitle}) {
    return Container(
      decoration: boxDecoration,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${title}s',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: subtitle != null ? Text(subtitle) : null,
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addLista(context, list, title);
              },
            ),
          ),
          Column(
            children: listas[list]!
                .map(
                  (e) => Card(
                    child: ListTile(
                      title: Text(e),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteLista(
                              context, list, title, listas[list]!.indexOf(e));
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  _deleteLista(context, list, title, index) async {
    showAlert(
      context,
      title: 'Deletar $title',
      message: 'Essa ação não pode ser desfeita.\n Tem certeza?',
      cancelTitle: 'CANCELAR',
    ).then((value) {
      if (value) {
        setState(() {
          listas[list]!.removeAt(index);
        });
      }
    });
  }

  _addLista(context, list, title) async {
    var input = await prompt(
      context,
      title: Text("Escreva o $title:"),
      minLines: 2,
      maxLines: 3,
    );
    setState(() {
      if (input != null) {
        listas[list]!.add(input);
      }
    });
  }

  Map<String, dynamic> criaPlanoMap() {
    return {
      'userMail': AppController.instance.user.email,
      'titulo': _titulo.text,
      'publico': publico,
      'disciplina': _disciplina.text,
      'nivel': nivel,
      'preparacao': _preparacao.text,
      'conteudos': listas['conteudos'],
      'objetivos': listas['objetivos'],
      'recursos': listas['recursos'],
      'atividades': atividades,
      'bibliografias': listas['bibliografias'],
    };
  }

  _salvaPlano(context) {
    if (_formKey.currentState!.validate()) {
      CollectionReference plano =
          FirebaseFirestore.instance.collection('planosaula');
      if (widget.plano != null && widget.plano!['id'] != null) {
        plano.doc(widget.plano['id']).set(criaPlanoMap());
      } else {
        plano.add(criaPlanoMap());
      }
      Navigator.of(context).popAndPushNamed('/planos');
    }
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      labelText: label,
    );
  }
}

int calculaDuracaoTotal(lista) {
  return lista.isNotEmpty
      ? lista
          .map((value) => value['duracao'])
          .toList()
          .reduce((value, element) => value + element)
      : 0;
}
