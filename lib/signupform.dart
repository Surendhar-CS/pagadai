import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signupform extends StatefulWidget {
  const signupform({Key? key}) : super(key: key);

  @override
  State<signupform> createState() => _signupformState();
}

class _signupformState extends State<signupform> {
  final _password = GlobalKey<FormState>();
  final _username = GlobalKey<FormState>();
  final _confirmpass = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  late String username;
  late String password;
  late String confirmpass;
  late String _errorMessage = '';
  late String _signuperror = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Signup form"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _username,
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the email address',
                ),
                // onChanged: (val) {
                //   validateEmail(val);
                // },
                validator: (value) {
                  validateEmail(value!);
                  if (_errorMessage.isNotEmpty) {
                    return _errorMessage;
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _password,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _confirmpass,
              child: TextFormField(
                obscureText: true,
                controller: confirmpassController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm your Password',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    username = usernameController.text;
                    password = passwordController.text;
                    confirmpass = confirmpassController.text;

                    // Validate returns true if the form is valid, or false otherwise.
                    print('signup initiated');
                    if (_username.currentState!.validate() &&
                        _password.currentState!.validate() &&
                        _confirmpass.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,

                      // you'd often call a server or save the information in a database.
                      if (password != confirmpass) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'password and confirm password does not match',
                                style: TextStyle(color: Colors.red))));
                      } else {
                        CreateUser();
                        // _signuperror = "meow";
                        if (_signuperror.isEmpty) {
                          Navigator.of(context).pop();
                          // print(_signuperror);
                        }
                      }

                      // if (FirebaseAuth.instance.currentUser == null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Invalid credentials',
                      //               style: TextStyle(color: Colors.red))));
                      // } else {
                      //   // ignore: use_build_context_synchronously
                      //   // Navigator.push(
                      //   //   context,
                      //   //   MaterialPageRoute(
                      //   //       builder: (context) => const MyApp()),
                      //   // );
                      //   Navigator.of(context).pop();
                      // }
                    }
                  },
                  child: const Text('Sign up'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _signuperror,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  Future<void> CreateUser() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // if (!mounted) return;
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        if (mounted) {
          setState(() {
            _signuperror = "The password provided is too weak.";
          });
        }

        print(_signuperror);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        if (mounted) {
          setState(() {
            _signuperror = "The account already exists for that email.";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _signuperror = '';
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
