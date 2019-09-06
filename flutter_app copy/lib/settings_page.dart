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
import 'components/change_theme_color_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:launch_review/launch_review.dart';

//TODO: isUserPro should be changed to true and saved in firebase if user pays (non-consumable) one time payment
bool isUserPro = true;
bool onSettingsPage = false;

class Settings extends StatefulWidget {
  static const String id = 'settings_page';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const String iapId = 'paid_dreams';

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
    onHomePage = false;
    onTargetPage = false;
    super.initState();
    initPlatformState();
    getCurrentUser();
    onSettingsPage = true;
  }

  Future<void> initPlatformState() async {}

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
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Text(
              "Hold down dream to delete",
              style: TextStyle(color: Colors.grey, fontSize: 20.0),
            ),
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
                    activeTrackColor: mainAccentColor,
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
          //TODO: WHEN user presses they should be directed to rate on IOS or android
          // TODO: Done
          FlatButton(
            onPressed: () {LaunchReview.launch(androidAppId: "com.studyinghub.vision_check_test",
                iOSAppId: "1476432116");},
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  " Tap to Rate our app!",
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
          //TODO: if isUserPro is false, and user taps then they should be directed to pay $1.99
          (isUserPro == false)
              ? Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          " Your Pro!",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 18.0, 32.0, 18.0),
                        child: Icon(
                          Icons.mood,
                          size: 35.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : FlatButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        " Go Pro! (Unlimited dreams)",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Icon(
                          Icons.lock,
                          size: 35.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
          Divider(),
          Container(
            child: FlatButton(
              onPressed: () {
                //ONLY CHANGE IF USER IS PRO
                if (isUserPro == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeColor(),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      "Change theme (PRO FEATURE)",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(28.0, 18.0, 32.0, 18.0),
                    child: Icon(
                      Icons.edit,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    " Contact us with any questions \n or bugs you find!\n @dreamchecklab@gmail.com",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 18.0, 32.0, 18.0),
                  child: Icon(
                    Icons.mail,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
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
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomHomeBar(),
    );
  }
}
