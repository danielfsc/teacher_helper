// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AjustaHora extends StatefulWidget {
  AjustaHora({
    Key? key,
    required this.title,
    required this.onChange,
    this.time,
  }) : super(key: key);

  TimeOfDay? time;
  final Function(TimeOfDay) onChange;
  final String title;

  @override
  _AjustaHoraState createState() => _AjustaHoraState();
}

class _AjustaHoraState extends State<AjustaHora> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: 70,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Text('${widget.time!.hour}:${fixMinute(widget.time!.minute)}'),
        ),
      ),
      onTap: () {
        _selectTime(context);
      },
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: widget.time!,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != widget.time) {
      setState(() {
        widget.time = timeOfDay;
      });
      widget.onChange(widget.time!);
    }
  }
}

String fixMinute(int value) {
  return value >= 10 ? '$value' : '0$value';
}
