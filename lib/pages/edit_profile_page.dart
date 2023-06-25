import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insure_boost/api/user_api.dart';
import 'package:insure_boost/models/user.dart';
import 'package:path/path.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late Person me;
  late String username;
  late String email;
  late String bio;
  late String url;

  UploadTask? task;
  XFile? _image;
  File? _img;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  _imgFromGallery() async {
    try {
      final _pick = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      setState(() {
        _image = _pick!;
        _img = File(_image!.path);
      });
    } catch (e) {
      print("error");
      print(e);
    }
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
    username = me.username;
    email = me.email;
    bio = me.bio;
    url = me.profileUrl;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: globals.NIGHT_MODE
                  ? globals.scaffoldDark
                  : globals.scaffoldLight,
              body: Center(
                child: SpinKitRing(
                  color: Colors.teal,
                  size: 80.0,
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: globals.NIGHT_MODE
                ? globals.scaffoldDark
                : globals.scaffoldLight,
            appBar: AppBar(
              backgroundColor:
                  globals.NIGHT_MODE ? globals.appBarDark : globals.appBarLight,
              elevation: 1,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color:
                      globals.NIGHT_MODE ? Colors.grey[200] : Colors.grey[800],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(
                          color: globals.NIGHT_MODE
                              ? globals.blackwordDark
                              : globals.blackwordLight,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: _image != null
                                    ? Image.file(
                                        _img!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        me.profileUrl,
                                        fit: BoxFit.cover,
                                      ),
                              )),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _imgFromGallery();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.grey[800],
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            usernameField("Username", me.username),
                            emailField("E-mail", me.email),
                            bioField("Bio", me.bio),
                          ],
                        )),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.teal,
                                  width: 2,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                _formKey.currentState!.save();

                                await updateUserInfo();

                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget usernameField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue: placeholder,
        onSaved: (val) {
          username = val!;
        },
        style: TextStyle(
            color: globals.NIGHT_MODE ? Colors.grey[200] : Colors.black),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(
                color: globals.NIGHT_MODE ? Colors.grey[200] : Colors.black),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: globals.NIGHT_MODE ? Colors.teal : Colors.black)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: globals.NIGHT_MODE ? Colors.grey : Colors.black)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: globals.NIGHT_MODE
                  ? globals.blackwordDark
                  : globals.blackwordLight,
            )),
      ),
    );
  }

  Widget emailField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue: placeholder,
        onSaved: (val) {
          email = val!;
        },
        style: TextStyle(
            color: globals.NIGHT_MODE ? Colors.grey[200] : Colors.black),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(
                color: globals.NIGHT_MODE ? Colors.grey[200] : Colors.black),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: globals.NIGHT_MODE ? Colors.teal : Colors.black)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: globals.NIGHT_MODE ? Colors.grey : Colors.black)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: globals.NIGHT_MODE
                  ? globals.blackwordDark
                  : globals.blackwordLight,
            )),
      ),
    );
  }

  Widget bioField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        initialValue: placeholder,
        onSaved: (val) {
          bio = val!;
        },
        style: TextStyle(
            color: globals.NIGHT_MODE ? Colors.grey[200] : Colors.black),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle: TextStyle(
                color: globals.NIGHT_MODE ? Colors.grey[200] : Colors.black),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: globals.NIGHT_MODE ? Colors.teal : Colors.black)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: globals.NIGHT_MODE ? Colors.grey : Colors.black)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: globals.NIGHT_MODE
                  ? globals.blackwordDark
                  : globals.blackwordLight,
            )),
      ),
    );
  }

// noting?
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  Future updateUserInfo() async {
    if (_img != null) {
      final filename = basename(_img!.path);

      task = FirebaseStorage.instance
          .ref('${me.userId}/profile/$filename')
          .putFile(_img!);
      final snapshot = await task?.whenComplete(() {});
      url = await snapshot!.ref.getDownloadURL();
    }

    await UserApi(me.userId).updateUserInfo(username, email, url, bio);
  }
}
