
// custom notification
class MyNotification {
  int id = 0;
  String? title, body, payload;
  MyNotification({this.id = 0, this.title, this.body, this.payload});

  // convert notification to map
  Map toMap() {
    return {
      'id': 0,
      'title': title,
      'body': body,
      'payload': payload,
    };
  }
}
