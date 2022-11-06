class AccelerometerReading {
  late DateTime timestamp;
  late int
      movementOccured; // normalized reading: reading = (abs(sqrt(x^2 + y^2 + z^2) - 9.8) > 0.5) ? 1 : 0

  AccelerometerReading(
      {required this.timestamp, required this.movementOccured});

}
