import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'screens/theme_provider.dart';
import 'services/auth_service.dart';
import 'screens/wrapper.dart';
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
    return StreamProvider<MyUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: ChangeNotifierProvider(
        create: (context) => MyThemeProvider(),
        child: MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const Wrapper(),
        ),
      ),
    );
  }
}
