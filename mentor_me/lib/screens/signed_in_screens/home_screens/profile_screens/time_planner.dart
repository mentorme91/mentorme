import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mentor_me/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';

import '../../../../models/planner_task.dart';
import '../../../../models/user.dart';
import '../../../../theme_provider.dart';

class CoursePlannerThemeLoader extends StatefulWidget {
  final MyUser user;
  const CoursePlannerThemeLoader({super.key, required this.user});

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
      child: CoursePlanner(
        user: widget.user,
      ),
    );
  }
}

class CoursePlanner extends StatefulWidget {
  final MyUser user;
  const CoursePlanner({super.key, required this.user});
  @override
  State<CoursePlanner> createState() => _CoursePlannerState();
}

class _CoursePlannerState extends State<CoursePlanner> {
  var daysToInt = {
    'Monday': 0,
    'Tuesday': 1,
    'Wednesday': 2,
    'Thursday': 3,
    'Friday': 4,
    'Saturday': 5,
    'Sunday': 6,
  };
  Color _generateRandomColor() {
    Random random = Random();
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    return Color.fromARGB(255, r, g, b);
  }

  void _addSchedule() async {
    PlannerTask task = await _getSchedule();
    tasks.add(task);
    await _setTasksInDataBase(widget.user);
    setState(() {});
  }

  void _deleteTask(PlannerTask task) async {
    tasks.remove(task);
    await _setTasksInDataBase(widget.user);
    setState(() {});
  }

  Future _setTasksInDataBase(MyUser? user) async {
    Map<String, List<Map<String, dynamic>>> map = {
      'tasks': tasks.map((task) => task.ToMap()).toList()
    };
    await DatabaseService(uid: user?.uid).setTasks(map);
  }

  Future<PlannerTask> _getSchedule({PlannerTask? old}) async {
    PlannerTask task;
    if (old != null) {
      task = old;
    } else {
      task = PlannerTask();
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return CustomDialogForTaskInput(
            task: task,
          );
        });
      },
    );
    return task;
  }

  List<PlannerTask> tasks = [];
  @override
  Widget build(BuildContext context) {
    final MyUser? user = Provider.of<MyUser?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Schedule'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSchedule(),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: DatabaseService(uid: user?.uid).getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          } else if (snapshot.hasError) {
            return Text('Future Error: ${snapshot.error}');
          }
          tasks = snapshot.data!
              .map((task) =>
                  PlannerTask()..updateFromMap(task as Map<String, dynamic>))
              .toList();
          return TimePlanner(
            startHour: 0,
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
            tasks: tasks
                .map((task) => task.toTimePlannerTask(
                    color: _generateRandomColor(), onTap: _deleteTask))
                .toList(),
            style: TimePlannerStyle(
              // default value for height is 80
              cellHeight: 40,
              // default value for width is 90
              cellWidth: 60,
              dividerColor: Theme.of(context).colorScheme.onPrimary,
              showScrollBar: true,
              horizontalTaskPadding: 5,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          );
        },
      ),
    );
  }
}

class CustomDialogForTaskInput extends StatefulWidget {
  final PlannerTask task;
  const CustomDialogForTaskInput({
    super.key,
    required this.task,
  });

  @override
  State<CustomDialogForTaskInput> createState() =>
      _CustomDialogForTaskInputState();
}

class _CustomDialogForTaskInputState extends State<CustomDialogForTaskInput> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.course);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
      title: Text('Dropdown Form'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownField(
              label: 'Day',
              items: const [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ],
              task: widget.task,
            ),
            DropdownField(
                label: 'Hour',
                items: List.generate(24, (index) => index.toString()),
                task: widget.task),
            DropdownField(
                label: 'Minute',
                items: List.generate(60, (index) => index.toString()),
                task: widget.task),
            DropdownField(
                label: 'Hour Duration',
                items: List.generate(24, (index) => index.toString()),
                task: widget.task),
            DropdownField(
                label: 'Minute Duration',
                items: List.generate(60, (index) => index.toString()),
                task: widget.task),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Course Name'),
              onChanged: (value) {
                setState(() {
                  widget.task.course = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle form submission
            // You can access the selected values from the DropdownFields here
            Navigator.of(context).pop();
          },
          child: Text('Submit'),
        ),
      ],
    ));
  }
}

class DropdownField extends StatefulWidget {
  final String label;
  final List<String> items;
  final PlannerTask task;

  DropdownField({required this.label, required this.items, required this.task});

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  var dayToInt = {
    'Monday': 0,
    'Tuesday': 1,
    'Wednesday': 2,
    'Thursday': 3,
    'Friday': 4,
    'Saturday': 5,
    'Sunday': 6,
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          DropdownButtonFormField<String>(
            value: widget.items[0],
            onChanged: (value) {
              setState(() {
                switch (widget.label) {
                  case 'Day':
                    widget.task.day = dayToInt[value] ?? 0;
                    break;
                  case 'Hour':
                    widget.task.hour = int.parse(value ?? '0');
                    break;
                  case 'Minute':
                    widget.task.minutes = int.parse(value ?? '0');
                    break;
                  case 'Hour Duration':
                    widget.task.hoursDuration = int.parse(value ?? '0');
                    break;
                  case 'Minute Duration':
                    widget.task.minutesDuration = int.parse(value ?? '0');
                    break;
                  default:
                    print('Label error');
                }
              });
            },
            items: widget.items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
