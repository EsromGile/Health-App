import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/model/data.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeScreenModel {
  User user;
  MyData? data;
  late DateTime today;
  Timer? timer;
  bool isLoaded = false;
  StreamSubscription? accelSub;
  AccelerometerEvent? accelEvent;
  int count = 0;

  HomeScreenModel({required this.user}) {
    today = DateTime.now();
    today = DateTime(today.year, today.month, today.month);
  }
}
