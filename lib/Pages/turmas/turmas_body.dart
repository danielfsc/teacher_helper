import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/turmas/turma_card.dart';
import 'package:teacher_helper/controllers/turmas_controller.dart';
import 'package:teacher_helper/shared/modelos/turma.dart';

class TurmasBody extends StatefulWidget {
  const TurmasBody({Key? key}) : super(key: key);

  @override
  _TurmasBodyState createState() => _TurmasBodyState();
}

class _TurmasBodyState extends State<TurmasBody> {
  TurmasController turmasController = TurmasController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Turma>>(
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        Turma turma = snapshot.data![index];
                        return TurmasCard(
                          turma: turma,
                          onDelete: (Turma turma) => _delete(turma),
                        );
                      });
                } else {
                  return const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Sem turmas registradas'),
                      ),
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            future: turmasController.getAll(),
          ),
        ),
        TextButton(
          onPressed: () => setState(() {}),
          child: const Text('Atualizar'),
        ),
      ],
    );
  }

  void _delete(Turma turma) async {
    turmasController.delete(turma);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {});
  }
}
