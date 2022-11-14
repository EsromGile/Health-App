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
  late UserAccount user;
  late String uid;
  late int uploadRate;          // every 30 minutes
  late int collectionFrequency;  // every 5 minutes 

  AccountSettings({
    required this.user,
    this.docId,
    this.uid = '',
    this.uploadRate = 30,
    this.collectionFrequency = 5,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyAccountSettings.user.name: user,
      DocKeyAccountSettings.docId.name: docId,
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
      user: doc[DocKeyAccountSettings.user.name] ?? 'N/A',
      uid: doc[DocKeyAccountSettings.uid.name] ?? 'N/A',
      uploadRate: doc[DocKeyAccountSettings.uploadRate.name] ?? 'N/A',
      collectionFrequency: doc[DocKeyAccountSettings.collectionFrequency.name] ?? 'N/A',
    );
  }
}
