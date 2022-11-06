import 'package:health_app/model/data_storage.dart';

class AccelerometerReading {
  late DateTime timestamp;
  late double reading; // normalized reading: reading = (abs(sqrt(x^2 + y^2 + z^2) - 9.8) > 0.5) ? 1 : 0
  late String userId; // don't remember why this was necessary

  AccelerometerReading();
}
