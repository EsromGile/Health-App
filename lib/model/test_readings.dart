import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:health_app/model/accelerometer_reading.dart';

class TestReadings {
  static Future<List<AccelerometerReading>> loadExampleCSV() async {
    List<AccelerometerReading> data = [];
    try {
      final rawData = await rootBundle.loadString("files/example-data.csv");
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      for (int i = 0; i < listData.length; i++) {
        data.add(
          AccelerometerReading(
              timestamp:
                  DateTime.fromMillisecondsSinceEpoch(listData[i][3].toInt()),
              movementOccured: listData[i][7].toInt()),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print("======== unable to load csv: $e");
    }
    return data;
  }
}
