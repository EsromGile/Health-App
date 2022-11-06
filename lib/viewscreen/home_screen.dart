import 'package:flutter/material.dart';
import 'package:health_app/model/test_readings.dart';

import '../model/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = "/startScreen";

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late _Controller con;
  late TestReadings exampledata;
  bool isLoaded = false;

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    // only added in development
    if (Constant.devMode) {
      exampledata = TestReadings();
      con.loadCSV();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kirby Collects Your Health Data"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //   const Text("This Screen Should: "),
              //   const Text(" - Display user information and data"),
              //   const Text(" - Display accomplishments with goal"),
              //   SizedBox(
              //     width: 200,
              //     child: Image.asset("images/kirby-succs.png"),
              //   ),
              //   OutlinedButton(onPressed: (() => startKirbyLoading(context)), child: const Text('Start Loading')),
              if (Constant.devMode && isLoaded == true) 
                renderExampleData()
            ],
          ),
        ),
      ),
    );
  }

  Widget renderExampleData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < exampledata.timestamps.length; i++)
            Row(
              children: [
                Text("Timestamp: ${DateTime.fromMillisecondsSinceEpoch(exampledata.timestamps[i].toInt())}"),
                Text("Movement: ${exampledata.isMoving[i]}"),
              ],
            ),
        ],
      ),
    );
  }
}

class _Controller {
  _HomeScreenState state;
  _Controller(this.state);

  Future<void> loadCSV() async {
    try {
      await state.exampledata.loadExampleCSV();
      if (state.mounted) {
      }
      state.render(() => state.isLoaded = true);
    } catch (e) {
      if (Constant.devMode) {
        // ignore: avoid_print
        print("======= couldn't load csv: $e");
      }
    }
  }
}
