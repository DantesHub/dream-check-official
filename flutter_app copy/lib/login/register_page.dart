import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'oval_button_for_log.dart';
import 'constants.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:vision_check_test/components/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision_check_test/components/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'whatshouldhappen.dart';

bool registerWasPressed = false;

class RegisterPage extends StatefulWidget {
  static const String id = 'registration_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  bool loading = false;
  String email;
  String password;
  String password2;

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
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
              SizedBox(
                height: 18.0,
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
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password2 = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Re-enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              OvalButtonForLogIn(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      await _firestore
                          .collection('users')
                          .document(email)
                          .setData({'wantsPopUp': true});
                      registerWasPressed = true;
                      isFinished = true;
                      _ensureLoggedIn();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  } catch (e) {
                    if (password != password2) {
                      loading = false;
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Try again"),
                            content: Text(
                              "Passwords do not match",
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
                    } else if (password.length < 6) {
                      loading = false;
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Try again"),
                            content: Text(
                              "Password length must be greater than 6 characters",
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
                    } else {
                      loading = false;
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Try again"),
                            content: Text(
                              e.toString(),
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
                    }
                  }
                },
                color: mainAccentColor,
                text: 'Register',
              ),
              OvalButtonForLogIn(
                onPressed: () {
                  Navigator.pop(context);
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
