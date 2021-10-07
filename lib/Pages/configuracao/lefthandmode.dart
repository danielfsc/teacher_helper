import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';

class LeftHandedMode extends StatefulWidget {
  const LeftHandedMode({Key? key}) : super(key: key);

  @override
  State<LeftHandedMode> createState() => _LeftHandedModeState();
}

class _LeftHandedModeState extends State<LeftHandedMode> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: AppController.instance.isLeftHanded,
      title: const Text('Canhoto'),
      onChanged: (value) {
        setState(() {
          AppController.instance.changeHand();
        });
      },
    );
  }
}
