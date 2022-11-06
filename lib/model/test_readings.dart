import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class TestReadings {
  late List<List<dynamic>> _listData;
  late List<double> timestamps;
  late List<int> isMoving;

  TestReadings();

  Future<void> loadExampleCSV() async {
    try {
      final rawData = await rootBundle.loadString("files/example-data.csv");
      _listData = const CsvToListConverter().convert(rawData);
      timestamps = [];
      isMoving = [];
      for (int i = 0; i < _listData.length; i++) {
        timestamps.add(_listData[i][3]);
        isMoving.add(_listData[i][7]);
      }
    } catch (e) {
      // ignore: avoid_print
      print("======== unable to load csv: $e");
    }
  }
}
