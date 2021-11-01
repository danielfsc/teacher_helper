import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> storeDisciplina(String? disciplina) async {
  if (disciplina == null) return;
  FirebaseFirestore.instance
      .collection('disciplinas')
      .doc(Uri.encodeComponent(disciplina))
      .set({'nome': disciplina});
}
