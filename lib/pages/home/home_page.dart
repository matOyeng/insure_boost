import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insure_boost/models/submission.dart';
import 'package:insure_boost/models/user.dart';
import 'package:insure_boost/pages/detail_pages/submission_detail_page.dart';
import 'package:insure_boost/pages/home/my_submissions.dart';
import 'package:insure_boost/pages/home/HeaderWithSearchBox.dart';
import 'package:insure_boost/pages/home/recomends_packages.dart';
import 'package:insure_boost/pages/home/TitleWithMoreBtn.dart';
import 'package:insure_boost/pages/list/package_list.dart';
import 'package:insure_boost/pages/list/submission_list.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchItem = '';
  List<Submission> submissions = [];
  List<Widget> subList = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("submission")
        .where('author', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              submissions.add(new Submission(
                  element.reference.id,
                  element.get('author'),
                  element.get('date'),
                  element.get('report'),
                  element.get('title'),
                  element.get('detail'),
                  element.get('email'),
                  element.get('submission')));
            }));
    print(submissions.length);
    super.initState();
  }

  List<Widget> search(String searchItem) {
    List<Widget> list = [];
    for (var item in submissions) {
      if (item.title.contains(searchItem)) {
        list.add(
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmissionDetailPage(
                    title: item.title,
                    author: item.author,
                    detail: item.detail,
                    email: item.email,
                    report: item.reportUrl,
                    submission: item.submmissionUrl,
                    date: item.date,
                    id: item.Id,
                  ),
                ),
              );
            },
            child: new Card(
              child: ListTile(
                tileColor: Colors.white,
                leading: Icon(
                  Icons.picture_as_pdf,
                  size: 30,
                ),
                title: Text(
                  '${item.title}',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    ' ${item.date.toDate().year}-${item.date.toDate().month}-${item.date.toDate().day}'),
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  void gotoSubmissionList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmissionList(),
      ),
    );
  }

  void gotoPackageList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          globals.NIGHT_MODE ? globals.backGroundDark : globals.backGroundLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // HeaderWithSearchBox(size: size),
            Container(
              margin: EdgeInsets.only(bottom: 20 * 2.5),
              // It will cover 20% of our total height
              height: size.height * 0.2,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 36 + 20,
                    ),
                    height: size.height * 0.2 - 27,
                    decoration: BoxDecoration(
                      color: globals.NIGHT_MODE
                          ? globals.boxGroundDark
                          : globals.boxGroundLight,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Welcome to W&M',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Colors.teal.withOpacity(0.23),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchItem = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search your Submission ID...",
                                hintStyle: TextStyle(
                                  color: Colors.teal.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                // surffix isn't working properly with SVG
                                // thats why we use row
                                // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                              ),
                            ),
                          ),
                          // SvgPicture.asset("assets/icons/search.svg"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchItem == ''
                ? TitleWithMoreBtn(
                    title: "Recomended", press: () => gotoPackageList)
                : SizedBox(height: 0),
            searchItem == ''
                ? RecomendsPackages()
                : ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: search(searchItem),
                  ),
            searchItem == ''
                ? TitleWithMoreBtn(
                    title: "My Submission", press: () => gotoSubmissionList)
                : SizedBox(height: 0),
            searchItem == '' ? MySubmissions() : SizedBox(height: 0),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
