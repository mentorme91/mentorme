import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

// custom task for user's schedule
class PlannerTask {
  int day = 0, hour = 0, minutes = 0, hoursDuration = 0, minutesDuration = 0;
  String course = '';
  Color? color;
  PlannerTask(
      {this.day = 0,
      this.hour = 0,
      this.minutes = 0,
      this.hoursDuration = 0,
      this.minutesDuration = 0});

  // get the TimePlannerDateTime from task
  TimePlannerDateTime toTimePlannerDateTime() {
    return TimePlannerDateTime(day: day, hour: hour + 1, minutes: minutes);
  }

  // convert custom class to a TimePlannerTask
  TimePlannerTask toTimePlannerTask({Function? onTap}) {
    return TimePlannerTask(
      minutesDuration: (hoursDuration * 60) + minutesDuration,
      dateTime: toTimePlannerDateTime(),
      child: Center(child: Text(course, style: TextStyle(fontSize: 12),)),
      onTap: () => onTap!(this),
      color: color,
    );
  }

  // Function to get startTime in "hour:minute AM/PM" format
  String getStartTimeFormatted() {
    return _formatTime(hour, minutes);
  }

  // Function to get endTime in "hour:minute AM/PM" format
  String getEndTimeFormatted() {
    int totalStartMinutes = hour * 60 + minutes;
    int totalDurationInMinutes = hoursDuration * 60 + minutesDuration;
    int totalEndMinutes = totalStartMinutes + totalDurationInMinutes;

    int endHour = (totalEndMinutes / 60).floor();
    int endMinute = totalEndMinutes % 60;

    return _formatTime(endHour, endMinute);
  }

  TimeOfDay getStartTime() {
    return TimeOfDay(hour: hour, minute: minutes);
  }

  TimeOfDay getEndTime() {
    int totalStartMinutes = hour * 60 + minutes;
    int totalDurationInMinutes = hoursDuration * 60 + minutesDuration;
    int totalEndMinutes = totalStartMinutes + totalDurationInMinutes;

    int endHour = (totalEndMinutes / 60).floor();
    int endMinute = totalEndMinutes % 60;

    return TimeOfDay(hour: endHour, minute: endMinute);
  }

  // Internal function to format hour and minute as "hour:minute AM/PM"
  String _formatTime(int hour, int minute) {
    String period = (hour >= 12) ? 'PM' : 'AM';
    hour = (hour > 12) ? hour - 12 : hour;
    hour = (hour == 0) ? 12 : hour;

    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }

  // update task from a TimePlannerTask
  void updateFromTimePlannerTask(TimePlannerTask task) {
    day = task.dateTime.day;
    hour = task.dateTime.hour;
    minutes = task.dateTime.minutes;
    hoursDuration = (task.minutesDuration / 60).floor();
    minutesDuration = task.minutesDuration - (hoursDuration * 60);
  }

  String? colorToHex() {
  if (color == null) {
    return null;
  }
  return '#${color?.value.toRadixString(16).padLeft(8, '0')}';
}

Color? hexToColor(String? hex) {
  if (hex != null) {
return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
  }
  return null;
}
  // get the map representation of task
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'hour': hour,
      'minutes': minutes,
      'hoursDuration': hoursDuration,
      'minutesDuration': minutesDuration,
      'course': course,
      'color': colorToHex(),
    };
  }

  // update task from a map
  void updateFromMap(Map<String, dynamic> map) {
    day = map['day'] ?? 0;
    hour = map['hour'] ?? 0;
    minutes = map['minutes'] ?? 0;
    hoursDuration = map['hoursDuration'] ?? 0;
    minutesDuration = map['minutesDuration'] ?? 0;
    course = map['course'] ?? '';
    color = hexToColor(map['color']);
  }

  // Create a PlannerTask from startTime and endTime
  void updateFromStartAndEndTime(TimeOfDay startTime, TimeOfDay endTime) {
    final int startMinutes = startTime.hour * 60 + startTime.minute;
    final int endMinutes = endTime.hour * 60 + endTime.minute;
    final int totalDurationInMinutes = endMinutes - startMinutes;
    hour = startTime.hour;
    minutes = startTime.minute;
    hoursDuration = (totalDurationInMinutes / 60).floor();
    minutesDuration = totalDurationInMinutes % 60;
  }

  // compares two tasks (==)
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
