import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controller/firebase_authentication_controller.dart';
import 'package:health_app/model/constant.dart';
import 'package:health_app/viewscreen/create_account_screen.dart';
import 'package:health_app/viewscreen/home_screen.dart';
import 'package:health_app/viewscreen/view/view_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = "/loginScreen";

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
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
        title: const Text("Log In"),
      ),
      body: SingleChildScrollView(
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
                    decoration:
                        const InputDecoration(hintText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: con.validateEmail,
                    onSaved: con.saveEmail,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Password'),
                    autocorrect: false,
                    obscureText: true,
                    validator: con.validatePassword,
                    onSaved: con.savePassword,
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
      ),
    );
  }
}

class _Controller {
  _LoginScreenState state;
  _Controller(this.state);

  String? email;
  String? password;

  void login() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    User? user;

    try {
      if (email == null || password == null) {
        throw 'Email Address or Password is null';
      }

      user = await FirebaseAuthenticationController.signIn(
          email: email!, password: password!);

      //Grab user's accelerometer readings from Firestore and pass it to the home screen

      Navigator.pushNamed(state.context, HomeScreen.routeName);
    } catch (e) {
      if (Constant.devMode) print('Log In Error: $e');
      showSnackBar(context: state.context, message: 'Log In Error: $e');
    }
  }

  String? validateEmail(String? input) {
    if (input == null) {
      return 'No email address provided.';
    } else if (!(input.contains('@') && input.contains('.'))) {
      return 'Invalid format.';
    } else {
      return null;
    }
  }

  void saveEmail(String? input) {
    if (input != null) {
      email = input;
    }
  }

  String? validatePassword(String? input) {
    if (input == null) {
      return 'No password provided.';
    } else if (input.length < 5) {
      return 'Password must be at least 5 characters.';
    } else {
      return null;
    }
  }

  void savePassword(String? input) {
    if (input != null) {
      password = input;
    }
  }

  void createAccount() {
    Navigator.pushNamed(state.context, CreateAccountScreen.routeName);
  }
}
