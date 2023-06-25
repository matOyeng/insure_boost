import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/pages/detail_pages/pdf_detail_page.dart';
import 'package:insure_boost/pages/detail_pages/submission_detail_page.dart';

// import '../../../constants.dart';

class MySubmissions extends StatelessWidget {
  late Stream<QuerySnapshot> pdfs;

  @override
  Widget build(BuildContext context) {
    pdfs = FirebaseFirestore.instance
        .collection("submission")
        .where('author', isEqualTo: '${FirebaseAuth.instance.currentUser!.uid}')
        .snapshots();
    return StreamBuilder(
        stream: pdfs,
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Text('Something nodata ');
          } else if (snapshot.hasError) {
            return Text('Something error ');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Something noconn ');
          } else {
            final data = snapshot.requireData;
            return SizedBox(
              height: 210,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return MySubmissionsCard(
                      image: "image/img2.png",
                      title: data.docs[index]['title'],
                      date: data.docs[index]['date'],
                      press: () {
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
                    );
                  }),
            );
          }
        });
  }
}

class MySubmissionsCard extends StatelessWidget {
  const MySubmissionsCard({
    Key? key,
    required this.image,
    required this.press,
    required this.title,
    required this.date,
  }) : super(key: key);
  final String image;
  final String title;
  final Timestamp date;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => press(),
      child: Container(
          margin: EdgeInsets.only(
            left: 20,
            top: 10,
            bottom: 10,
          ),
          width: size.width * 0.8,
          height: 185,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage(image),
            // ),
            color: Colors.teal,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${date.toDate().month}-${date.toDate().day}-${date.toDate().year}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
    );
  }
}
