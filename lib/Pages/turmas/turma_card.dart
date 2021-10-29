import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/data/datas.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';

class TurmasCard extends StatelessWidget {
  const TurmasCard({
    Key? key,
    required this.turma,
  }) : super(key: key);

  final Turma turma;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _titulos(context),
              _aulas(context),
              _botoes(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titulos(context) {
    return SizedBox(
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
    );
  }

  Widget _aulas(context) {
    return Expanded(
      child: Center(
        child: Wrap(
          direction: Axis.horizontal,
          children: turma.dias
              .map(
                (dia) => Column(
                  children: [
                    Text(
                      dia.dia.curto,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(' ${dia.intervalo(context, separator: '-')}')
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _botoes(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () => turma.edit(context),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => turma.destroy(context),
            icon: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}
