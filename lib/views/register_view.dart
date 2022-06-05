import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/utilities/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                            horizontal: 8, vertical: 16),
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
                            child: const Text('Register'),
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                final user = FirebaseAuth.instance.currentUser;
                                await user?.sendEmailVerification();
                                Navigator.pushNamed(
                                  context,
                                  verifyEmialRoute,
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  await errorDialog(
                                    context,
                                    'Weak password',
                                  );
                                } else if (e.code == 'email-already-in-use') {
                                  await errorDialog(
                                    context,
                                    'Email already registered',
                                  );
                                } else if (e.code == 'invalid-email') {
                                  await errorDialog(
                                    context,
                                    'Invalid email',
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
                          )),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute,
                              (route) => false,
                            );
                          },
                          child: const Text("Login"),
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
