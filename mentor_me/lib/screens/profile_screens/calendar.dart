import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_planner/time_planner.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Event {
  TimeOfDay start = TimeOfDay.now(), end = TimeOfDay.now();
  String information = '', title = '';
}

class UserCalendar extends StatefulWidget {
  const UserCalendar({super.key});

  @override
  State<UserCalendar> createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  Map<DateTime, List<Event>> events = {};

  List<Event> _eventsOf(DateTime day) {
    return events[day] ?? [];
  }

  void _addEvent(DateTime day) {
    Event newEvent = Event();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add Event'),
            content: Column(
              children: [
                ListTile(
                  title: Text('Start Time'),
                  subtitle: Text(newEvent.start.format(context)),
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: newEvent.start,
                    );
                    if (selectedTime != null) {
                      setState(() {
                        newEvent.start = selectedTime;
                      });
                    }
                  },
                ),
                ListTile(
                  title: Text('End Time'),
                  subtitle: Text(newEvent.end.format(context)),
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: newEvent.end,
                    );
                    if (selectedTime != null) {
                      setState(() {
                        newEvent.end = selectedTime;
                        print(newEvent.end.format(context));
                      });
                    }
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Event Information'),
                  onChanged: (value) {
                    setState(() {
                      newEvent.information = value;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    setState(() {
                      newEvent.title = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (events[day] == null) {
                    events[day] = [];
                  }
                  events[day]?.add(newEvent);
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildEventListTile(Event event) {
    return ListTile(
      title: Text(event.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start Time: ${event.start.format(context)}'),
          Text('End Time: ${event.end.format(context)}'),
          Text('Information: ${event.information}'),
        ],
      ),
    );
  }

  int _isEarlier(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return 1;
    } else if (time1.hour == time2.hour) {
      return time1.minute < time2.minute ? 1 : 0;
    }
    return 0;
  }

  List<Widget> dayEvents = [];
  void _displayEvents(DateTime day) {
    if (events[day] == null) {
      events[day] = [];
    }
    events[day]
        ?.sort((event1, event2) => _isEarlier(event1.start, event2.start));
    dayEvents =
        events[day]?.map((event) => buildEventListTile(event)).toList() ?? [];
  }

  DateTime today = DateTime.now();
  DateTime? focusedDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(today),
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: focusedDay ?? today,
                // currentDay: DateTime.now(),
                // enabledDayPredicate: (day) => day == today,
                selectedDayPredicate: (day) => day == today,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    today = selectedDay;
                    _displayEvents(today);
                  });
                },
                eventLoader: (day) => _eventsOf(today),
              ),
            ),
            SingleChildScrollView(
              child: Column(children: dayEvents),
            )
          ],
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
