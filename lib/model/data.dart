import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/user_account.dart';

class MyData {
  Duration interval = const Duration(minutes: 5);
  DateTime today;
  final UserAccount? user;
  late List<AccelerometerReading> readings;

  MyData({
    required this.user,
    required this.today,
  });

  // void normalizeData() {
  //   var current = today;
  //   List<AccelerometerReading> normalizedReadings = List.empty();
  //   for (var reading in readings) {
  //     AccelerometerReading temp =
  //         AccelerometerReading(timestamp: current, movementOccured: 0);
  //     while (today.isBefore(reading.timestamp)) {
  //       current = current.add(interval);
  //     }
  //   }
  // }
}
