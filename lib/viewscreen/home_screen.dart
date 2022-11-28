// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ffi';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controller/auth_controller.dart';
import 'package:health_app/controller/firebase_firestore_controller.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/data.dart';
import 'package:health_app/model/test_readings.dart';
import 'package:health_app/model/viewscreen_models/homescreen_model.dart';
import 'package:health_app/viewscreen/chart_builder.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:health_app/viewscreen/view/view_util.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../model/accelerometer_collect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late _Controller con;
  late HomeScreenModel screenModel;
  late Timer timer;
  StreamSubscription? accelSub;
  int count = 0;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    accelSub = accelerometerEvents.listen((event) {});
    screenModel = HomeScreenModel(user: Auth.user!);
    con.settingsCheck();
    con.loadData();
    screenModel.data?.initAccel();
    timer = Timer(const Duration(seconds: 5), startTimer);
  }

  @override
  Widget build(BuildContext context) {
    startTimer(); //figure out best way to use this

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
              accountEmail: Text(screenModel.user.email.toString()),
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
    if (screenModel.isLoaded) {
      return Column(
        children: [
          Text(
            screenModel.today.format("M d, Y"),
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: HorizontalBarLabelChart.fromData(screenModel.data!.readings),
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

  void startTimer() {
    try {
      AccelerometerEvent? accelEvent;
      accelSub = accelerometerEvents.listen((eve) {
        if (mounted) {
          setState(() {
            accelEvent = eve;
          });
        }
      });

      if (timer == null || !timer.isActive) {
        timer = Timer.periodic(const Duration(seconds: 10), (timer) {
          if (count > 3) {
            pauseTimer();
          } else {
            activeAccelerometer(accelEvent);
          }
        });
      }
    } catch (e) {
      print("ERROR: startTimer() ----- $e");
    }
  }

  Future<void> activeAccelerometer(AccelerometerEvent? eve) async {
    try {
      DateTime timestamp = DateTime.now();
      double? x = eve?.x;
      double? y = eve?.y;
      double? z = eve?.z;
      print("$timestamp: $x | $y | $z");
      AccelerometerCollect ac = AccelerometerCollect(
        uid: screenModel.user.uid,
        email: screenModel.user.email,
        timestamp: timestamp,
        x: x,
        y: y,
        z: z,
      );
      screenModel.data?.accelCollection.add(ac);

      String docID = await FirebaseFirestoreController.addAccelerometerData(
          accelCollect: ac);
      print(docID);

      count += 1;
    } catch (e) {
      print("ERROR: activeAccelerometer() ----- $e");
    }
  }

  void pauseTimer() {
    timer.cancel();
    accelSub?.pause();
    setState(() {
      count = 0;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    accelSub?.cancel();
    super.dispose();
  }
}

class _Controller {
  _HomeScreenState state;

  _Controller(this.state);

  Future<void> loadData() async {
    try {
      if (Constant.exampleData) {
        state.screenModel.data = TestReadings();
        state.screenModel.data!.readings = await TestReadings.loadExampleCSV();
        state.screenModel.data!.normalizeData();
        await Future.delayed(const Duration(seconds: 1));
        if (state.mounted) {
          state.render(() => state.screenModel.isLoaded = true);
        }
      } else {
        /*
          - this is where we would call the data down from firebase using 
              UserAccound getReadings() method
          - need to remove nullability from state.data after implementation
        */
        state.screenModel.data = null;
      }
    } catch (e) {
      print("======= couldn't load data: $e");
    }
  }

  void signOut() {
    Auth.signOut();
  }

  void settings() {
    Navigator.pushNamed(state.context, SettingsScreen.routeName);
  }

  Future<void> settingsCheck() async {
    try {
      //test if settings data exists. if not, create it
      var settingsExists = await FirebaseFirestoreController.checkSettings(
          uid: state.screenModel.user.uid);
      if (!settingsExists) {
        AccountSettings s = AccountSettings(uid: state.screenModel.user.uid);
        s.docId = await FirebaseFirestoreController.createSettings(settings: s);
      } else {
        print('settings exist already girl');
      }
    } catch (e) {
      if (Constant.devMode) print('++++ settings check/create error $e');
      showSnackBar(
          context: state.context, message: 'settings check/creation error $e');
    }
  }
}
