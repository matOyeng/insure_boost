import 'package:flutter/material.dart';

class AccountOptionRow extends StatefulWidget {
  final String title;
  // final Function function;

  AccountOptionRow({required this.title});

  @override
  _AccountOptionRowState createState() => _AccountOptionRowState();
}

class _AccountOptionRowState extends State<AccountOptionRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // widget.function;
        // print("Navigator");
        Navigator.pushNamed(context, '/EditProfilePage');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
