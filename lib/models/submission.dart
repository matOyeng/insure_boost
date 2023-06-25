import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  final String Id;
  final String author;
  final Timestamp date;
  final String reportUrl;
  final String title;
  final String detail;
  final String email;
  final String submmissionUrl;

  Submission(this.Id, this.author, this.date, this.reportUrl, this.title,
      this.detail, this.email, this.submmissionUrl);
}
