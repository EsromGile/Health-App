import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreenModel {
  User user;
  bool editMode = false;

  SettingsScreenModel({required this.user});
}
