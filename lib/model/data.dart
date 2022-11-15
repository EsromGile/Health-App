import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/user_account.dart';

class MyData {
  Duration interval = const Duration(hours: 1);
  DateTime today;
  final UserAccount? user;
  late List<AccelerometerReading> readings;

  MyData({
    required this.user,
    required this.today,
  });

  void normalizeData() {
    // start with beginning of day
    DateTime current = today.add(interval);
    List<AccelerometerReading> normalizedReadings = [];
    int num = 0;
    // add up the 1's from every hour
    for (int i = 0;
        i < readings.length &&
            current.isBefore(current.add(const Duration(days: 1)));
        i++) {
      if (readings[i].timestamp.isBefore(current)) {
        num += readings[i].movementOccured;
      } else {
        normalizedReadings.add(
          AccelerometerReading(
              timestamp: current.subtract(interval), movementOccured: num),
        );
        current = current.add(interval);
        num = 0;
      }
    }
    readings = List.from(normalizedReadings);
    // display them on the graph
  }
}
