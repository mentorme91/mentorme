import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadJsonData(String file) async {
  String jsonData = await rootBundle.loadString('assets/json/$file');
  return json.decode(jsonData);
}
