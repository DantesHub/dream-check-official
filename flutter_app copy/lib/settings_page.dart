import 'package:flutter/material.dart';
import 'components/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login/welcome_page.dart';
import 'login/oval_button_for_log.dart';
import 'home_page.dart';
import 'target_page.dart';
import 'restart_widget.dart';
import 'components/BottomHomeBar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login/login_page.dart';

bool onSettingsPage = false;

class Settings extends StatefulWidget {
  static const String id = 'settings_page';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  _logOut() async {
    print("DELETED");
    await Firestore.instance
        .collection('users')
        .document(loggedInUser.email)
        .delete();
    await _auth.signOut().then((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    onSettingsPage = true;
  }

  void getCurrentUser() async {
    try {
      print("wattup about here");
      final user = await _auth.currentUser();
      if (user != null) {
        print("we got here");
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF39414C),
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              if (targetPageCalled == true) {
                onHomePage = false;
                targetPageCalled = true;
              } else if (onHomePage == true) {
                targetPageCalled = false;
                onHomePage = true;
              }
              onSettingsPage = false;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Hold down dream to delete",
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
          Center(
            child: OvalButtonForLogIn(
              onPressed: () {
                _logOut();
                editStepWasPressed = false;
                onSettingsPage = false;
                counter = 1;
                initStateCalled = false;
                isFinished = false;
                flutterLocalNotificationPlugin.cancelAll();
                firstStepList.clear();
                dreamCards.clear();
              },
              text: "Logout",
              color: Colors.redAccent,
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomHomeBar(),
    );
  }
}
