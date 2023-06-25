import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SubmissionApi {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('submission');

  UploadTask? uploadFileToStorage(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  removeFileFromStorage(String url) {
    FirebaseStorage.instance.refFromURL(url).delete();
  }

  Future addFileToStore(String title, String author, DateTime date,
      String email, String detail, String report, String submission) async {
    return col
      ..add({
        'title': title,
        'author': author,
        'date': date,
        'email': email,
        'detail': detail,
        'report': report,
        'submission': submission,
      });
  }

  // Future deleteFileToStore()

  Future updateFileToStore(String id, String author, DateTime date,
      String title, String report, String submission) async {
    return col.doc(id).update({
      'author': author,
      'date': date,
      'title': title,
      'report': report,
      'submission': submission,
    });
  }
}
