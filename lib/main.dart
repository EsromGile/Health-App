import 'package:flutter/material.dart';
import 'package:health_app/viewscreen/home_screen.dart';
import 'package:health_app/viewscreen/login_screen.dart';
import 'package:health_app/viewscreen/settings_screen.dart';

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName:(context) => const HomeScreen(),
        LoginScreen.routeName:(context) => const LoginScreen(),
        SettingsScreen.routeName:(context) => const SettingsScreen(),
      },
    );
  }
}
