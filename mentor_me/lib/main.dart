import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_provider.dart';
import 'models/user.dart';
import 'models/language_constants.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  int nate = 0;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  // This widget is the root of this application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: AuthService()
          .user, // provides a user stream which tracks updates in our user credentials
      initialData: null,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(
            create: (context) => MyThemeProvider(),
          ),
        ],
        child: MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
          home:
              const Wrapper(), // it decides whether to show the authentication screen or user dashboard
        ),
      ),
    );
  }
}
