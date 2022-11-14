import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/model/user_account.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.user, Key? key}) : super(key: key);

  static const routeName = "/settingsScreen";

  final User user;

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();
  bool editMode = false;

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
          editMode
              ? IconButton(onPressed: con.save, icon: const Icon(Icons.save))
              : IconButton(onPressed: con.edit, icon: const Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
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
                            flex: 1, child: Icon(Icons.cloud_upload)),
                        const Expanded(
                            flex: 4, child: Text('Cloud Upload Frequency')),
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
                            onChanged:
                                editMode ? con.onChangedUploadFrequency : null,
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
                        const Expanded(flex: 1, child: Icon(Icons.timeline)),
                        const Expanded(
                            flex: 4, child: Text('Data Collection Frequency')),
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
                            onChanged: editMode
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
      ),
    );
  }
}

class _Controller {
  _SettingsScreenState state;
  _Controller(this.state);

  void returnHome() {
    Navigator.pop(state.context);
    Navigator.pop(state.context);
  }

  void onChangedUploadFrequency(int? value) {}

  void onChangedDataCollectionFrequency(int? value) {}

  void edit() {
    state.render(() => state.editMode = true);
  }

  void save() {
    state.render(() => state.editMode = false);
  }
}
