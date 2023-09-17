import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapp/Screens/home_screen.dart';
import 'package:firebasechatapp/Screens/login_screen.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user is login
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            //user not login
            else {
              return const LoginScreen();
            }
          }),
    );
  }
}
