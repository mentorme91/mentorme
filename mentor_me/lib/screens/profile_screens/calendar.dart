import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_planner/time_planner.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserCalendar extends StatefulWidget {
  const UserCalendar({super.key});

  @override
  State<UserCalendar> createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: today,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              today = selectedDay;
            });
          },
        ),
      ),
    );
  }
}

class Courses extends StatefulWidget {
  const Courses({super.key});
  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  List<TimePlannerTask> tasks = [
    TimePlannerTask(
      color: Colors.amber,
      minutesDuration: 90,
      dateTime: TimePlannerDateTime(day: 2, hour: 15, minutes: 00),
      onTap: () {
        print("Hit!");
      },
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MentorMee'),
        ),
        body: TimePlanner(
          startHour: 5,
          endHour: 23,
          headers: const [
            TimePlannerTitle(
              title: 'Monday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Tuesday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Wednesday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Thursday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Friday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Saturday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Saturday',
              titleStyle: TextStyle(fontSize: 10),
            ),
            TimePlannerTitle(
              title: 'Sunday',
              titleStyle: TextStyle(fontSize: 10),
            ),
          ],
          tasks: tasks,
          style: TimePlannerStyle(
            backgroundColor: Colors.white,
            // default value for height is 80
            cellHeight: 60,
            // default value for width is 90
            cellWidth: 60,
            dividerColor: Colors.grey,
            showScrollBar: true,
            horizontalTaskPadding: 5,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ));
  }
}
