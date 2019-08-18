import 'package:flutter/material.dart';
import 'Constants.dart';

class userNotProDialog extends StatefulWidget {
  @override
  _userNotProDialogState createState() => _userNotProDialogState();
}

class _userNotProDialogState extends State<userNotProDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: Text(
        "Non-Pro User",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              "Non-Pro users are limited to creating two dreams. To be able to create "
              "unlimited dreams consider going pro!",
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Container(
                  color: Colors.grey[200],
                  child: FlatButton(
                    onPressed: () {
                      //Code to make user become pro
                    },
                    child: Text(
                      "Go Pro!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: mainAccentColor),
                    ),
                  ),
                ),
                new Container(
                  color: Colors.black,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Close",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
