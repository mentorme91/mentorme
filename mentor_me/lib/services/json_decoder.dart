import 'dart:convert';
import 'package:flutter/services.dart';


// decodes json files
Future<Map<String, dynamic>> loadJsonData(String file) async {
  String jsonData = await rootBundle.loadString('assets/json/$file');
  return json.decode(jsonData);
}
