import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/user_account.dart';

class DataStorage {
  final UserAccount user;
  late List<AccelerometerReading> readings;

  DataStorage({required this.user}) {
    readings = List.empty();
  }

  // calculate most active time period in a given range
}
