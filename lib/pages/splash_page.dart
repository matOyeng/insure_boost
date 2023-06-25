import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  int time = 0;
  late Timer _timer;
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        backgroundColor: Colors.teal,
        body: Stack(
          children: [
            // new Container(
            //   child: new Image.network(
            //     "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
            //     fit: BoxFit.fill,
            //   ),
            // ),
            new Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'W & M',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Your best insurance boost application',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
            new Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
              child: ElevatedButton(
                child: new Text(
                  "Skip ${3 - time}",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  _skip();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    _countDown();
  }

  void _skip() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacementNamed(context, '/MainPage');
    } else {
      Navigator.pushReplacementNamed(context, '/WelcomeScreen');
    }
  }

  void _countDown() {
    // var _duration = new Duration(seconds: 3);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      time++;
      if (time == 3) {
        _timer.cancel();
        _skip();
      }
      setState(() {});
    });
    // new Future.delayed(Duration(seconds: 3), _skip);
  }

  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
