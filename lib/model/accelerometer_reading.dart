import '../controller/auth_controller.dart';

enum DocKeyAccelData {
  email,
  x,
  y,
  z,
  timestamp,
}

class AccelerometerReading {
  String? docID;
  String? email;
  late DateTime? timestamp;
  late double? x;
  late double? y;
  late double? z;
  String? uid;
  // late DateTime timestamp;
  late int
      movementOccured; // normalized reading: reading = (abs(sqrt(x^2 + y^2 + z^2) - 9.8) > 0.5) ? 1 : 0

  AccelerometerReading(
      {required this.timestamp, required this.movementOccured});

  AccelerometerReading.collection(
      {this.docID,
      this.uid,
      required this.email,
      required this.timestamp,
      required this.x,
      required this.y,
      required this.z});

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyAccelData.email.name: email,
      DocKeyAccelData.timestamp.name: timestamp,
      DocKeyAccelData.x.name: x,
      DocKeyAccelData.y.name: y,
      DocKeyAccelData.z.name: z,
    };
  }

  factory AccelerometerReading.fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docID}) {
    return AccelerometerReading.collection(
      docID: docID,
      uid: Auth.user!.uid,
      email: doc[DocKeyAccelData.email.name] ??= '',
      x: doc[DocKeyAccelData.x.name] ??= '',
      y: doc[DocKeyAccelData.y.name] ??= '',
      z: doc[DocKeyAccelData.z.name] ??= '',
      timestamp: doc[DocKeyAccelData.timestamp.name] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              doc[DocKeyAccelData.timestamp.name].millisecondsSinceEpoch,
            )
          : null,
    );
  }

  bool isValid() {
    if (email!.isEmpty ||
        timestamp == null ||
        x == null ||
        y == null ||
        z == null) {
      return false;
    } else {
      return true;
    }
  }
}
