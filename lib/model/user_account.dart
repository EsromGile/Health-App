
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/data_storage.dart';

class UserAccount {
  late final DataStorage storage;
  late final AccountSettings settings;
  late String email;

  UserAccount({required this.email}) {
    storage = DataStorage(user: this);
    settings = AccountSettings();
  }
}

// enum DataCollectionFrequency {
//   thirtySeconds, oneMinute, twoMinutes
// }

// enum UploadFrequency {
//   daily, threeHours, twelveHours, onLogin
// }

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