import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/user_account.dart';

import '../model/account_settings.dart';

class FirebaseFirestoreController {
  final UserAccount account; /* we need both settings and data storage 
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

  static Future<void> createSettings({required AccountSettings settings}) async {
    await FirebaseFirestore.instance
        .collection(Constant.settingsCollection).add(settings.toFirestoreDoc());
  }

  static Future<AccountSettings> getSettings({required String uid}) async {
    var reference = await FirebaseFirestore.instance
        .collection(Constant.settingsCollection)
        .where('uid', isEqualTo: uid)
        .get();
    var document = reference.docs[0].data();
    var s = AccountSettings.fromFirestoreDoc(doc: document, docId: reference.docs[0].id);
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
}
