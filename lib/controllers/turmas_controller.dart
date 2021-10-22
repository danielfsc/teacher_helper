import 'package:sembast/sembast.dart';
import 'package:teacher_helper/controllers/app_database.dart';
import 'package:teacher_helper/shared/modelos/turma_model.dart';

class TurmasController {
  static const String folderName = 'Turmas';
  final _pastaTurma = intMapStoreFactory.store(folderName);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insere(Turma turma) async {
    await _pastaTurma.add(await _db, turma.toJson());
  }

  Future atualiza(Turma turma) async {
    final finder = Finder(filter: Filter.byKey(turma.nome));
    await _pastaTurma.update(await _db, turma.toJson(), finder: finder);
  }

  Future delete(Turma turma) async {
    final finder = Finder(filter: Filter.equals('nome', turma.nome));
    await _pastaTurma.delete(await _db, finder: finder);
  }

  Future<List<Turma>> getAll() async {
    final recordSnapshot = await _pastaTurma.find(await _db);
    return recordSnapshot.map((snapshot) {
      final turmas = Turma.fromJson(snapshot.value);
      return turmas;
    }).toList();
  }
}
