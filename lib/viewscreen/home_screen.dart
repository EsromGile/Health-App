import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:health_app/model/test_readings.dart';
import 'package:health_app/model/viewscreen_models/homescreen_model.dart';
import 'package:health_app/model/viewscreen_models/settings_screen_model.dart';
import 'package:health_app/viewscreen/chart_builder.dart';
import 'package:health_app/viewscreen/settings_screen.dart';

import '../controller/auth_controller.dart';
import '../controller/firebase_firestore_controller.dart';
import '../model/account_settings.dart';
import '../model/constant.dart';
import 'view/view_util.dart';

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

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = HomeScreenModel(user: Auth.user!);
    con.settingsCheck();
    con.loadData();
    // if (Constant.devMode) {
    //   screenModel.today = DateTime(2021, 6, 29);
    // }
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
              // accountEmail: Text(widget.user.email!),
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
      // ignore: avoid_print
      print("======= couldn't load data: $e");
    }
  }

  void signOut() {
    Auth.signOut();
  }

  void settings() {
    SettingsScreenModel settingsScreenModel = SettingsScreenModel(user: state.screenModel.user);
    Navigator.pushNamed(state.context, SettingsScreen.routeName);
  }

  Future<void> settingsCheck() async{
    try {
      //test if settings data exists. if not, create it
      var settingsExists =
          await FirebaseFirestoreController.checkSettings(uid: state.screenModel.user.uid);
      if (!settingsExists) {
        AccountSettings s = AccountSettings(uid: state.screenModel.user.uid);
        s.docId = await FirebaseFirestoreController.createSettings(settings: s);
      }
      else {
        print('settings exist already girl');
      }
    } catch (e) {
      if (Constant.devMode) print('++++ settings check/create error $e');
      showSnackBar(context: state.context, message: 'settings check/creation error $e');
    }
  }
}
