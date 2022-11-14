import 'package:flutter/material.dart';
import 'package:health_app/viewscreen/create_account_screen.dart';
import 'package:health_app/viewscreen/error_screen.dart';
import 'package:health_app/viewscreen/home_screen.dart';
import 'package:health_app/viewscreen/login_screen.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirby Collects Your Health Data',
      // initialRoute: HomeScreen.routeName,
      initialRoute: LoginScreen.routeName,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: const Color(0xFFF8BBD0)),
      ),
      routes: {
        HomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if(args == null) {
            return const ErrorScreen('args is null for HomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return HomeScreen(user: user,);
          }
        },
        LoginScreen.routeName: (context) => const LoginScreen(),
        SettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if(args == null) {
            return const ErrorScreen('args is null for SettingsScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            return SettingsScreen(user: user,);
          }
        },
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
      },
    );
  }
}
