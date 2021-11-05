import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:teacher_helper/shared/widgets/empty_loading.dart';

Widget disciplinaField(TextEditingController controller) {
  bool _isLoading = false;

  Future<List<String>> procuraDisciplina(String nome) async {
    if (nome.isNotEmpty) {
      nome = nome.toUpperCase();
      try {
        _isLoading = true;
        var teste = await FirebaseFirestore.instance
            .collection('disciplinas')
            .orderBy('nome')
            .startAt([nome]).endAt([nome + '\uf8ff']).get();

        _isLoading = false;
        return teste.docs.map((d) => (d['nome'] as String)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  return TypeAheadField(
    textFieldConfiguration: TextFieldConfiguration(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: 'Disciplina',
      ),
    ),
    suggestionsCallback: procuraDisciplina,
    itemBuilder: (context, String suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    onSuggestionSelected: (String suggestion) {
      controller.text = suggestion;
    },
    noItemsFoundBuilder: (context) {
      return Center(
        child: SizedBox(
          height: 60,
          child: _isLoading
              ? loading()
              : Text(
                  controller.text.length > 3
                      ? 'Sem sugestões'
                      : 'Digite mais para procurar',
                  style: const TextStyle(fontSize: 24),
                ),
        ),
      );
    },
  );
}
