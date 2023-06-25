import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/api/user_api.dart';
import 'package:insure_boost/models/user.dart';
import 'package:insure_boost/pages/detail_pages/pdf_detail_page.dart';

class SubmissionDetailPage extends StatefulWidget {
  final String author;
  final String title;
  final String detail;
  final String email;
  final String report;
  final String submission;
  final Timestamp date;
  final String id;

  String me = '';

  SubmissionDetailPage(
      {Key? key,
      required this.author,
      required this.title,
      required this.detail,
      required this.email,
      required this.report,
      required this.submission,
      required this.date,
      required this.id})
      : super(key: key);

  @override
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  Future<void> getUser() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.author)
        .get()
        .then((value) {
      widget.me = value['username'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'My Submission',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.teal,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        StatusTag(
                          text:
                              widget.report == '' ? 'Processing' : 'Completed',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Uploaded by: ${widget.me}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Date: ${widget.date.toDate().month}-${widget.date.toDate().day}-${widget.date.toDate().year}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Email: ${widget.email}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Details: ${widget.detail}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        backgroundColor: Colors.teal,
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerPage(
                              url: '${widget.submission}',
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_file_sharp),
                          SizedBox(
                            width: 10,
                          ),
                          Text('View my Submission File'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        backgroundColor:
                            widget.report == '' ? Colors.grey : Colors.teal,
                        primary: Colors.white,
                      ),
                      onPressed: () {
                        if (widget.report != '') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerPage(
                                url: '${widget.report}',
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Get report of submission'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.red,
              icon: Icon(Icons.delete),
              label: Text('Delete This'),
              onPressed: () async {
                if (widget.submission != '') {
                  await FirebaseStorage.instance
                      .refFromURL(widget.submission)
                      .delete();
                }
                await FirebaseFirestore.instance
                    .collection('submission')
                    .doc(widget.id)
                    .delete();
                Navigator.pop(context);
              },
            ),
          );
        });
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
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
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
