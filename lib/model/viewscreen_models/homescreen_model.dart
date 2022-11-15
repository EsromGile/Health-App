import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/model/data.dart';

class HomeScreenModel {
  User user;
  MyData? data;
  late DateTime today;
  bool isLoaded = false;

  HomeScreenModel({required this.user}) {
    today = DateTime.now();
    today = DateTime(today.year, today.month, today.month);
  }
}
