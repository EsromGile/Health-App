import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controller/auth_controller.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/model/viewscreen_models/loginscreen_model.dart';
import 'package:health_app/viewscreen/create_account_screen.dart';
import 'package:health_app/viewscreen/view/kirby_loading.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

import '../controller/firebase_firestore_controller.dart';
import '../model/account_settings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  late _Controller con;
  late SignInScreenModel screenModel;
  var formKey = GlobalKey<FormState>();

  void render(fn) => setState(fn);

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    screenModel = SignInScreenModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: screenModel.isSignInUnderway
          ? const Center(child: KirbyLoading())
          : signInForm(),
    );
  }

  Widget signInForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset("images/kirby-logo.png"),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: screenModel.validateEmail,
                  onSaved: screenModel.saveEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Password'),
                  autocorrect: false,
                  obscureText: true,
                  validator: screenModel.validatePassword,
                  onSaved: screenModel.savePassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: con.login,
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Don't have an account yet?",
                ),
                OutlinedButton(
                    onPressed: con.createAccount,
                    child: const Text(
                      "Create a New Account",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _LoginScreenState state;
  _Controller(this.state);

  String? email;
  String? password;
  User? user;

  Future<void> login() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    state.render(() => state.screenModel.isSignInUnderway = true);

    try {
      await Auth.signIn(email: state.screenModel.email!, password: state.screenModel.password!);
    } on FirebaseAuthException catch(e) {
      state.render(() => state.screenModel.isSignInUnderway = false);
      var error = 'Sign in error! Reason: ${e.code} ${e.message ?? ""}';
      if (Constant.devMode) {
        // ignore: avoid_print
        print("============== $error");
      }
      showSnackBar(context: state.context, seconds: 20, message: error);
    } catch (e) {
      state.render(() => state.screenModel.isSignInUnderway = false);
      if (Constant.devMode) {
        // ignore: avoid_print
        print("============== Sign In Error! $e");
      }
      showSnackBar(
          context: state.context, seconds: 20, message: "Sign In Error! $e");
    }
  }

  void createAccount() {
    Navigator.pushNamed(state.context, CreateAccountScreen.routeName);
  }

  Future<void> settingsCheck(User? user) async {
    if (user == null) return;
    try {
      //test if settings data exists. if not, create it
      var settingsExists = await FirebaseFirestoreController.checkSettings(
          uid: user.uid);
      if (!settingsExists) {
        AccountSettings s = AccountSettings(uid: user.uid);
        s.docId = await FirebaseFirestoreController.createSettings(settings: s);
      } else {
        // ignore: avoid_print
        print('settings exist already girl');
      }
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('++++ settings check/create error $e');
      showSnackBar(
          context: state.context, message: 'settings check/creation error $e');
    }
  }
}
