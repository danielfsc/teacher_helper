import 'package:flutter/material.dart';

class OpcaoMenu {
  final IconData icon;
  final String title;
  final String route;
  final bool active;
  final Color color;

  OpcaoMenu(this.icon, this.title, this.route, this.active, this.color);
}

class IconMenu {
  final String value;
  final IconData icon;
  final bool isPrivate;

  IconMenu(
    this.value,
    this.icon, {
    this.isPrivate = true,
  });
}
