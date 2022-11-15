import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controller/auth_controller.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/viewscreen_models/create_accountscreen_model.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);
  static const routeName = '/createAccountScreen';

  @override
  State<StatefulWidget> createState() {
    return _CreateAccountState();
  }
}

class _CreateAccountState extends State<CreateAccountScreen> {
  late _Controller con;
  late CreateAccountScreenModel screenModel;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = CreateAccountScreenModel();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health App')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(
                    'Create a New Account',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Enter Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: screenModel.validateEmail,
                  onSaved: screenModel.saveEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Enter Password'),
                  obscureText: true,
                  autocorrect: false,
                  validator: screenModel.validatePassword,
                  onSaved: screenModel.savePassword,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Confirm Password'),
                  obscureText: true,
                  autocorrect: false,
                  validator: screenModel.validatePassword,
                  onSaved: screenModel.savePasswordConf,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: con.createAccount,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _CreateAccountState state;
  _Controller(this.state);

  Future<void> createAccount() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    if (state.screenModel.password != state.screenModel.passwordConf) {
      showSnackBar(
        context: state.context,
        message: 'Passwords must match.',
        seconds: 5,
      );
      return;
    }

    try {
      await Auth.createAccount(
        email: state.screenModel.email!,
        password: state.screenModel.password!,
      );
      if (state.mounted) {
        Navigator.of(state.context).pop();
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print("======= failed to create: $e");
      showSnackBar(
        context: state.context,
        message: "${e.code} ${e.message}",
        seconds: 5,
      );
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('Create Account Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Create Account Error: $e',
        seconds: 5,
      );
    }
  }
}
