import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class PlannerTask {
  int day = 0, hour = 0, minutes = 0, hoursDuration = 0, minutesDuration = 0;
  String course = '';
  PlannerTask(
      {this.day = 0,
      this.hour = 0,
      this.minutes = 0,
      this.hoursDuration = 0,
      this.minutesDuration = 0});

  TimePlannerDateTime toTimePlannerDateTime() {
    return TimePlannerDateTime(day: day, hour: hour + 1, minutes: minutes);
  }

  TimePlannerTask toTimePlannerTask({Color? color, Function? onTap}) {
    return TimePlannerTask(
      minutesDuration: (hoursDuration * 60) + minutesDuration,
      dateTime: toTimePlannerDateTime(),
      child: Text(course),
      onTap: () => onTap!(this),
      color: color,
    );
  }

  void updateFromTimePlannerTask(TimePlannerTask task) {
    day = task.dateTime.day;
    hour = task.dateTime.hour;
    minutes = task.dateTime.minutes;
    hoursDuration = (task.minutesDuration / 60).floor();
    minutesDuration = task.minutesDuration - (hoursDuration * 60);
  }

  Map<String, dynamic> ToMap() {
    return {
      'day': day,
      'hour': hour,
      'minutes': minutes,
      'hoursDuration': hoursDuration,
      'minutesDuration': minutesDuration,
      'course': course
    };
  }

  void updateFromMap(Map<String, dynamic> map) {
    day = map['day'] ?? 0;
    hour = map['hour'] ?? 0;
    minutes = map['minutes'] ?? 0;
    hoursDuration = map['hoursDuration'] ?? 0;
    minutesDuration = map['minutesDuration'] ?? 0;
    course = map['course'] ?? '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlannerTask &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          hour == other.hour &&
          minutes == other.minutes &&
          hoursDuration == other.hoursDuration &&
          minutesDuration == other.minutesDuration;

  @override
  int get hashCode =>
      course.hashCode ^
      day.hashCode ^
      hour.hashCode ^
      minutes.hashCode ^
      hoursDuration.hashCode ^
      minutesDuration.hashCode;
}
