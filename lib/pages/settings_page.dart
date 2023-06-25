import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;
import 'package:insure_boost/models/account_option_row.dart';
import 'package:insure_boost/models/change_pwd_row.dart';
import 'package:insure_boost/models/notification_option_row.dart';
import 'package:insure_boost/utils/exports.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          globals.NIGHT_MODE ? globals.scaffoldDark : globals.scaffoldLight,
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
            // color: Colors.grey[800],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Settings",
              style: TextStyle(
                  color: globals.NIGHT_MODE
                      ? globals.firstLevelTitleDark
                      : globals.firstLevelTitleLight,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: globals.NIGHT_MODE
                      ? globals.leftIconDark
                      : globals.leftIconLight,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(
                      color: globals.NIGHT_MODE
                          ? globals.firstLevelTitleDark
                          : globals.firstLevelTitleLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            // buildAccountOptionRow(context, "My Profile"),
            AccountOptionRow(
              title: 'My Profile',
            ),
            // ChangePwdRow(title: "Change Password"),
            // buildAccountOptionRow(context, "Language"),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Icon(
                  Icons.brush,
                  color: globals.NIGHT_MODE
                      ? globals.leftIconDark
                      : globals.leftIconLight,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Theme",
                  style: TextStyle(
                      color: globals.NIGHT_MODE
                          ? globals.firstLevelTitleDark
                          : globals.firstLevelTitleLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),

            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Night Mode',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                        activeColor: Colors.teal,
                        value: globals.NIGHT_MODE,
                        onChanged: (bool value) {
                          setState(() {
                            globals.NIGHT_MODE = value;
                            // print(widget.isActive);
                          });
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Colors.redAccent,
      elevation: 0,
      padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
      // user sign out
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/MainPage');
    },
    child: Text(
      "SIGN OUT",
      style: TextStyle(
        fontSize: 16,
        letterSpacing: 2.2,
        color: Colors.white,
      ),
    ),
  ),
),

          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
