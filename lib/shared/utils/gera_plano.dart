import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:teacher_helper/shared/data/nivel_escolar.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';

Future<bool> geraPlano(PlanoAula plano) async {
  if (await Permission.storage.request() == PermissionStatus.granted) {
    final data = await rootBundle.load('assets/template_plano.docx');
    final bytes = data.buffer.asUint8List();

    final docx = await DocxTemplate.fromBytes(bytes);

    Content c = Content();

    c.add(TextContent('disciplina', plano.disciplina));
    c.add(TextContent('nivel', nivelEnsino.values[plano.nivel].extenso));
    c.add(TextContent('preparacao', plano.preparacao));

    c.add(ListContent(
        'recursos',
        plano.recursos
            .map((obj) => TextContent('recurso', obj))
            .toList()
            .cast<Content>()));
    c.add(ListContent(
        'conteudos',
        plano.conteudos
            .map((obj) => TextContent('conteudo', obj))
            .toList()
            .cast<Content>()));
    c.add(ListContent(
        'objetivos',
        plano.objetivos
            .map((obj) => TextContent('objetivo', obj))
            .toList()
            .cast<Content>()));

    c.add(TableContent(
        'atividades',
        plano.atividades
            .map((atividade) => RowContent()
              ..add(TextContent('duracao', atividade['duracao']))
              ..add(TextContent('titulo', atividade['titulo']))
              ..add(TextContent('descricao', atividade['descricao'])))
            .toList()
            .cast<RowContent>()));
    c.add(ListContent(
        'bibliografias',
        plano.bibliografias
            .map((obj) => TextContent('bibliografia', obj))
            .toList()
            .cast<Content>()));

    final outputData = await docx.generate(c);
    final diretorio = await getExternalStorageDirectory();
    final caminho = '${diretorio!.path}/plano_aula.docx';
    final outputFile = File(caminho);
    if (outputData != null) {
      await outputFile.writeAsBytes(outputData);
    } else {
      return false;
    }
    Share.shareFiles([caminho], text: 'Plano de Aula: ${plano.titulo}');
    return true;
  } else {
    return false;
  }
}
