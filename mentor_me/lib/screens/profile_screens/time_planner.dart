import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';

import '../theme_provider.dart';

class CoursePlannerThemeLoader extends StatefulWidget {
  const CoursePlannerThemeLoader({super.key});

  @override
  State<CoursePlannerThemeLoader> createState() =>
      _CoursePlannerThemeLoaderState();
}

class _CoursePlannerThemeLoaderState extends State<CoursePlannerThemeLoader> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<MyThemeProvider>(context).theme;
    return Theme(
      data: theme,
      child: CoursePlanner(),
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
      // color: Colors.amber,
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
          title: Text('My Schedule'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
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
            cellHeight: 40,
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
