import 'package:flutter/material.dart';
import 'package:health_app/viewscreen/start_screen.dart';

void main() {
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StartScreen.routeName,
      routes: {
        StartScreen.routeName:(context) => const StartScreen(),
      },
    );
  }
}
