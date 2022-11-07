// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/test_readings.dart';
import 'package:health_app/viewscreen/chart_builder.dart';
import 'package:date_time_format/date_time_format.dart';


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
}
