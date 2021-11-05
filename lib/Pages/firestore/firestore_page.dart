import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({Key? key}) : super(key: key);

  @override
  _FirestorePageState createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  final textController = TextEditingController();

  CollectionReference groceries = FirebaseFirestore.instance
      .collection('usuarios/${AppController.instance.email}/groceries');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        controller: textController,
      )),
      body: StreamBuilder(
        stream: groceries.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Carregando'),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((grocery) {
              return Center(
                child: ListTile(
                  title: Text(grocery['fruit']),
                  subtitle: Text(grocery.id),
                  onLongPress: () {
                    grocery.reference.delete();
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          groceries.add({
            'fruit': textController.text,
          });
          textController.clear();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
