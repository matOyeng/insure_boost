import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:insure_boost/api/history_api.dart';
import 'package:insure_boost/models/user.dart';
import 'package:insure_boost/pages/list/history_list.dart';
import 'package:insure_boost/pages/list/package_list.dart';
import 'package:insure_boost/pages/list/package_my_list.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  late List<Color> _backgroundColor;
  late Color _iconColor;
  late Color _textColor;
  late List<Color> _actionContainerColor;
  late Color _borderContainer;
  bool colorSwitched = false;
  late var logoImage;

  late Person me;
  int num = 0;

  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        // logoImage = 'assets/images/wallet_dark_logo.png';
        _backgroundColor = [
          Color.fromRGBO(252, 214, 0, 1),
          Color.fromRGBO(251, 207, 6, 1),
          Color.fromRGBO(250, 197, 16, 1),
          Color.fromRGBO(249, 161, 28, 1),
        ];
        _iconColor = Colors.white;
        _textColor = Color.fromRGBO(253, 211, 4, 1);
        _borderContainer = Color.fromRGBO(34, 58, 90, 0.2);
        _actionContainerColor = [
          Color.fromRGBO(47, 75, 110, 1),
          Color.fromRGBO(43, 71, 105, 1),
          Color.fromRGBO(39, 64, 97, 1),
          Color.fromRGBO(34, 58, 90, 1),
        ];
      });
    } else {
      setState(() {
        // logoImage = 'assets/images/wallet_logo.png';
        _borderContainer = Colors.teal;
        _backgroundColor = [
          Color.fromRGBO(249, 249, 249, 1),
          Color.fromRGBO(241, 241, 241, 1),
          Color.fromRGBO(233, 233, 233, 1),
          Color.fromRGBO(222, 222, 222, 1),
        ];
        _iconColor = Colors.white;
        _textColor = Colors.white;
        _actionContainerColor = [
          Colors.teal,
          Colors.teal,
          Colors.teal,
          Colors.teal,
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    changeTheme();
    getUser();
  }

  Future<void> getUser() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      me = Person(FirebaseAuth.instance.currentUser!.uid, doc['username'],
          doc['email'], doc['profileUrl'], doc['bio'], doc['point']);
    });
  }

  void gotoMyPackageList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageMyList(),
      ),
    );
  }

  void gotoHistoryList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: SpinKitRing(
              color: Colors.teal,
              size: 80.0,
            ),
          );
        }
        return Scaffold(
          backgroundColor: globals.NIGHT_MODE
              ? globals.backGroundDark
              : globals.backGroundLight,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 18,
                              color: globals.NIGHT_MODE
                                  ? globals.blackwordDark
                                  : globals.blackwordLight),
                        ),
                        Text(
                          me.username,
                          style: TextStyle(
                              fontSize: 24,
                              color: globals.NIGHT_MODE
                                  ? globals.blackwordDark
                                  : globals.blackwordLight,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      height: h / 1.6,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              // bottomRight: Radius.circular(30),
                              // bottomLeft: Radius.circular(30),
                            ),
                            color: globals.NIGHT_MODE
                                ? globals.boxGroundDark
                                : globals.boxGroundLight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 120,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${me.point}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: _textColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 60),
                                          ),
                                          Text(
                                            '￥',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: _textColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Reward Points',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _iconColor, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Table(
                                // border: TableBorder.symmetric(
                                //   inside: BorderSide(
                                //       color: Colors.grey,
                                //       style: BorderStyle.solid,
                                //       width: 0.5),
                                // ),
                                children: [
                                  TableRow(children: [
                                    FunctionBlock(
                                        icon: Icons.send,
                                        press: () {
                                          recharging();
                                        },
                                        desc: 'Recharge'),
                                    FunctionBlock(
                                        icon: Icons.money,
                                        press: () {
                                          cashreturing();
                                        },
                                        desc: 'Cash'),
                                  ]),
                                  TableRow(children: [
                                    FunctionBlock(
                                        icon: Icons.apps,
                                        press: () {
                                          gotoMyPackageList();
                                        },
                                        desc: 'My packages'),
                                    FunctionBlock(
                                        icon: Icons.history,
                                        press: () {
                                          gotoHistoryList();
                                        },
                                        desc: 'History'),
                                  ])
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> recharging() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Recharging Window"),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              num = int.parse(val);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Not now"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text("Recharge"),
              onPressed: () async {
                int price = num;
                num = me.point + price;

                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  'point': num,
                });

                await HistoryApi().newHistory(
                    DateTime.now(), 'Recharge', num, price, me.userId);
                num = 0;
                //关闭对话框并返回true
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> cashreturing() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cash Window"),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              num = int.parse(val);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Not now"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            TextButton(
              child: Text("Cash"),
              onPressed: () async {
                if (me.point > num) {
                  int price = num;
                  num = me.point - price;

                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({
                    'point': num,
                  });

                  await HistoryApi().newHistory(
                      DateTime.now(), 'Cash', num, price, me.userId);
                  num = 0;
                  //关闭对话框并返回true
                  Navigator.of(context).pop();
                  setState(() {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Insufficient balance'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class FunctionBlock extends StatelessWidget {
  final IconData icon;
  final Function press;
  final String desc;

  const FunctionBlock(
      {Key? key, required this.icon, required this.press, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => press(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 45,
              color:
                  globals.NIGHT_MODE ? Colors.white : globals.wordAndIconLight,
              // color: Colors.white,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              desc,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
