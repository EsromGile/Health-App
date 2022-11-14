// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/test_readings.dart';
import 'package:health_app/viewscreen/chart_builder.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

import '../controller/firebase_authentication_controller.dart';
import '../model/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  static const routeName = "/startScreen";

  final User user;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late _Controller con;
  late List<AccelerometerReading> data;
  late DateTime today;
  bool isLoaded = false;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    // only added in development
    if (Constant.devMode) {
      con.loadCSV();
      today = DateTime(2021, 6, 29);
    } else {
      // To be determined
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kirby Collects Your Health Data"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const Icon(
                Icons.person,
                size: 70,
              ),
              accountName: const Text('No Profile'),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: con.settings,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: con.signOut,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: viewGraphs(),
          ),
        ),
      ),
    );
  }

  Widget viewGraphs() {
    if (isLoaded) {
      return Column(
        children: [
          Text(
            today.format("M d, Y"),
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: HorizontalBarLabelChart.fromData(data),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            "images/Kirby_Loading_Message.png",
            height: 300,
          ),
        ],
      );
    }
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);

  Future<void> loadCSV() async {
    try {
      state.data = await TestReadings.loadExampleCSV();
      await Future.delayed(const Duration(seconds: 1));
      if (state.mounted) {
        state.render(() => state.isLoaded = true);
      }
    } catch (e) {
      if (Constant.devMode) {
        // ignore: avoid_print
        print("======= couldn't load csv: $e");
      }
    }
  }
  
  Future<void> signOut() async {
    try {
      await FirebaseAuthenticationController.signOut();
    } catch (e) {
      if (Constant.devMode) print('Sign Out Error: $e');
      showSnackBar(context: state.context, message: 'Sign Out Error: $e');
    }

    if (state.mounted) {
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
    }
  }
  

  void settings() {
    Navigator.pushNamed(state.context, SettingsScreen.routeName, arguments: {
      ArgKey.user: state.widget.user,
    });
  }
}
