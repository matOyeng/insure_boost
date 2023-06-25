import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/pages/detail_pages/package_detail_page.dart';
import 'package:insure_boost/pages/detail_pages/submission_detail_page.dart';

class SubmissionList extends StatefulWidget {
  const SubmissionList({Key? key}) : super(key: key);

  @override
  _SubmissionListState createState() => _SubmissionListState();
}

class _SubmissionListState extends State<SubmissionList> {
  late Stream<QuerySnapshot> submissions;

  @override
  initState() {
    // at the beginning, all users are shown
    submissions = FirebaseFirestore.instance
        .collection("submission")
        .where('author', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    // _foundUsers = _allUsers;
    super.initState();
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
                stream: submissions,
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
                        return Card(
                          key: ValueKey(data.docs[index].reference.id),
                          color: Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubmissionDetailPage(
                                    title: data.docs[index]['title'],
                                    author: data.docs[index]['author'],
                                    detail: data.docs[index]['detail'],
                                    email: data.docs[index]['email'],
                                    report: data.docs[index]['report'],
                                    submission: data.docs[index]['submission'],
                                    date: data.docs[index]['date'],
                                    id: data.docs[index].reference.id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      StatusTag(
                                          text: data.docs[index]['report'] == ''
                                              ? 'Processing'
                                              : 'Completed'),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.docs[index]['title'],
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${data.docs[index]['date'].toDate().year}-${data.docs[index]['date'].toDate().month}-${data.docs[index]['date'].toDate().day}',
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
                                ],
                              ),
                            ),
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
    if (text == 'Processing') {
      color = Colors.redAccent;
    } else {
      color = Colors.green;
    }
    return Container(
      alignment: Alignment.center,
      width: 90,
      height: 90,
      decoration: BoxDecoration(
          color: color,
          // border: Border.all(color: Colors.teal, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(50))),
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
