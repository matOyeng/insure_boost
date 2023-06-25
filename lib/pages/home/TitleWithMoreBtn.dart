import 'package:flutter/material.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;

// import '../../../constants.dart';

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                color: globals.NIGHT_MODE
                    ? globals.blackwordDark
                    : globals.blackwordLight),
          ),
          Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
              ),
            ),
            onPressed: press(),
            child: Text(
              "More",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    required Key key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20 / 4),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: 20 / 4),
              height: 7,
              color: Color(0xFF0C9869).withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
