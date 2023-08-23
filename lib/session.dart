import 'package:flutter/material.dart';

import 'main.dart';

class session extends StatefulWidget {
  const session({Key? key}) : super(key: key);

  @override
  State<session> createState() => _sessionState();
}

class _sessionState extends State<session> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: createSession(),
      ),
    );
  }
}

class createSession extends StatefulWidget {
  const createSession({Key? key}) : super(key: key);

  @override
  State<createSession> createState() => _createSessionState();
}

class _createSessionState extends State<createSession> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Text("Welcome to the second page"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                print('Button Pressed');

                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                runApp(MyApp());
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
