import 'package:health_app/model/data.dart';

class DataStorage extends MyData {

  DataStorage({required user, required today}) : super(user: user, today: today) {
    readings = user.getReadings();
  }
  
}
