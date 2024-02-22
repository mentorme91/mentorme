import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multiselect/multiselect.dart';
import 'package:time_planner/time_planner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../models/planner_task.dart';
import '../../../../models/user.dart';
import '../../../../services/database_service.dart';
import '../../../../theme_provider.dart';

Color _generateRandomColor() {
  Random random = Random();
  int r = random.nextInt(256);
  int g = random.nextInt(256);
  int b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late double screenHeight;

  void _addSchedule() async {
    List<PlannerTask> newTasks = await _getSchedule();
    tasks.addAll(newTasks);
    await _setTasksInDataBase(widget.user);
    setState(() {});
  }

  Future _deleteTask(PlannerTask task) async {
    List toBeDeleted = [];
    for (var thisTask in tasks) {
      if (thisTask.course == task.course) {
        toBeDeleted.add(thisTask);
      }
    }
    for (var t in toBeDeleted) {
      tasks.remove(t);
    }
    await _setTasksInDataBase(widget.user);
    setState(() {
      print('task deleted!');
    });
  }

  void _showTask(PlannerTask task) async {
    List<PlannerTask> toBeShown = [];
    for (var thisTask in tasks) {
      if (thisTask.course == task.course) {
        toBeShown.add(thisTask);
      }
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                '${toBeShown[0].course} ${AppLocalizations.of(context)!.schedule2}'),
            content: SizedBox(
              height: 300,
              child: Column(
                children: toBeShown
                    .map((task) => Column(children: [
                          Center(
                              child: Text(
                            daysToInt.keys.toList()[task.day],
                          )),
                          Center(
                            child: Text(
                                '${task.getStartTimeFormatted()} - ${task.getEndTimeFormatted()}'),
                          )
                        ]))
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.close)),
              TextButton(
                onPressed: () async {
                  await _deleteTask(toBeShown[0]);
                  await _setTasksInDataBase(widget.user);
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    await _deleteTask(toBeShown[0]);
                    List<PlannerTask> newTask =
                        await _getSchedule(old: toBeShown);
                    tasks.addAll(newTask);
                    await _setTasksInDataBase(widget.user);
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.edit)),
            ],
            actionsAlignment: MainAxisAlignment.center,
            alignment: Alignment.centerRight,
          );
        });
      },
    );

    setState(() {});
  }

  Future _setTasksInDataBase(MyUser? user) async {
    Map<String, List<Map<String, dynamic>>> map = {
      AppLocalizations.of(context)!.task:
          tasks.map((task) => task.toMap()).toList()
    };
    await DatabaseService(uid: user?.uid).setTasks(map);
  }

  Future<List<PlannerTask>> _getSchedule({List<PlannerTask>? old}) async {
    List<PlannerTask> oldTask;
    List<PlannerTask> task = [];
    if (old != null) {
      oldTask = old;
    } else {
      oldTask = [];
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return CustomDialogForTaskInput(
            tasks: task,
            oldTasks: oldTask,
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
        title: Text(
          AppLocalizations.of(context)!.schedule,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSchedule(),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: DatabaseService(uid: user?.uid).getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(AppLocalizations.of(context)!.load);
          } else if (snapshot.hasError) {
            return Text('Future Error: ${snapshot.error}');
          }
          tasks = snapshot.data!
              .map((task) =>
                  PlannerTask()..updateFromMap(task as Map<String, dynamic>))
              .toList();
          return TimePlanner(
            startHour: 6,
            endHour: 23,
            headers: [
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.monday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.tuesday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.wednesday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.thursday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.friday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.saturday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.saturday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
              TimePlannerTitle(
                title: AppLocalizations.of(context)!.sunday,
                titleStyle: const TextStyle(fontSize: 10),
              ),
            ],
            tasks: tasks
                .map((task) => task.toTimePlannerTask(onTap: _showTask))
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
  final List<PlannerTask> tasks;
  final List<PlannerTask> oldTasks;
  const CustomDialogForTaskInput({
    super.key,
    required this.tasks,
    this.oldTasks = const [],
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

    if (widget.oldTasks.isNotEmpty) {
      selectedDays = widget.oldTasks.map((task) => allDays[task.day]).toList();
      startTime = widget.oldTasks[0].getStartTime();
      endTime = widget.oldTasks[0].getEndTime();
      courseName = widget.oldTasks[0].course;
    } else {
      selectedDays = [];
      startTime = TimeOfDay.now();
      endTime = TimeOfDay.now();
      courseName = '';
    }
    print(selectedDays);

    _controller = TextEditingController(text: courseName);
  }

  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late List<String> selectedDays;
  late String courseName;
  List<String> allDays = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
      title: Text('Dropdown Form'),
      content: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Course Name'),
              onChanged: (value) {
                setState(() {
                  courseName = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text('Days'),
            DropDownMultiSelect(
                options: allDays,
                selectedValues: selectedDays,
                onChanged: (selectedValues) => selectedDays = selectedValues),
            ListTile(
              title: Text('Start Time'),
              subtitle: TextField(
                enabled: false,
                decoration: InputDecoration(
                    hintText: startTime.format(context),
                    hintStyle: TextStyle()),
              ),
              // subtitle: Text(newEvent.start?.format(context) ??
              //     TimeOfDay.now().format(context)),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: startTime,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: false),
                      child: child!,
                    );
                  },
                );
                if (selectedTime != null) {
                  setState(() {
                    startTime = selectedTime;
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
                    hintText: endTime.format(context), hintStyle: TextStyle()),
              ),
              // subtitle: Text(newEvent.end?.format(context) ??
              //     TimeOfDay.now().format(context)),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: endTime,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: false),
                      child: child!,
                    );
                  },
                );
                if (selectedTime != null) {
                  setState(() {
                    endTime = selectedTime;
                  });
                }
                setState(() {
                  print('Refreshed');
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
            Color color = _generateRandomColor();
            for (var day in selectedDays) {
              PlannerTask task = PlannerTask();
              task.course = courseName;
              task.day = allDays.indexOf(day);
              task.color = color;
              task.updateFromStartAndEndTime(startTime, endTime);
              widget.tasks.add(task);
            }

            Navigator.of(context).pop();
          },
          child: Text('Submit'),
        ),
      ],
    ));
  }
}
