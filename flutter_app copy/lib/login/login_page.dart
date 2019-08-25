import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'constants.dart';
import 'oval_button_for_log.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision_check_test/components/Constants.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:vision_check_test/target_page.dart';
import 'package:page_transition/page_transition.dart';
import 'welcome_page.dart';
import 'package:vision_check_test/components/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  bool loading = false;
  String email;
  String recoverEmail;
  String password;
  bool sent = false;

  Future<Null> _ensureLoggedIn() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    //sign in the user here and if it is successful then do following

    prefs.setString("username", email);
    this.setState(() {
      /*
     updating the value of loggedIn to true so it will
     automatically trigger the screen to display homeScaffold.
  */
      loggedIn = true;
    });
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
          child: ListView(
            children: <Widget>[
              Container(
                height: 200.0,
                child: Center(
                  child: Hero(
                    tag: "logo",
                    child: Icon(
                      Icons.check,
                      size: 174.0,
                      color: mainAccentColor,
                    ),
                  ),
                ),
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    //Do something with the user input.
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password'),
              ),
              Center(
                child: FlatButton(
                    child: Text(
                      "Reset Your Password",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () async {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Send password reset link to"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  onChanged: (value) {
                                    //Do something with the user input.
                                    recoverEmail = value;
                                  },
                                  decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Enter email'),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        color: Colors.black,
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            sent = false;
                                          });
                                        },
                                        child: Text(
                                          "Done",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        color: mainAccentColor,
                                        onPressed: () {
                                          try {
                                            resetPassword(recoverEmail);
                                          } catch (e) {
                                            print(e);
                                          }
                                          return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Sent!",
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: Text(
                                                  "We have just sent the email, wait up to 3 minutes",
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: <Widget>[
                                                  Center(
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        Navigator.popUntil(
                                                            context,
                                                            ModalRoute.withName(
                                                                LoginPage.id));
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "SEND",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      );
//
                    }),
              ),
              SizedBox(
                height: 14.0,
              ),
              OvalButtonForLogIn(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  try {
                    final user = await Auth()
                        .signInWithEmailAndPassword(email, password);
                    if (user != null) {
                      _firestore.collection('users').document(email).setData({
                        'user': email,
                      });
                      _ensureLoggedIn();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new HomePage()));
                    }
                  } catch (e) {
                    loading = false;
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Try again"),
                          content: Text(
                            "UserName or Password was incorrect, please try again",
                          ),
                          actions: <Widget>[
                            Center(
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                    print("You effed up");
                  }
                },
                color: mainAccentColor,
                text: 'Log In',
              ),
              OvalButtonForLogIn(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: WelcomePage()));
                },
                color: Colors.black,
                text: "Go Back",
              )
            ],
          ),
        ),
      ),
    );
  }
}
