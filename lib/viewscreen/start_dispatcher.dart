import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/controller/auth_controller.dart';
import 'package:health_app/viewscreen/home_screen.dart';
import 'package:health_app/viewscreen/login_screen.dart';

class StartDispatcher extends StatelessWidget {
  static const routeName = "/startDispatcher";

  const StartDispatcher({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Auth.user = snapshot.data;
        return Auth.user == null ? const LoginScreen() : const HomeScreen();
      },
    );
  }
}