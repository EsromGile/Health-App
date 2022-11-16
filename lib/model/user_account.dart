import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/data.dart';
import 'package:health_app/model/data_storage.dart';
import 'package:health_app/model/test_readings.dart';

class UserAccount {
  late final MyData storage;
  late final AccountSettings settings;
  late String email;

  UserAccount({required this.email}) {
    if (Constant.exampleData) {
      storage = TestReadings();
    } else {
      storage = DataStorage(user: this, today: DateTime.now());
    }
    settings = AccountSettings();
  }

  List<AccelerometerReading> getReadings() {
    //get readings from DB
    return List.empty();
  }
}
