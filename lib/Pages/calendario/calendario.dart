import 'package:flutter/material.dart';
import 'package:teacher_helper/Pages/calendario/eventos.dart';
import 'package:teacher_helper/shared/page_mask.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarioPage extends StatelessWidget {
  const CalendarioPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageMask( 
      title: 'Calendário',
    
      /*body: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: ()=>Navigator.of(context).push(
            MaterialPageRoute(builder:(context) => EventEditingPage()),
          ),

        ),*/
      body: SfCalendar(
        view:CalendarView.month,
        showNavigationArrow: true,
        firstDayOfWeek: 1,
        initialDisplayDate: DateTime.now(),
        initialSelectedDate: DateTime.now(),
        cellBorderColor: Colors.red,
        //backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        todayHighlightColor: Colors.red,
        dataSource: MeetingDataSource(getAppointments()),
      ),
    );
     
   
    }
}

class EventEditingPage {
}
