import 'package:flutter/material.dart';
import 'package:health_app/controller/firebase_firestore_controller.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/user_account.dart';
import 'package:health_app/model/viewscreen_models/settings_screen_model.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

import '../controller/auth_controller.dart';
import '../model/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = "/settingsScreen";

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late _Controller con;
  late SettingsScreenModel screenModel;
  var formKey = GlobalKey<FormState>();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = SettingsScreenModel(user: Auth.user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: con.returnHome,
        ),
        title: const Text("Settings"),
        actions: [
          screenModel.editMode
              ? IconButton(onPressed: con.save, icon: const Icon(Icons.save))
              : IconButton(onPressed: con.edit, icon: const Icon(Icons.edit)),
        ],
      ),
      body: settingsForm(),
    );
  }

  Widget settingsForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(Icons.cloud_upload),
                      ),
                      const Expanded(
                        flex: 4,
                        child: Text('Cloud Upload Frequency'),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          items: [
                            for (var i in uploadFrequency.entries)
                              DropdownMenuItem(
                                value: i.value,
                                child: Text(i.key),
                              )
                          ],
                          onChanged: screenModel.editMode
                              ? con.onChangedUploadFrequency
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(Icons.timeline),
                      ),
                      const Expanded(
                        flex: 4,
                        child: Text('Data Collection Frequency'),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          items: [
                            for (var i in dataCollectionFrequency.entries)
                              DropdownMenuItem(
                                value: i.value,
                                child: Text(i.key),
                              )
                          ],
                          onChanged: screenModel.editMode
                              ? con.onChangedDataCollectionFrequency
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _SettingsScreenState state;
  _Controller(this.state) {
    /*
      bug...*wagging finger*
    */
    // refresh();
  }
  late AccountSettings settings;
  /*
      bug...*wagging finger*
    */
  // void refresh() {
  //   state.render(getAccountSettings());
  // }

  void returnHome() {
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
  }

  void onChangedUploadFrequency(int? value) {}

  void onChangedDataCollectionFrequency(int? value) {}

  void edit() {
    state.render(() => state.screenModel.editMode = true);
  }

  void save() {
    state.render(() => state.screenModel.editMode = false);
  }

  void getAccountSettings() async {
    try {
      settings = await FirebaseFirestoreController.getSettings(
          uid: state.screenModel.user.uid);
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('Account settings get Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Account settings get Error: $e',
        seconds: 5,
      );
    }
  }
}
