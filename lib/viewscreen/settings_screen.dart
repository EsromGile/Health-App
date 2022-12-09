import 'package:flutter/material.dart';
import 'package:health_app/controller/auth_controller.dart';
import 'package:health_app/controller/firebase_firestore_controller.dart';
import 'package:health_app/model/account_settings.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/viewscreen_models/settings_screen_model.dart';
import 'package:health_app/viewscreen/start_dispatcher.dart';
import 'package:health_app/viewscreen/view/kirby_loading.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

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
  late AccountSettings settings;
  var formKey = GlobalKey<FormState>();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    screenModel = SettingsScreenModel(user: Auth.user!);
    settings = AccountSettings();
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
          screenModel.editMode
              ? IconButton(onPressed: con.save, icon: const Icon(Icons.save))
              : IconButton(onPressed: con.edit, icon: const Icon(Icons.edit)),
        ],
      ),
      body:
          screenModel.isLoadingUnderway ? const KirbyLoading() : settingsForm(),
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
                        flex: 3,
                        child: Text('Cloud Upload Frequency'),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          value: con.state.settings.uploadRate,
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
                        flex: 3,
                        child: Text(
                          'Data Collection Frequency',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          value: con.state.settings.collectionFrequency,
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
    refresh();
  }
  void refresh() async {
    await getAccountSettings();
    state.render(() {});
  }

  void onChangedUploadFrequency(int? value) {
    if (value != null) state.settings.uploadRate = value;
  }

  void onChangedDataCollectionFrequency(int? value) {
    if (value != null) state.settings.collectionFrequency = value;
  }

  void edit() {
    state.render(() => state.screenModel.editMode = true);
  }

  void returnHome() {
    Navigator.pop(state.context);
    Navigator.pop(state.context);
    Navigator.pop(state.context);
    Navigator.pushNamed(state.context, StartDispatcher.routeName);
  }

  void save() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      Navigator.pop(state.context);
      return;
    }
    currentState.save();

    if (state.settings.docId == null) return;

    Map<String, dynamic> updateInfo = {};
    updateInfo[AccountSettings.COLLECTIONRATE] =
        state.settings.collectionFrequency;
    updateInfo[AccountSettings.UPLOADRATE] = state.settings.uploadRate;
    try {
      FirebaseFirestoreController.updateSettings(
          docId: state.settings.docId!, update: updateInfo);
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('++++ update settings error $e');
      showSnackBar(
          context: state.context,
          message: 'update settings error: $e',
          seconds: 10);
    }
    state.render(() {
      state.screenModel.editMode = false;
    });
  }

  Future<void> getAccountSettings() async {
    state.render(() => state.screenModel.isLoadingUnderway = true);

    try {
      state.settings = await FirebaseFirestoreController.getSettings(
          uid: state.screenModel.user.uid);
      state.render(() => state.screenModel.isLoadingUnderway = false);
    } catch (e) {
      state.render(() => state.screenModel.isLoadingUnderway = false);

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
