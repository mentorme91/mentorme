import 'package:flutter/material.dart';

// custom calendar event class
class Event {
  TimeOfDay? start, end;
  String information = '', title = '';

  Event({this.end, required this.information, required this.title, this.start});

  // converts an event to a map to be stored in firebase
  Map<String, dynamic> toMap() {
    return {
      'start': convertTimeOfDayToInt(start),
      'end': convertTimeOfDayToInt(end),
      'info': information,
      'title': title,
    };
  }

  // compares two event classes
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          information == other.information &&
          title == other.title;

  @override
  int get hashCode =>
      start.hashCode ^ end.hashCode ^ information.hashCode ^ title.hashCode;

  // update event class from a map
  void updateFromMap(Map<String, dynamic> map) {
    start = convertFromIntToTimeOfDay(map['start']);
    end = convertFromIntToTimeOfDay(map['end']);
    title = map['title'];
    information = map['info'];
  }
}

TimeOfDay convertFromIntToTimeOfDay(int timeAsInt) {
  // Convert integer back to TimeOfDay
  int hours = (timeAsInt ~/ 60) % 24;
  int minutes = timeAsInt % 60;
  return TimeOfDay(hour: hours, minute: minutes);
}

// converts a TimeOfDay object to integer
int convertTimeOfDayToInt(TimeOfDay? time) {
  if (time == null) return 0;
  return (time.hour * 60) + time.minute;
}
