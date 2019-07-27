import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'oval_button_for_log.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:vision_check_test/components/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool loggedIn = false;

class WelcomePage extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

//  Future<FirebaseUser> getUser() async {
//    return await _auth.currentUser();
//  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Dream Check',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 5.0),
                  child: Hero(
                    tag: "logo",
                    child: Icon(
                      Icons.check,
                      size: 54.0,
                      color: mainAccentColor,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            OvalButtonForLogIn(
              onPressed: () {
                //Go to login screen.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              text: 'Log In',
              color: Colors.black,
            ),
            OvalButtonForLogIn(
              onPressed: () {
                //Go to registration screen.
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              text: 'Register',
              color: mainAccentColor,
            ),
          ],
        ),
      ),
    );
  }
}
