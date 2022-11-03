import 'package:flutter/material.dart';
import 'package:health_app/viewscreen/create_account_screen.dart';
import 'package:health_app/viewscreen/home_screen.dart';
import 'package:health_app/viewscreen/login_screen.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const HealthApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirby Collects Your Health Data',
      initialRoute: LoginScreen.routeName,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: const Color(0xFFF8BBD0)),
      ),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
      },
    );
  }
}
