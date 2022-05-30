import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> loginUsingEmailPassword(
    {required String email,
    required String password,
    required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    user = userCredential.user;

    auth.signOut();
  } on FirebaseAuthException catch (ex) {
    if (ex.code == "user-not-found") {
      // ignore: avoid_print
      print("No user Found for that email");
    }
  }
  return user;
}
