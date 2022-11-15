import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/model/data.dart';

class HomeScreenModel {
  User user;
  MyData? data;
  DateTime today = DateTime.now();
  bool isLoaded = false;

  HomeScreenModel({required this.user});
}
