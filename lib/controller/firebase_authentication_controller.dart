import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationController {
  // pass login info to firebase to verify login
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userNameAndPassword = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userNameAndPassword.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
