import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/pages/auth/login_screen.dart';
import 'package:insure_boost/pages/index_page.dart';
import 'package:insure_boost/pages/welcome_Screen.dart';

import 'auth/signup_sreen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return IndexPage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: StreamBuilder<User?>(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState) {
  //           return Center(child: CircularProgressIndicator),
  //           return IndexPage();
  //         } else {
  //           return LoginScreen();
  //         }
  //       },
  //     ),
  //   );
  // }
}
