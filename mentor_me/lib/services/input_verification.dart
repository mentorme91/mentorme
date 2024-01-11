// validates password typed in
import '../models/user.dart';

String? validatePassword(String? pass) {
  return (pass != '') ? null : 'Enter a valid password';
}

// validates inout text
String? validateText(String? pass, String errorValue) {
  return (pass != '') ? null : errorValue;
}

// initializes the password of a user
void initPassword(MyUser u) {
  u.SetPassword('');
}
