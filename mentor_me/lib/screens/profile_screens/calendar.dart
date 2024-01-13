import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_planner/time_planner.dart';

import '../../models/event.dart';
import '../theme_provider.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1,
        (index) => Event(title: 'Event $item | ${index + 1}', information: ''))
}..addAll({
    kToday: [
      Event(title: 'Today\'s Event 1', information: ''),
      Event(title: 'Today\'s Event 2', information: ''),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class UserCalendarThemeLoader extends StatefulWidget {
  const UserCalendarThemeLoader({super.key});

  @override
  State<UserCalendarThemeLoader> createState() =>
      _UserCalendarThemeLoaderState();
}

class _UserCalendarThemeLoaderState extends State<UserCalendarThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(data: theme, child: TableEventsExample());
  }
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
    Event newEvent = Event(title: '', information: '');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return CustomBottomSheetContent(
              event: newEvent, day: day, events: events);
        });
      },
    );
    setState(() {});
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

  List<Widget> dayEvents = [];
  void _displayEvents(DateTime day) {
    if (events[day] == null) {
      events[day] = [];
    }
    events[day]?.sort((event1, event2) => _isEarlier(
        event1.start ?? TimeOfDay.now(), event2.start ?? TimeOfDay.now()));
    dayEvents =
        events[day]?.map((event) => buildEventListTile(event)).toList() ?? [];
  }

  DateTime today = DateTime.now();
  DateTime? focusedDay;
  CalendarFormat format = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(today),
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
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(
                        0, 3), // changes the position of the shadow
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

class CoursePlanner extends StatefulWidget {
  const CoursePlanner({super.key});
  @override
  State<CoursePlanner> createState() => _CoursePlannerState();
}

class _CoursePlannerState extends State<CoursePlanner> {
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

class CustomBottomSheetContent extends StatefulWidget {
  final Event event;
  final DateTime day;
  final Map<DateTime, List<Event>> events;
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
              if (widget.events[widget.day] == null) {
                widget.events[widget.day] = [];
              }
              widget.events[widget.day]?.add(widget.event);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Submit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
