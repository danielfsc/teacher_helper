import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_editor/turma_editor.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma.dart';

class TurmasCard extends StatelessWidget {
  const TurmasCard({Key? key, required this.turma, required this.onDelete})
      : super(key: key);

  final Function(Turma turma) onDelete;

  final Turma turma;

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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Wrap(
                  children: turma.dias
                      .map(
                        (dia) => Row(
                          children: [
                            Text(
                              dia.dia.curto,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(' (${dia.intervalo(context)})')
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => _edit(context, turma),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => onDelete(turma),
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
      MaterialPageRoute(builder: (context) => TurmaEditor(turma: turma)),
    );
  }
}
