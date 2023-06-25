import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryApi {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('history');

  Future newHistory(
      DateTime date, String event, int num, int price, String userId) async {
    return col.add({
      'date': date,
      'event': event,
      'price': price,
      'point': num,
      'user': userId,
    });
  }
}
