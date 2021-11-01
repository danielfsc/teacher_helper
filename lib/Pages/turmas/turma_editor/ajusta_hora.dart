import 'package:flutter/material.dart';

class AjustaHora extends StatefulWidget {
  const AjustaHora({
    Key? key,
    required this.title,
    required this.onChange,
    this.time,
  }) : super(key: key);

  final TimeOfDay? time;
  final Function(TimeOfDay) onChange;
  final String title;

  @override
  _AjustaHoraState createState() => _AjustaHoraState();
}

class _AjustaHoraState extends State<AjustaHora> {
  TimeOfDay? time;

  @override
  void initState() {
    time = widget.time;
    super.initState();
  }

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
          child: Text('${time!.hour}:${fixMinute(time!.minute)}'),
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
      initialTime: time!,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != time) {
      setState(() {
        time = timeOfDay;
      });
      widget.onChange(time!);
    }
  }
}

String fixMinute(int value) {
  return value >= 10 ? '$value' : '0$value';
}
