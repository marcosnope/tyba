// import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tyba/src/widgets/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialiaze Firebase App
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const LoginScreen();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (ex) {
      if (ex.code == "user-not-found") {
        // ignore: avoid_print
        print("No user Found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("MyApp Title",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold)),
            const Text("Login to Your App",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 44.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: "User Email",
                  prefixIcon: Icon(Icons.mail, color: Colors.black)),
            ),
            const SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: "User Password",
                  prefixIcon: Icon(Icons.lock, color: Colors.black)),
            ),
            const SizedBox(
              height: 44.0,
            ),
            const Text("Don't remember your Password?",
                style: TextStyle(color: Colors.blue)),
            const SizedBox(
              height: 88.0,
            ),
            SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: const Color(0xFF0069FE),
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    User? user = await loginUsingEmailPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context);
                    print(user);
                    if (user != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const DashboardScreen()));
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                )),
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: RawMaterialButton(
            //       fillColor: Color(0xFF0069FE),
            //       elevation: 0.0,
            //       padding: EdgeInsets.symmetric(vertical: 20.0),
            //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), onPressed: () {  },
            //     ),
            // )
          ]),
    );
  }
}
