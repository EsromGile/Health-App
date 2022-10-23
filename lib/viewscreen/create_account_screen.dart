import 'package:flutter/material.dart';
import 'package:health_app/controller/firebase_authentication_controller.dart';
import 'package:health_app/model/constant.dart';
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
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
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
                  validator: con.validateEmail,
                  onSaved: con.saveEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Enter Password'),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Confirm Password'),
                  obscureText: true,
                  autocorrect: false,
                  validator: con.validateConfirmedPassword,
                  onSaved: con.saveConfirmedPassword,
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

  String? email;
  String? password;
  String? confirmedPassword;

  void createAccount() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    if (password != confirmedPassword) {
      showSnackBar(context: state.context, message: 'Passwords must match');
      return;
    }

    try {
      await FirebaseAuthenticationController.createAccount(
          email: email!, password: password!);

      showSnackBar(
          context: state.context,
          message:
              'Account has been created! Go back to Login Screen to use the account!');
    } catch (e) {
      if (Constant.devMode) print('Create Account Error: $e');
      showSnackBar(context: state.context, message: 'Create Account Error: $e');
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
      return 'Password must be at least 5 characters';
    } else {
      return null;
    }
  }

  String? validateConfirmedPassword(String? input) {
    if (input == null) {
      return 'No password provided.';
    } else if (input != password) {
      return 'Passwords must match.';
    } else {
      return null;
    }
  }

  void savePassword(String? input) {
    if (input != null) {
      password = input;
    }
  }

  void saveConfirmedPassword(String? input) {
    if (input != null) {
      confirmedPassword = input;
    }
  }
}
