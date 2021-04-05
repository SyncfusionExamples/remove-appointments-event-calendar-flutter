import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(AppointmentRemove());

class AppointmentRemove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppointmentRemoveFromCalendar(),
    );
  }
}

class AppointmentRemoveFromCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

class ScheduleExample extends State<AppointmentRemoveFromCalendar> {
  List<Meeting> meetings = <Meeting>[];
  MeetingDataSource? events;
  Meeting? _selectedAppointment;

  @override
  void initState() {
    _selectedAppointment = null;
    meetings = <Meeting>[];
    events = _getCalendarDataSource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: 30,
            child: FlatButton(
              child: Text('Remove appointment'),
              onPressed: () {
                if (_selectedAppointment != null) {
                  events!.appointments.removeAt(
                      events!.appointments.indexOf(_selectedAppointment));
                  events!.notifyListeners(CalendarDataSourceAction.remove,
                      <Meeting>[]..add(_selectedAppointment!));
                }
              },
            ),
          ),
          Container(
            height: 500,
            child: SfCalendar(
              view: CalendarView.month,
              allowedViews: [
                CalendarView.day,
                CalendarView.week,
                CalendarView.workWeek,
                CalendarView.month,
                CalendarView.timelineDay,
                CalendarView.timelineWeek,
                CalendarView.timelineWorkWeek,
              ],
              initialSelectedDate: DateTime.now(),
              monthViewSettings: MonthViewSettings(showAgenda: true),
              dataSource: events,
              onTap: calendarTapped,
            ),
          ),
        ],
      ),
    ));
  }

  MeetingDataSource _getCalendarDataSource() {
    meetings.add(Meeting(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(hours: 1)),
      eventName: 'Meeting',
      background: Colors.pink,
      isAllDay: true,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 4, days: -1)),
      to: DateTime.now().add(const Duration(hours: 5, days: -1)),
      eventName: 'Release Meeting',
      background: Colors.lightBlueAccent,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 2, days: -2)),
      to: DateTime.now().add(const Duration(hours: 4, days: -2)),
      eventName: 'Performance check',
      background: Colors.amber,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 6, days: -3)),
      to: DateTime.now().add(const Duration(hours: 7, days: -3)),
      eventName: 'Support',
      background: Colors.green,
    ));
    meetings.add(Meeting(
      from: DateTime.now().add(const Duration(hours: 6, days: 2)),
      to: DateTime.now().add(const Duration(hours: 7, days: 2)),
      eventName: 'Retrospective',
      background: Colors.purple,
    ));
    return MeetingDataSource(meetings);
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.agenda ||
        calendarTapDetails.targetElement == CalendarElement.appointment) {
      final Meeting appointment = calendarTapDetails.appointments![0];
      _selectedAppointment = appointment;
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from!;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to!;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return source[index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return source[index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }
}

class Meeting {
  Meeting(
      {this.from,
      this.to,
      this.background = Colors.green,
      this.isAllDay = false,
      this.eventName = '',
      this.startTimeZone = '',
      this.endTimeZone = '',
      this.description = ''});

  final String eventName;
  final DateTime? from;
  final DateTime? to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
