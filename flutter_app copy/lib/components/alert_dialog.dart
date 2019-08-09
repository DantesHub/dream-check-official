import 'package:flutter/material.dart';
import 'package:vision_check_test/step_builder.dart';
import 'Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDialog extends StatefulWidget {
  MyDialog({this.loggedInUser});

  FirebaseUser loggedInUser;
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      title: Text(
        "Tips",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "1. ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 10.0,
                height: 10.0,
              ),
              Text(
                  "Slide left to delete a \nstep card, this will not \nrenumber your list.\n")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "2. ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 10.0,
                height: 10.0,
              ),
              Text(
                  "Tap a card to edit it, \npress the green check \nto complete a step\n Does not renumber list\n")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "3. ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 10.0,
                height: 10.0,
              ),
              Text(
                  "Long press a card \nto rearrange \nand renumber your list\n")
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                "4. ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 10.0,
                height: 10.0,
              ),
              Text(
                  "Once you complete your \ndream (at least 3 steps)\n it will be added to\n your trophy case\n")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Switch(
                  activeColor: mainAccentColor,
                  activeTrackColor: Colors.greenAccent,
                  value: wantsPopUp,
                  onChanged: (value) {
                    setState(() {
                      print(value);
                      wantsPopUp = value;
                      Firestore.instance
                          .collection('users')
                          .document(widget.loggedInUser.email)
                          .setData({
                        'user': widget.loggedInUser.email,
                        "wantsPopUp": wantsPopUp,
                      });
                    });
                  }),
              Text(
                "Toggle off to stop Tip\n pop up",
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
