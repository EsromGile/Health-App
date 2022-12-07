import 'dart:async';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controller/auth_controller.dart';
import 'package:health_app/controller/firebase_firestore_controller.dart';
import 'package:health_app/model/accelerometer_collect.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/test_readings.dart';
import 'package:health_app/model/viewscreen_models/homescreen_model.dart';
import 'package:health_app/viewscreen/chart_builder.dart';
import 'package:health_app/viewscreen/settings_screen.dart';
import 'package:health_app/viewscreen/view/view_util.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
  late AccountSettings settings;
  int x = 0;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    screenModel = HomeScreenModel(user: Auth.user!);
    con = _Controller(this);

    con.addAccelerometerListener();
    con.settingsCheck();
    con.pullSettings();
    con.loadData();
    con.initAccel();
    con.initCollection();
    // con.uploadData();
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
          // Text('${settings.uploadRate}'),
          // Text('${settings.collectionFrequency}'),
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

  @override
  void dispose() {
    screenModel.timer!.cancel();
    screenModel.accelSub?.cancel();
    super.dispose();
  }
}

class _Controller {
  _HomeScreenState state;

  _Controller(this.state);

  Future<void> initCollection() async {
    int secondsCounter = 0;
    bool checkUpload = false; 

    state.screenModel.timer = Timer.periodic(
      // TO-DO: needs to be changed to grab duration from settings
      // ignore: prefer_const_constructors
      Duration(seconds: 1),
      (timer) {
        secondsCounter++;
        if ((secondsCounter % state.settings.collectionFrequency) == 0) {
          if (state.mounted) {
            state.render(() {
              DateTime time = DateTime.now();
              activeAccelerometer(time, state.screenModel.accelEvent);
            });
          }
          state.screenModel.accelSub!.resume();
        } else if ((secondsCounter == state.settings.collectionFrequency+1 && state.settings.uploadRate == 0) || secondsCounter == state.settings.uploadRate) {
          uploadData();
          checkUpload = true;
        }

        if (checkUpload == true) {
          secondsCounter = 0;
          checkUpload = false;
        }
      },
    );
  } 


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
      // ignore: avoid_print
      print("======= couldn't load data: $e");
    }
  }

  Future<void> settingsCheck() async {
    try {
      //test if settings data exists. if not, create it
      var settingsExists = await FirebaseFirestoreController.checkSettings(
          uid: state.screenModel.user.uid);
      if (!settingsExists) {
        AccountSettings s = AccountSettings(uid: state.screenModel.user.uid);
        s.docId = await FirebaseFirestoreController.createSettings(settings: s);
        state.settings = s;
      } else {
        // ignore: avoid_print
        print('settings exist already girl');
      }
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('++++ settings check/create error $e');
      showSnackBar(
          context: state.context, message: 'settings check/creation error $e');
    }
  }

  Future<void> pullSettings() async {
    try {
      state.settings = await FirebaseFirestoreController.getSettings(
          uid: state.screenModel.user.uid);
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('Account settings get Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Account settings get Error: $e',
        seconds: 5,
      );
      state.render({
      });
    }
  }

  void signOut() {
    Auth.signOut();
  }

  void settings() {
    Navigator.pushNamed(state.context, SettingsScreen.routeName);
  }

  void addAccelerometerListener() {
    state.screenModel.accelSub = userAccelerometerEvents.listen((event) {
      state.screenModel.accelEvent = event;
    });
  }

  void initAccel() {
    state.screenModel.data?.initAccel();
  }

  Future<void> activeAccelerometer(
      DateTime timestamp, UserAccelerometerEvent? eve) async {
    try {
     
      DateTime ts = timestamp;
      double? x = eve?.x;
      double? y = eve?.y;
      double? z = eve?.z;
      // ignore: avoid_print
      print("$ts: $x | $y | $z");
      AccelerometerCollect ac = AccelerometerCollect(
        uid: state.screenModel.user.uid,
        email: state.screenModel.user.email,
        timestamp: ts,
        x: x,
        y: y,
        z: z,
      );
      state.screenModel.data?.accelCollection.add(ac);

      state.screenModel.count += 1;
    } catch (e) {
      // ignore: avoid_print
      print("ERROR: activeAccelerometer() ----- $e");
    }
  }

  Future<void> uploadData() async {
   
    // state.screenModel.timer!.cancel();
    state.screenModel.accelSub!.pause();
    print("length: ${state.screenModel.data!.accelCollection.length}");
    for (var accel in state.screenModel.data!.accelCollection) {
      String docID = await FirebaseFirestoreController.addAccelerometerData(
          accelCollect: accel);
      // ignore: avoid_print
      print(docID);
    }
    state.screenModel.data!.accelCollection.clear();
   
  }
}
