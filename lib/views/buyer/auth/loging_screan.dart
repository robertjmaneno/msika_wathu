import 'package:flutter/material.dart';

class LoginScrean extends StatelessWidget {
  const LoginScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Customer Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Email Address'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Password'),
            ),
          ],
        ),
      ),
    );
  }
}
