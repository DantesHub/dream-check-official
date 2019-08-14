import 'package:flutter/material.dart';
import 'components/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login/welcome_page.dart';
import 'login/oval_button_for_log.dart';
import 'home_page.dart';
import 'target_page.dart';
import 'components/BottomHomeBar.dart';
import 'login/register_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/dream_card.dart';
import 'completed_dreams.dart';
import 'step_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<Null> logoutUser() async {
    print("WERE LOGGING OUT");
    //logout user
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    await _logOut();
    prefs.clear();
    this.setState(() {
      /*
     updating the value of loggedIn to false so it will
     automatically trigger the screen to display loginScaffold.
  */
      loggedIn = false;
    });
  }

  _logOut() async {
    print("SIGNED OUT");
    await _auth.signOut().then((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
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
              if (onTargetPage == true) {
                onHomePage = false;
                onTargetPage = true;
              } else if (onHomePage == true) {
                onTargetPage = false;
                onHomePage = true;
              }
              onSettingsPage = false;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Hold down dream to delete",
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "\t  Toggle off to stop Tip pop up",
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Switch(
                    activeColor: mainAccentColor,
                    activeTrackColor: Colors.greenAccent,
                    value: wantsPopUp,
                    onChanged: (value) {
                      setState(() {
                        wantsPopUp = value;
                        Firestore.instance
                            .collection('users')
                            .document(loggedInUser.email)
                            .setData({
                          'user': loggedInUser.email,
                          "wantsPopUp": wantsPopUp,
                        });
                      });
                    }),
              ),
            ],
          ),
          Divider(),
          FlatButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Tap to Rate our app!",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(
                    Icons.star_border,
                    size: 35.0,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Center(
            child: OvalButtonForLogIn(
              onPressed: () {
                for (int i = 1; i < dreamCards.length; i++) {
                  DreamCard dCard = dreamCards[i];
                  dCard.stepList.clear();
                }
                completedDreamsList.clear();
                registerWasPressed = false;
                logoutUser();
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
