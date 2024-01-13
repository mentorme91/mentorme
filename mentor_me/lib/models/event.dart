import 'package:flutter/material.dart';

class Event {
  TimeOfDay? start, end;
  String information = '', title = '';

  Event({this.end, required this.information, required this.title, this.start});
}
