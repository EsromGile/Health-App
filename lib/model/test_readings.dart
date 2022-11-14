import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:health_app/model/accelerometer_reading.dart';

class TestReadings {
  static Future<List<AccelerometerReading>> loadExampleCSV() async {
    Duration interval = const Duration(hours: 1);
    DateTime current = DateTime(2021, 6, 29, 0);

    List<AccelerometerReading> data = [];
    try {
      final rawData = await rootBundle.loadString("files/example-data.csv");
      List<List<dynamic>> listData =
          const CsvToListConverter().convert(rawData);

      // add some buffer time
      var start = DateTime.fromMillisecondsSinceEpoch(listData[0][3].toInt());
      while (current.isBefore(start)) {
        data.add(AccelerometerReading(timestamp: current, movementOccured: 0));
        current = current.add(interval);
      }

      // add the timestamps from csv
      for (int i = 0; i < listData.length; i++) {
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(listData[i][3].toInt());
        data.add(
          AccelerometerReading(
              timestamp: time, movementOccured: listData[i][7].toInt()),
        );
      }
      var end = DateTime(2021, 6, 30);
      while (current.isBefore(end)) {
        data.add(AccelerometerReading(timestamp: current, movementOccured: 0));
        current = current.add(interval);
      }
    } catch (e) {
      // ignore: avoid_print
      print("======== unable to load csv: $e");
    }
    return data;
  }
}