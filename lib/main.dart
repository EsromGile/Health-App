import 'package:flutter/material.dart';
import 'package:health_app/viewscreen/create_account_screen.dart';
import 'package:health_app/viewscreen/display_screen.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_app/viewscreen/start_dispatcher.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirby Collects Your Health Data',
      initialRoute: StartDispatcher.routeName,
      routes: {
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        SettingsScreen.routeName:(context) => const SettingsScreen(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        DisplayScreen.routeName:(context) => const DisplayScreen(),
      },
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: const Color(0xFFF8BBD0)),
      ),
    );
  }
}
