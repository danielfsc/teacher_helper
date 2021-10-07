import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';

class DarkModeWidget extends StatefulWidget {
  const DarkModeWidget({Key? key}) : super(key: key);

  @override
  State<DarkModeWidget> createState() => _DarkModeWidgetState();
}

class _DarkModeWidgetState extends State<DarkModeWidget> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: AppController.instance.isDark,
      title: const Text("Modo Escuro"),
      onChanged: (value) {
        setState(() {
          AppController.instance.changeTheme();
        });
      },
    );
  }
}
