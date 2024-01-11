enum Status {
  pending,
  connected,
  rejected,
  canceled,
  none,
}

class Request {
  String? senderUID, recieverUID;
  Status status;
  Request(
      {required this.recieverUID,
      required this.senderUID,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'sender': senderUID,
      'reciever': recieverUID,
      'status': status.index,
    };
  }
}
