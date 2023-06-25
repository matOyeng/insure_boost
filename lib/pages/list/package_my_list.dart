import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/api/history_api.dart';
import 'package:insure_boost/models/user.dart';
import 'package:insure_boost/pages/detail_pages/package_detail_page.dart';

class PackageMyList extends StatefulWidget {
  const PackageMyList({Key? key}) : super(key: key);

  @override
  _PackageMyListState createState() => _PackageMyListState();
}

class _PackageMyListState extends State<PackageMyList> {
  late Stream<QuerySnapshot> packages;
  late Person me;
  @override
  initState() {
    // at the beginning, all users are shown
    packages = FirebaseFirestore.instance
        .collection("my_package")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    getUser();
    // _foundUsers = _allUsers;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: packages,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return Text('Something nodata ');
                  } else if (snapshot.hasError) {
                    return Text('Something error ');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('Something noconn ');
                  } else {
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        final dateData = data.docs[index]['date'].toDate();
                        var newDate = dateData.add(const Duration(days: 90));
                        var finalDate = dateData.add(const Duration(days: 365));
                        return Card(
                          key: ValueKey(data.docs[index].reference.id),
                          color: Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {},
                            child: DateTime.now().compareTo(finalDate) < 0
                                ? Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              data.docs[index]['code'],
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            StatusTag(
                                                text: data.docs[index]
                                                    ['category']),
                                            SizedBox(
                                              width: width / 8,
                                            ),
                                            (DateTime.now().compareTo(newDate) <
                                                        0) ||
                                                    (data.docs[index]
                                                            ['point'] ==
                                                        0)
                                                ? TextButton(
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.only(
                                                          left: 15, right: 15),
                                                      shape:
                                                          new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(40.0),
                                                      ),
                                                      primary: Colors
                                                          .grey, // background
                                                      backgroundColor: Colors
                                                          .white, // foreground
                                                      elevation: 0,
                                                      side: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2),
                                                    ),
                                                    onPressed: () async {},
                                                    child: Text('Transfer'),
                                                  )
                                                : TextButton(
                                                    style: TextButton.styleFrom(
                                                      padding: EdgeInsets.only(
                                                          left: 15, right: 15),
                                                      shape:
                                                          new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(40.0),
                                                      ),
                                                      primary: Colors
                                                          .teal, // background
                                                      backgroundColor: Colors
                                                          .white, // foreground
                                                      elevation: 0,
                                                      side: BorderSide(
                                                          color: Colors.teal,
                                                          width: 2),
                                                    ),
                                                    onPressed: () async {
                                                      int price = data
                                                          .docs[index]['point'];
                                                      var num =
                                                          me.point + price;

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('user')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update({
                                                        'point': num,
                                                      });

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'my_package')
                                                          .doc(data.docs[index]
                                                              .reference.id)
                                                          .update({
                                                        'point': 0,
                                                      });

                                                      await HistoryApi()
                                                          .newHistory(
                                                              DateTime.now(),
                                                              'Gain',
                                                              num,
                                                              price,
                                                              me.userId);
                                                      num = 0;
                                                      //关闭对话框并返回true
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {});
                                                    },
                                                    child: Text('Transfer'),
                                                  ),
                                          ],
                                        ),
                                        Text(
                                          'Duration: ${finalDate.difference(DateTime.now()).inDays} Days left',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data.docs[index]['detail'],
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTag extends StatelessWidget {
  final String text;
  late Color color;
  StatusTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == 'Life') {
      color = Colors.red;
    } else if (text == 'Health') {
      color = Colors.green;
    } else {
      color = Colors.orange;
    }
    return Container(
      alignment: Alignment.center,
      width: 90,
      height: 20,
      decoration: BoxDecoration(
          color: color,
          // border: Border.all(color: Colors.teal, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
