import 'package:flutter/material.dart';

class PlanoAtividadeEditor extends StatefulWidget {
  const PlanoAtividadeEditor({Key? key, this.atividade}) : super(key: key);

  final Map<String, dynamic>? atividade;

  @override
  State<PlanoAtividadeEditor> createState() => _PlanoAtividadeEditorState();
}

class _PlanoAtividadeEditorState extends State<PlanoAtividadeEditor> {
  final _formKey = GlobalKey<FormState>();

  final _duracao = TextEditingController();

  final _titulo = TextEditingController();

  final _descricao = TextEditingController();

  @override
  void initState() {
    if (widget.atividade != null) {
      _duracao.text = widget.atividade!['duracao'].toString();
      _titulo.text = widget.atividade!['titulo'];
      _descricao.text = widget.atividade!['descricao'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Atividade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              TextFormField(
                key: _formKey,
                controller: _duracao,
                decoration: _decoration('Duração (em min)*'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A duração é obrigatória';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: _formKey,
                controller: _titulo,
                decoration: _decoration('Título *'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: _formKey,
                controller: _descricao,
                minLines: 3,
                maxLines: 4,
                decoration: _decoration('Descrição*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Faça uma descrição da atividade.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _salvar(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  _salvar(context) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'duracao': int.parse(_duracao.text),
        'titulo': _titulo.text,
        'descricao': _descricao.text,
      });
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
