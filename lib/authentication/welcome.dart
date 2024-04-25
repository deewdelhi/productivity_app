import 'package:flutter/material.dart';
import 'package:productivity_app/authentication/logIn.dart';
import 'package:productivity_app/authentication/signUp.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("WELCOME"),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push<signUpScreen>(
                MaterialPageRoute(
                  builder: (ctx) => signUpScreen(),
                ),
              );
            },
            child: Text("Sign up"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push<logIn>(
                MaterialPageRoute(
                  builder: (ctx) => const logIn(),
                ),
              );
            },
            child: Text("Log in"),
          ),
        ],
      ),
    ));
  }
}
