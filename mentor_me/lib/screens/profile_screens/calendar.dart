import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../theme_provider.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UserCalendarThemeLoader extends StatefulWidget {
  final MyUser user;
  const UserCalendarThemeLoader({super.key, required this.user});

  @override
  State<UserCalendarThemeLoader> createState() =>
      _UserCalendarThemeLoaderState();
}

class _UserCalendarThemeLoaderState extends State<UserCalendarThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
        data: theme,
        child: UserCalendar(
          user: widget.user,
        ));
  }
}

class UserCalendar extends StatefulWidget {
  final MyUser user;
  const UserCalendar({super.key, required this.user});

  @override
  State<UserCalendar> createState() => _UserCalendarState();
}

class _UserCalendarState extends State<UserCalendar> {
  Map<String, List<Event>> events = {};
  List<Event> daysEvents = [];
  late ValueNotifier<List<Widget>> dayEvents = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
  }

  List<Event> _eventsOf(DateTime day) {
    return events[DateFormat('yyyy-MM-dd').format(day)] ?? [];
  }

  void _setDaysEvents(DateTime day) {
    daysEvents = _eventsOf(day);
  }

  Future _addEvent(DateTime day) async {
    Event newEvent = Event(
        title: '',
        information: '',
        start: TimeOfDay.now(),
        end: TimeOfDay.now());
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return CustomBottomSheetContent(
              event: newEvent, day: day, events: events);
        });
      },
    );
  }

  Widget buildEventListTile(Event event) {
    return ListTile(
      title: Text(event.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Start Time: ${event.start?.format(context) ?? TimeOfDay.now().format(context)}'),
          Text(
              'End Time: ${event.end?.format(context) ?? TimeOfDay.now().format(context)}'),
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

  Widget Calendar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.background,
          width: 0.2,
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TableCalendar(
        calendarFormat: format,
        onFormatChanged: (tappedFormat) {
          setState(() {
            format = tappedFormat;
          });
        },
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay ?? today,
        // currentDay: DateTime.now(),
        // enabledDayPredicate: (day) => day == today,
        selectedDayPredicate: (day) => day == today,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            today = selectedDay;
            _setDaysEvents(selectedDay);
          });
        },
        eventLoader: (day) => _eventsOf(day),
      ),
    );
  }

  DateTime today = DateTime.now();
  DateTime? focusedDay;
  CalendarFormat format = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addEvent(today);
          print('here');
          print(events);
          setState(() {
            DatabaseService(uid: widget.user.uid).addEvent(
              events.map(
                (key, value) => MapEntry(
                  key,
                  value.map(
                    (event) => event.toMap(),
                  ),
                ),
              ),
            );
          });
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'My Calendar',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            SingleChildScrollView(
              child: FutureBuilder<Map<String, List<Event>>>(
                future: DatabaseService(uid: user?.uid).getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        Calendar(),
                        Text('Loading...'),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        Calendar(),
                        Text('Future Error: ${snapshot.error}'),
                      ],
                    );
                  } else {
                    events = snapshot.data ?? {};
                    _setDaysEvents(today);
                    return Column(
                      children: [Calendar()] +
                          daysEvents
                              .map((event) => buildEventListTile(event))
                              .toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomSheetContent extends StatefulWidget {
  final Event event;
  final DateTime day;
  final Map<String, List<Event>> events;
  const CustomBottomSheetContent(
      {super.key,
      required this.event,
      required this.day,
      required this.events});

  @override
  State<CustomBottomSheetContent> createState() =>
      _CustomBottomSheetContentState();
}

class _CustomBottomSheetContentState extends State<CustomBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: Text('Add Event'),
        content: Column(
          children: [
            ListTile(
              title: Text('Start Time'),
              subtitle: TextField(
                enabled: false,
                decoration: InputDecoration(
                    hintText: widget.event.start?.format(context) ??
                        TimeOfDay.now().format(context),
                    hintStyle: TextStyle()),
              ),
              // subtitle: Text(newEvent.start?.format(context) ??
              //     TimeOfDay.now().format(context)),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: widget.event.start ?? TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() {
                    widget.event.start = selectedTime;
                  });
                }
                setState(() {
                  print('Refreshed');
                });
              },
            ),
            ListTile(
              title: Text('End Time'),
              subtitle: TextField(
                enabled: false,
                decoration: InputDecoration(
                    hintText: widget.event.end?.format(context) ??
                        TimeOfDay.now().format(context),
                    hintStyle: TextStyle()),
              ),
              // subtitle: Text(newEvent.end?.format(context) ??
              //     TimeOfDay.now().format(context)),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: widget.event.end ?? TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() {
                    widget.event.end = selectedTime;
                  });
                }
                setState(() {
                  print('Refreshed');
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Event Information'),
              onChanged: (value) {
                setState(() {
                  widget.event.information = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  widget.event.title = value;
                });
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (widget.events[DateFormat('yyyy-MM-dd').format(widget.day)] ==
                  null) {
                widget.events[DateFormat('yyyy-MM-dd').format(widget.day)] = [];
              }
              widget.events[DateFormat('yyyy-MM-dd').format(widget.day)]!
                  .add(widget.event);
              // widget.events.addAll({
              //   widget.day: [widget.event]
              // });
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Submit'),
          ),
          ElevatedButton(
            onPressed: () {
              print(widget.event.start);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
