import 'package:cloud_firestore/cloud_firestore.dart';

// custom [DocumentType] defines the various document types that can be uploaded in the document upload course resources page
enum DocumentType {
  pdf,
  doc,
  jpg,
}

// custom document class for course resource documents
class MyDocument {
  DocumentType? type;
  String? name, url;
  Timestamp? time;
  MyDocument({this.type, this.name, this.url, this.time});

  // update document object from a map
  void updateFromMap(Map<String, dynamic> map) {
    type = map['type'];
    name = map['name'];
    time = map['time'];
    url = map['url'];
  }
}
