import 'package:health_app/model/user_account.dart';

class AccountSettings {
  final UserAccount user;
  int uploadRate = 30;          // every 30 minutes
  int collectionFrequency = 5;  // every 5 minutes 
  bool isDarMode = true;        //😎

  AccountSettings({required this.user});
}
