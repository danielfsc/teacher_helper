import 'package:flutter/material.dart';

Widget viewBox(context, {required String title, required String text}) {
  return borderBox(context, child: titleText(title, text));
}

Widget titleText(String title, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      boldText(title),
      Text(text),
    ],
  );
}

Widget boldText(String? text) {
  return Text(
    '$text',
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );
}

Widget space(double space) {
  return SizedBox(
    height: space,
  );
}

List<Widget> symbolList(List lista, {String? previousText}) {
  return lista.map((e) {
    return Text('${previousText ?? ''} $e');
  }).toList();
}

List<Widget> numeratedList(List lista) {
  return lista.map((e) {
    var index = lista.indexOf(e) + 1;
    return Text('$index- $e');
  }).toList();
}

Widget borderListBox(context, {String? title, required List<Widget> lista}) {
  return borderBox(context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldText(title),
          space(8),
          ...lista,
        ],
      ));
}

Widget borderBox(context, {required Widget child}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.height,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    ),
  );
}
