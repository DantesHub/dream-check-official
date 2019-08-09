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
import 'package:vision_check_test/components/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool loggedIn = false;

class WhatHappened extends StatefulWidget {
  WhatHappened({this.auth});
  final BaseAuth auth;

  @override
  _WhatHappenedState createState() => _WhatHappenedState();
}

class _WhatHappenedState extends State<WhatHappened> {
  @override
  void initState() {
    super.initState();
    this._function();
  }

  Future<Null> _function() async {
    /**
        This Function will be called every single time
        when application is opened and it will check
        if the value inside Shared Preference exist or not
     **/
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      print("prefs getting username = ${prefs.getString("username")}");
      if (prefs.getString("username") != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
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
        home: (loggedIn == true) ? HomePage() : WelcomePage());
  }
}

//  @override
//  void initState() {
//    super.initState();
////    widget.auth.currentUser().then((userId) {
////      setState(() {
////        authStatus =
////            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
////      });
////    });
//  }
//
//  void _signedIn() {
//    setState(() {
//      authStatus = AuthStatus.signedIn;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    switch (authStatus) {
//      case AuthStatus.notSignedIn:
//        return new LoginPage(
//          auth: widget.auth,
//        );
//      case AuthStatus.signedIn:
//        return new HomePage();
//    }
//  }
//}
