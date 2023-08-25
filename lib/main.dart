import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'session.dart';
import 'signupform.dart';

Future<void> main() async {
  runApp(MaterialApp(home: MyApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passWord = GlobalKey<FormState>();
  final _userName = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String username;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Pagadai",
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Hello World"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _userName,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter a Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the username';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _passWord,
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter your Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the password';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        username = usernameController.text;
                        password = passwordController.text;

                        // Validate returns true if the form is valid, or false otherwise.
                        print('Button Pressed');
                        if (_userName.currentState!.validate() &&
                            _passWord.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,

                          // you'd often call a server or save the information in a database.
                          await Login();
                          if (FirebaseAuth.instance.currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Invalid credentials',
                                        style: TextStyle(color: Colors.red))));
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const session()),
                            );
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  GestureDetector(
                    child: const Text(
                      "Create new account",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    onTap: () {
                      print("new account intiatiated");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const signupform()));
                    },
                  )
                ],
              ),
            ]));
  }

  Future<void> Login() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      // runApp(session());
    }
  }
}
