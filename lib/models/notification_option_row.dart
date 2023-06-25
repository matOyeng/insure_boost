import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationOpetionRow extends StatefulWidget {
  final String title;
  bool isActive;

  NotificationOpetionRow({required this.title, required this.isActive});

  @override
  _NotificationOpetionRowState createState() => _NotificationOpetionRowState();
}

class _NotificationOpetionRowState extends State<NotificationOpetionRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.teal,
              value: widget.isActive,
              onChanged: (bool value) => setState(() {
                widget.isActive = value;
                print(widget.isActive);
              }),
            ),
          )
        ],
      ),
      // onTap: () {
      //   setState(() {
      //     isActive = !isActive;
      //     print(isActive);
      //   });
      // },
    );
  }
}
