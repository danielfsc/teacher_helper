import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';

class Event {
  final String title;
  final String descricao;
  final DateTime from;
  final DateTime to;
  final Color backgroundcolor;
  final bool isAllDay;

  const Event(
      {required this.title,
      required this.descricao,
      required this.from,
      required this.to,
      this.backgroundcolor = Colors.red,
      this.isAllDay = false});
}
