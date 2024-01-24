// custom enum [Status] manages the status of connect requests
enum Status {
  pending,
  connected,
  rejected,
  canceled,
  none,
}

// custom request for connect requests sent and recieved
class Request {
  String? senderUID, recieverUID;
  Status status;
  Request(
      {required this.recieverUID,
      required this.senderUID,
      required this.status});

  // convert request object to map
  Map<String, dynamic> toMap() {
    return {
      'sender': senderUID,
      'reciever': recieverUID,
      'status': status.index,
    };
  }
}
