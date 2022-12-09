import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:health_app/model/accelerometer_reading.dart';
import 'package:date_time_format/date_time_format.dart';


class HorizontalBarLabelChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate = false;

  const HorizontalBarLabelChart(this.seriesList, {super.key});

  /// Creates a [BarChart] with sample data.
  factory HorizontalBarLabelChart.fromData(List<AccelerometerReading> data) {
    return HorizontalBarLabelChart(
      _generateUsingData(data),
    );
  }
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
          const charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }

  /// Create one series using data.
  static List<charts.Series<AccelerometerReading, String>> _generateUsingData(List<AccelerometerReading> data) {
    return [
      charts.Series<AccelerometerReading, String>(
          id: 'Sales',
          domainFn: (AccelerometerReading reading, _) => reading.timestamp!.format("g:i a").toString(),
          measureFn: (AccelerometerReading reading, _) => reading.movementOccured,
          data: data,
      )
    ];
  }
}