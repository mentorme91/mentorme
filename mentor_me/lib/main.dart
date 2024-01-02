import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const Wrapper(),
      ),
    );
  }
}
