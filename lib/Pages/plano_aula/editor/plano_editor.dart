import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:teacher_helper/Pages/plano_aula/editor/plano_atividade_editor.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/data/nivel_escolar.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';
import 'package:teacher_helper/shared/widgets/disciplina_field.dart';
import 'package:teacher_helper/shared/widgets/show_dialog.dart';
import 'package:teacher_helper/shared/widgets/snack_message.dart';

class PlanoEditor extends StatefulWidget {
  const PlanoEditor({Key? key, this.plano}) : super(key: key);

  final PlanoAula? plano;

  @override
  _PlanoEditorState createState() => _PlanoEditorState();
}

class _PlanoEditorState extends State<PlanoEditor> {
  PlanoAula plano = PlanoAula.empty();
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _disciplina = TextEditingController();
  final _preparacao = TextEditingController();
  final Map<String, List<String>> listas = {
    'conteudos': [],
    'objetivos': [],
    'recursos': [],
    'bibliografias': []
  };
  List<Map<String, dynamic>> atividades = [];

  int nivel = 0;
  bool publico = false;
  int _index = 0;

  @override
  void initState() {
    if (widget.plano != null) {
      plano = widget.plano!;
      _titulo.text = plano.titulo;
      _disciplina.text = plano.disciplina ?? '';
      _preparacao.text = plano.preparacao ?? '';
      listas['conteudos'] = plano.conteudos;
      listas['objetivos'] = plano.objetivos;
      listas['recursos'] = plano.recursos;
      listas['bibliografias'] = plano.bibliografias;
      atividades = plano.atividades;
      nivel = plano.nivel;
      publico = plano.publico;
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
      // controlsBuilder: ,
      // controlsBuilder: (BuildContext context,
      // {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) =>
      // const SizedBox.shrink(),
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
              _tituloField(context),
              disciplinaField(_disciplina),
              _publicoSwitch(context),
            ],
          ),
        ),
        Step(
          title: const Text('Pré-Aula'),
          content: Wrap(
            runSpacing: 20,
            spacing: 20,
            children: [
              _nivelDropdown(),
              _preparacaoField(context),
              _lista(
                context,
                'recursos',
                title: 'Recurso',
                subtitle:
                    'Descreva quais serão os recursos necessários para a aula',
              ),
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

  Widget _tituloField(BuildContext context) {
    return TextFormField(
      decoration: _decoration('Título*'),
      controller: _titulo,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'O Título é obrigatório';
        }
        return null;
      },
    );
  }

  Widget _publicoSwitch(BuildContext context) {
    return Container(
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
    );
  }

  Widget _nivelDropdown() {
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

  Widget _preparacaoField(BuildContext context) {
    return TextFormField(
      decoration: _decoration('Preparação para a aula'),
      controller: _preparacao,
      maxLines: null,
    );
  }

  Widget _atividades(BuildContext context) {
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ReorderableListView(
              physics: const ScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = atividades.removeAt(oldIndex);
                  atividades.insert(newIndex, item);
                });
              },
              children: [
                for (final e in atividades)
                  Card(
                    key: ValueKey(e),
                    child: ListTile(
                      title: Text(e['titulo']),
                      subtitle: Text('${e['duracao']} min'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _editaAtividade(
                                context, atividades.indexOf(e), e),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _deleteAtividade(
                                context, atividades.indexOf(e)),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],

              // atividades.map((e) {
              //   return
              // }).toList(),
            ),
          ),
        ],
      ),
    );
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

  _salvaPlano(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        _atualizaPlanoAula();
        await plano.save();
        Navigator.of(context).pop();
      } catch (e) {
        snackMessage(context,
            message:
                'Tive um probelma para salvar. Tente de novo ou fale com os desenvolvedores.',
            color: Colors.red);
      }
    }
  }

  _atualizaPlanoAula() {
    plano.titulo = _titulo.text;
    plano.userMail = AppController.instance.email;
    plano.disciplina = _disciplina.text.toUpperCase();
    plano.publico = publico;
    plano.nivel = nivel;
    plano.preparacao = _preparacao.text;
    plano.conteudos = listas['conteudos']!;
    plano.objetivos = listas['objetivos'] as List<String>;
    plano.recursos = listas['recursos'] as List<String>;
    plano.bibliografias = listas['bibliografias'] as List<String>;
    plano.atividades = atividades;
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
      title: SizedBox(
          width: MediaQuery.of(context).size.width > 700
              ? 500
              : MediaQuery.of(context).size.width * 0.8,
          child: Text("Escreva o $title:")),
      minLines: 2,
      maxLines: 3,
    );
    setState(() {
      if (input != null) {
        listas[list]!.add(input);
      }
    });
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
