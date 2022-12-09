import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/model/accelerometer_reading.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/user_account.dart';

class FirebaseFirestoreController {
  final UserAccount
      account; /* we need both settings and data storage 
                               might as well make it easy on ourselves*/
  FirebaseFirestoreController({required this.account});

  // pass updates from user settings to cloud
  // pass new readings from data storage to cloud

  static Future<bool> checkSettings({required String uid}) async {
    var reference = await FirebaseFirestore.instance
        .collection(Constant.settingsCollection)
        .where('uid', isEqualTo: uid)
        .get();
    if (reference.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> createSettings(
      {required AccountSettings settings}) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.settingsCollection)
        .add(settings.toFirestoreDoc());
    return ref.id;
  }

  static Future<AccountSettings> getSettings({required String uid}) async {
    var reference = await FirebaseFirestore.instance
        .collection(Constant.settingsCollection)
        .where('uid', isEqualTo: uid)
        .get();
    var document = reference.docs[0].data();
    var s = AccountSettings.fromFirestoreDoc(
        doc: document, docId: reference.docs[0].id);
    if (s != null) {
      return s;
    } else {
      return AccountSettings();
    }
  }

  static Future<void> updateSettings(
      {required String docId, required Map<String, dynamic> update}) async {
    await FirebaseFirestore.instance
        .collection(Constant.settingsCollection)
        .doc(docId)
        .update(update);
  }

  static Future<String> addAccelerometerData(
      {required AccelerometerReading accelCollect}) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.accelerometerDataCollection)
        .add(accelCollect.toFirestoreDoc());
    // print("${ref.id}");

    return ref.id;
  }

  static Future<List<AccelerometerReading>> getAccelerometerList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.accelerometerDataCollection)
        .where(DocKeyAccelData.email.name, isEqualTo: email)
        .orderBy(DocKeyAccelData.timestamp.name, descending: true)
        .get();
    var result = <AccelerometerReading>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p =
            AccelerometerReading.fromFirestoreDoc(doc: document, docID: doc.id);
        if (p.isValid()) result.add(p);
      }
    }
    return result;
  }
}
