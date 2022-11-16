import 'package:flutter/material.dart';
import 'package:health_app/controller/firebase_firestore_controller.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/user_account.dart';
import 'package:health_app/model/viewscreen_models/settings_screen_model.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

import '../controller/auth_controller.dart';
import '../model/constant.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.settingsScreenModel }) : super(key: key);

  static const routeName = "/settingsScreen";
  final SettingsScreenModel settingsScreenModel;

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
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
          widget.settingsScreenModel.editMode
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
                          value: con.settings.uploadRate,
                          items: [
                            for (var i in uploadFrequency.entries)
                              DropdownMenuItem(
                                value: i.value,
                                child: Text(i.key),
                              )
                          ],
                          onChanged: widget.settingsScreenModel.editMode
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
                          value: con.settings.collectionFrequency,
                          items: [
                            for (var i in dataCollectionFrequency.entries)
                              DropdownMenuItem(
                                value: i.value,
                                child: Text(i.key),
                              )
                          ],
                          onChanged: widget.settingsScreenModel.editMode
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
    refresh();
  }
 AccountSettings settings = AccountSettings();
  /*
      bug...*wagging finger*
    */
  void refresh() async{
    await getAccountSettings();
    state.render(() => {});
  }

  void returnHome() {
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
  }

  void onChangedUploadFrequency(int? value) {
    if (value != null) settings.uploadRate = value;
  }

  void onChangedDataCollectionFrequency(int? value) {
    if (value != null) settings.collectionFrequency = value;
  }

  void edit() {
    state.render(() => state.widget.settingsScreenModel.editMode = true);
  }

  void save() async{

    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      Navigator.pop(state.context);
      return;
    }
    currentState.save();

    if (settings.docId == null) return;

    Map<String, dynamic> updateInfo = {};
    updateInfo[AccountSettings.COLLECTIONRATE] = settings.collectionFrequency;
    updateInfo[AccountSettings.UPLOADRATE] = settings.uploadRate;
    try {
      FirebaseFirestoreController.updateSettings(docId: settings.docId!, update: updateInfo);
    } catch (e) {
      if (Constant.devMode) print('++++ update settings error $e');
      showSnackBar(context: state.context, message: 'update settings error: $e', seconds: 10);
    }
    state.render(() {
      state.widget.settingsScreenModel.editMode = false;
    });
  }

  Future<void> getAccountSettings() async {
    try {
      settings = await FirebaseFirestoreController.getSettings(
          uid: state.widget.settingsScreenModel.user.uid);
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
