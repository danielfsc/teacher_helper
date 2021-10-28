import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/plano_aula/visualizar/plano_view.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

class PlanoPicker extends StatefulWidget {
  const PlanoPicker({Key? key}) : super(key: key);

  @override
  State<PlanoPicker> createState() => _PlanoPickerState();
}

class _PlanoPickerState extends State<PlanoPicker> {
  CollectionReference planos =
      FirebaseFirestore.instance.collection('planosaula');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha  um plano'),
      ),
      body: StreamBuilder(
        stream: planos
            .where('userMail', isEqualTo: AppController.instance.user.email)
            .orderBy('titulo')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return loading();
          } else if (snapshot.data.docs.length == 0) {
            return semregistro('Você não tem planos de aula registrados.');
          }
          return _listaPlanos(snapshot.data.docs);
        },
      ),
    );
  }

  _listaPlanos(data) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var plano = data[index];
          return Card(
            child: ListTile(
              title: Text(
                plano['titulo'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlanoView(
                              plano: plano,
                            ),
                          ));
                    },
                    icon: const Icon(Icons.visibility),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(plano);
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
