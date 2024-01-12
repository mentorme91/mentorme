import 'package:flutter/material.dart';

// CreateDropDown: Used to create a custom dropdown from a list of items
List<DropdownMenuItem> createDropDown(List<String> items) {
  return items
      .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
            ),
          ))
      .toList();
}

// produceList: Generates list of keys from a dictionary
List<String> produceList(Map<String, dynamic> m) {
  List<String> l = [];
  m.forEach((key, value) {
    l.add(key);
  });
  return l;
}
