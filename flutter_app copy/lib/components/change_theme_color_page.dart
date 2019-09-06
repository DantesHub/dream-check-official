import 'package:flutter/material.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision_check_test/settings_page.dart';

class ChangeColor extends StatelessWidget {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ColorCategory(
              color: Color(0xFFDFDF26),
              colorName: "Gold",
              colorHex: "0xFFDFDF26",
            ),
            ColorCategory(
              color: Color(0xFF3333FF),
              colorName: "Blue",
              colorHex: "0xFF3333FF",
            ),
            ColorCategory(
              color: Color(0xFF35DDDC),
              colorName: "Turquoise",
              colorHex: "0xFF35DDDC",
            ),
            ColorCategory(
              color: Color(0xFFDF2626),
              colorName: "Red",
              colorHex: "0xFFDF2626",
            ),
            ColorCategory(
              color: Color(0xFFFF69B4),
              colorName: "Pink",
              colorHex: "0xFFFF69B4",
            ),
            ColorCategory(
              color: Color(0xFFA020F0),
              colorName: "Purple",
              colorHex: "0xFFA020F0",
            ),
            ColorCategory(
              color: Color(0xFFFF6600),
              colorName: "Orange",
              colorHex: "0xFFFF6600",
            ),
          ],
        ),
      ),
    );
  }
}

class ColorCategory extends StatelessWidget {
  ColorCategory(
      {@required this.color, @required this.colorName, @required colorHex});
  Color color;
  String colorName;
  String colorHex;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        mainAccentColor = this.color;
        //TODO: SAVE user Color in firebase
        Firestore.instance
            .collection('users')
            .document(loggedInUserString)
            .setData({
          'user': loggedInUserString,
          "wantsPopUp": wantsPopUpTest,
          'themeColor': this.color,
        });
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(this.colorName),
          Container(
            height: 20.0,
            width: 20.0,
            color: this.color,
          )
        ],
      ),
    );
  }
}
