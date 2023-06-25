import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({Key? key}) : super(key: key);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  late Stream<QuerySnapshot> histories;

  @override
  initState() {
    // at the beginning, all users are shown
    histories = FirebaseFirestore.instance
        .collection("history")
        .where('user', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    // _foundUsers = _allUsers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder(
        stream: histories,
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
            return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  final event = data.docs[index]['event'].toString();
                  IconData icon = Icons.history;
                  Color color = Colors.black;
                  String suf = '~';
                  if (event == 'Cash' || event == 'Recharge') {
                    icon = Icons.compare_arrows;
                    color = Colors.blue;
                    suf = '~';
                  } else if (event == 'Gain') {
                    icon = Icons.share;
                    color = Colors.green;
                    suf = '+';
                  } else if (event == 'Cost') {
                    icon = Icons.credit_card;
                    color = Colors.red;
                    suf = '-';
                  }
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        icon,
                        size: 30,
                      ),
                      title: Text(
                        '$suf ${data.docs[index]['price'].toString()}',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          '$event, ${data.docs[index]['date'].toDate().year}-${data.docs[index]['date'].toDate().month}-${data.docs[index]['date'].toDate().day}'),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
