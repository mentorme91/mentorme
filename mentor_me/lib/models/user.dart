import 'request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? uid;
  String? email;
  // String? instituional_email_or_mat_num;
  String? first_name;
  String? last_name;
  String? school_id;
  String? faculty;
  String? department;
  int? year;
  String? _password;
  String? status;
  String? photoURL;
  String? about;
  Map<String, Timestamp?> connections = {};
  List<String> cancels = [];
  List<String> rejects = [];
  Map<String, Request> requests = {};

  // User constructor
  MyUser({
    this.uid,
    this.email,
    this.first_name,
    this.last_name,
    this.school_id,
    this.faculty,
    this.department,
    this.status,
    this.year,
    this.photoURL,
    this.about,
  });

  // get user password
  String? GetPassword() => _password;
  // set user password
  void SetPassword(String? pass) => _password = pass;

  // still to implement
  Map<String, dynamic> todict() {
    Map<String, dynamic> user_dict = {
      'uid': uid,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'school_id': school_id,
      'faculty': faculty,
      'department': department,
      'status': status,
      'year': year,
      'photoURL': photoURL,
      'connections': connections,
      'requests': requests,
      'cancels': cancels,
      'rejects': rejects,
    };
    return user_dict;
  }

  // get the string value of a MyUser class
  String toString() {
    return 'User($first_name $last_name, email: $email, school: $school_id, faculty: $faculty, department: $department)';
  }

  // update a [MyUser] class from an Authentication User class (from Firebase)
  void updateUserFromUser(MyUser user) {
    _password = user.GetPassword();
    uid = user.uid;
    first_name = user.first_name;
    last_name = user.last_name;
    email = user.email;
    school_id = user.school_id;
    faculty = user.faculty;
    department = user.department;
    status = user.status;
    year = user.year;
    photoURL = user.photoURL;
  }

  // update user object from a map
  void updateFromMap(Map studentData) {
    uid = studentData['uid'];
    email = studentData['email'];
    first_name = studentData['first_name'];
    last_name = studentData['last_name'];
    school_id = studentData['school_id'];
    faculty = studentData['faculty'];
    department = studentData['department'];
    status = studentData['status'];
    year = studentData['year'];
    photoURL = studentData['photoURL'];
    Map<String, dynamic> conns = studentData['connections'] ?? {};
    connections = conns.cast<String, Timestamp?>();
    List<dynamic> rejs = studentData['rejects'] ?? [];
    rejects = rejs.cast<String>();
    List<dynamic> cns = studentData['cancels'] ?? [];
    cancels = cns.cast<String>();
    Map<String, dynamic> reqs = studentData['requests'] ?? {};
    requests = reqs.map(
      (key, value) => MapEntry(
        key,
        Request(
          recieverUID: value['reciever'],
          senderUID: value['sender'],
          status: Status.values[value['status']],
        ),
      ),
    );
  }
}

// // creates a new [MyUser] object
MyUser newUser() {
  return MyUser(
    uid: '',
    email: '',
    first_name: '',
    last_name: '',
    school_id: '',
    faculty: '',
    department: '',
    status: '',
    year: 0,
  );
}
