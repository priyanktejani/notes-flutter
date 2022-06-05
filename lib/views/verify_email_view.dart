import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';

class VerifyEmialView extends StatefulWidget {
  const VerifyEmialView({Key? key}) : super(key: key);

  @override
  State<VerifyEmialView> createState() => _VerifyEmialViewState();
}

class _VerifyEmialViewState extends State<VerifyEmialView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Text('Email verification send'),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                },
                child: const Text('Resend email verification'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, registerRoute);
                },
                child: const Text('Change email'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
