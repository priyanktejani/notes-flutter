import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'dart:developer' show log;

import 'package:notes/utilities/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // first init state main body
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: TextField(
                          controller: _email,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: TextField(
                          controller: _password,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Password',
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ElevatedButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              final user = FirebaseAuth.instance.currentUser;
                              if (user?.emailVerified ?? false) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  notesRoute,
                                  (route) => false,
                                );
                              } else {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyEmialRoute,
                                  (route) => false,
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                await errorDialog(
                                  context,
                                  "User not found",
                                );
                              } else if (e.code == 'wrong-password') {
                                await errorDialog(
                                  context,
                                  "Wrong password",
                                );
                              } else {
                                await errorDialog(
                                  context,
                                  e.code.toString(),
                                );
                              }
                            } catch (e) {
                              await errorDialog(
                                context,
                                e.toString(),
                              );
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (route) => false,
                            );
                          },
                          child: const Text("Register as new User"),
                        ),
                      )
                    ],
                  ),
                );
              default:
                return const Text("Loading...");
            }
          },
        ));
  }

  @override
  void dispose() {
    // second dispose extra stuff then main frame
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
