import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/user.dart';

class UserApi {
  final String uid;

  UserApi(this.uid);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  // when users modify their info again
  Future updateUserInfo(
      String username, String email, String profileUrl, String bio) async {
    return userCollection
        .doc(uid)
        .update({
          'username': username,
          'email': email,
          'profileUrl': profileUrl,
          'bio': bio,
        })
        .then((value) => print('User $uid Update'))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<Person?> getMe() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .get()
          .then((doc) {
        return Person(FirebaseAuth.instance.currentUser!.uid, doc['username'],
            doc['email'], doc['profileUrl'], doc['bio'], doc['point']);
      });
    } catch (e) {
      return Person('', '', '', '', '', -1);
    }
  }

  Future addUserToStore() async {
    String username = 'Username';
    String email = 'email@email.com';
    String profileUrl =
        'https://firebasestorage.googleapis.com/v0/b/insurance-boost-26d35.appspot.com/o/default%2Fprofile_default.png?alt=media&token=b7ba805b-67e5-4951-b500-c08f8745dd30';
    String bio = 'Say something?';
    await userCollection.doc(uid).set({
      'username': username,
      'email': email,
      'profileUrl': profileUrl,
      'bio': bio,
      'point': 0,
    });
  }
}
