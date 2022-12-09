// ignore_for_file: constant_identifier_names
enum DocKeyAccountSettings { docId, user, uid, uploadRate, collectionFrequency }

class AccountSettings {
  String? docId; //firestore generated id
  late String uid;
  late int uploadRate; // every 30 minutes
  late int collectionFrequency; // every 5 minutes

  static const UID = 'uid';
  static const UPLOADRATE = 'uploadRate';
  static const COLLECTIONRATE = 'collectionFrequency';

  AccountSettings({
    this.docId,
    this.uid = '',
    this.uploadRate = 0,
    this.collectionFrequency = 15,
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
      collectionFrequency:
          doc[DocKeyAccountSettings.collectionFrequency.name] ?? 'N/A',
    );
  }
}

Map<String, int> dataCollectionFrequency = {
  //in seconds
  "15 Seconds": 15,
  "30 seconds": 30,
  "1 minute": 60,
  "2 minutes": 120,
};

Map<String, int> uploadFrequency = {
  // in seconds
  "Immediately": 0, // 0 minutes
  "30 seconds": 30,
  "1.5 minute": 90, // 1 minute
  "15 minutes": 900, //15 minutes
  "30 minutes": 1800, //30 minutes
  "1 hour": 3600, //60 minutes
};