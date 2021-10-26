import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_editor/turma_editor.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';

class TurmasCard extends StatelessWidget {
  const TurmasCard(
      {Key? key,
      required this.turma,
      required this.onDelete,
      required this.docId})
      : super(key: key);

  final Function(String docId) onDelete;

  final Turma turma;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      turma.nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Text(turma.disciplina ?? ''),
                    Text(turma.escola ?? ''),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: turma.dias
                        .map(
                          (dia) => Column(
                            children: [
                              Text(
                                dia.dia.curto,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(' ${dia.intervalo(context, separator: '-')}')
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => _edit(context, turma),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => showAlertDialog(context, turma),
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _edit(context, Turma turma) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TurmaEditor(
                turma: turma,
                docId: docId,
              )),
    );
  }

  showAlertDialog(BuildContext context, Turma turma) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Deletar"),
      onPressed: () {
        onDelete(docId);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Deletar Turma"),
      content: const Text(
          "Você vai deletar uma turma e esse processo é irreversível. TEM CERTEZA?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}