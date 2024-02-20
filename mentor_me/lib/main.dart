import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/user.dart';
import 'theme_provider.dart';
import 'services/auth_service.dart';
import 'screens/wrapper.dart';
import 'firebase_options.dart';
import 'themes.dart';
import 'services/notification_service.dart';

void main() async {
  // initialize WidgetsFlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  // initialize custom notifications service
  await NotificationService().initNotifications();

  // initialize firebase app for database manipulations
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
      value: AuthService()
          .user, // provides a user stream which tracks updates in our user credentials
      initialData: null,
      child: ChangeNotifierProvider(
        create: (context) =>
            MyThemeProvider(), // provides our theme so it can be accesses from other pages through the BuildContext
        child: MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home:
              const Wrapper(), // it decides whether to show the authentication screen or user dashboard
        ),
      ),
    );
  }
}
