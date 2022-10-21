import 'package:health_app/model/user_account.dart';

class FirebaseFirestoreController {
  final UserAccount account; /* we need both settings and data storage 
                               might as well make it easy on ourselves*/
  FirebaseFirestoreController({required this.account});

  // pass updates from user settings to cloud
  // pass new readings from data storage to cloud
}
