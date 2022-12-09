import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/model/accelerometer_reading.dart';

class DisplayScreenModel{
  User user;
  List<AccelerometerReading>? accelerometerList;
  String? loadingErrorMessage;

  DisplayScreenModel({required this.user});
}