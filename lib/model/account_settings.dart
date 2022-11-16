import 'package:health_app/model/user_account.dart';
enum DocKeyAccountSettings {
  docId,
  user,
  uid,
  uploadRate,
  collectionFrequency
}
class AccountSettings {
  String? docId; //firestore generated id
  late String uid;
  late int uploadRate;          // every 30 minutes
  late int collectionFrequency;  // every 5 minutes 

  static const UID = 'uid';
  static const UPLOADRATE = 'uploadRate';
  static const COLLECTIONRATE = 'collectionFrequency';

  AccountSettings({
    this.docId,
    this.uid = '',
    this.uploadRate = 30,
    this.collectionFrequency = 5,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyAccountSettings.uid.name: uid,
      DocKeyAccountSettings.uploadRate.name: uploadRate,
      DocKeyAccountSettings.collectionFrequency.name: collectionFrequency,
    };
  }

  static AccountSettings? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    return AccountSettings(
      docId: docId,
      uid: doc[DocKeyAccountSettings.uid.name] ?? 'N/A',
      uploadRate: doc[DocKeyAccountSettings.uploadRate.name] ?? 'N/A',
      collectionFrequency: doc[DocKeyAccountSettings.collectionFrequency.name] ?? 'N/A',
    );
  }
}

Map<String, int> dataCollectionFrequency = {
      "30 Seconds": 30,
      "1 minute": 1,
      "2 minutes": 2,
    };

    Map<String, int> uploadFrequency = {
      "Daily": 24,
      "3 Hours": 3,
      "12 hours": 12,
      "On Login": 1,
    };


