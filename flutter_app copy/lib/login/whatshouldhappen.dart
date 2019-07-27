import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'oval_button_for_log.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vision_check_test/components/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_page.dart';

class WhatHappened extends StatefulWidget {
  @override
  _WhatHappenedState createState() => _WhatHappenedState();
}

class _WhatHappenedState extends State<WhatHappened> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Jedi",
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<FirebaseUser>(
          future: getUser(),
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Text("Jesus");
              default:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else if (snapshot.data == null)
                  return WelcomePage();
                else
                  print("holy!");
                return HomePage();
            }
          }),
    );
  }
}
