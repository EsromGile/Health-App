
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/data_storage.dart';

class UserAccount {
  late final DataStorage storage;
  late final AccountSettings settings;
  late String email;

  UserAccount({required this.email}) {
    storage = DataStorage(user: this);
    settings = AccountSettings(user: this);
  }
}
