import 'package:flutter/material.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;

class AboutPage extends StatelessWidget {
  // const AboutPage({Key? key}) : super(key: key);
  final String imagePath = 'image/aboutpic.jpg';
  final String title = 'SSE3151-1 Final Project Team';
  final String name = 'MA ZHIYUAN 201464\nWANG YIDA 201406';
  final String details =
      'The Final Project of SSE3151-1: Mobile Application Development\nThis app allows user to upload their contract/policy to be reviewed to get a free boost to their coverage. The report will be sent to the user and booster package recommendation will be given to the user for free.\nIf they take up a booster package, they will get reward points. The app shall allow users to share the app to friends and family. They will get reward points if their friends and family sign up to any booster plan. The reward can be converted into cash value after 3 months.\nThe app shall generate report for reward points, eligible reward point redemption, and redemption history.\nThe app shall allow sharing url link through whatsapp, Instagram, twitter, email, telegram, etc. The link will bring the user to a landing page, in which will ask the user to install this app.\nThe app shall keep track of all referrals, and referral conversions.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          globals.NIGHT_MODE ? globals.backGroundDark : globals.backGroundLight,
      appBar: AppBar(
        backgroundColor:
            globals.NIGHT_MODE ? globals.appBarDark : globals.appBarLight,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: globals.NIGHT_MODE
                ? globals.leftIconDark
                : globals.leftIconLight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              child: Container(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              margin: new EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.teal[800],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          details,
                          style: TextStyle(
                            color: globals.NIGHT_MODE
                                ? globals.blackwordDark
                                : globals.blackwordLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
