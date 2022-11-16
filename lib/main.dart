import 'package:flutter/material.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/viewscreen/create_account_screen.dart';
import 'package:health_app/viewscreen/error_screen.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_app/viewscreen/start_dispatcher.dart';
import 'package:health_app/viewscreen/view/view_util.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirby Collects Your Health Data',
      // initialRoute: HomeScreen.routeName,
      initialRoute: StartDispatcher.routeName,
      routes: {
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        SettingsScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return ErrorScreen('args is null for settings screen');
          } else {
            var arguments = args as Map;
            var settingsScreenModel = arguments[ArgKey.settingsScreenModel];
            return SettingsScreen(
              settingsScreenModel: settingsScreenModel,
            );
          }
        },
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
      },
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: const Color(0xFFF8BBD0)),
      ),
    );
  }
}
