import 'package:flutter/material.dart';

class Event {
  TimeOfDay? start, end;
  String information = '', title = '';

  Event({this.end, required this.information, required this.title, this.start});

  Map<String, dynamic> toMap() {
    return {
      'start': convertTimeOfDayToInt(start),
      'end': convertTimeOfDayToInt(end),
      'info': information,
      'title': title,
    };
  }

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

int convertTimeOfDayToInt(TimeOfDay? time) {
  if (time == null) return 0;
  return (time.hour * 60) + time.minute;
}
