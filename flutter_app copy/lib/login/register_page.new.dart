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
import 'package:firebase_auth/firebase_auth.dart';

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

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  bool _isIos;
  bool _isLoading;

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

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signUp(_email, _password);
        widget.auth.sendEmailVerification();
        _showVerifyEmailSentDialog();
        setState(() {
          _isLoading = false;
        });

        // if (userId.length > 0 && userId != null && _formMode == FormMode.LOGIN) {
        //   widget.onSignedIn();
        // }

      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  void _primarySubmit() async {}

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
    getCurrentUser();
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      // _formMode = FormMode.LOGIN;
    });
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
              _showBody(),
              _showCircularProgress(),
            ],
            //   SizedBox(
            //     height: 18.0,
            //   ),

            //   OvalButtonForLogIn(
            //     onPressed: () async {
            //       setState(() {
            //         loading = true;
            //       });
            //       try {
            //         final newUser = await _auth.createUserWithEmailAndPassword(
            //             email: email, password: password);
            //         if (newUser != null) {
            //           await _firestore
            //               .collection('users')
            //               .document(email)
            //               .setData(
            //                   {'wantsPopUp': true, 'themeColor': '0xFF15C96C'});
            //           registerWasPressed = true;
            //           isFinished = true;
            //           _ensureLoggedIn();
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) => HomePage()));
            //         }
            //       } catch (e) {
            //         if (password != password2) {
            //           loading = false;
            //           return showDialog(
            //             context: context,
            //             builder: (context) {
            //               return AlertDialog(
            //                 title: Text("Try again"),
            //                 content: Text(
            //                   "Passwords do not match",
            //                 ),
            //                 actions: <Widget>[
            //                   Center(
            //                     child: RaisedButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text(
            //                         "OK",
            //                         style: TextStyle(color: Colors.white),
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               );
            //             },
            //           );
            //         } else if (password.length < 6) {
            //           loading = false;
            //           return showDialog(
            //             context: context,
            //             builder: (context) {
            //               return AlertDialog(
            //                 title: Text("Try again"),
            //                 content: Text(
            //                   "Password length must be greater than 6 characters",
            //                 ),
            //                 actions: <Widget>[
            //                   Center(
            //                     child: RaisedButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text(
            //                         "OK",
            //                         style: TextStyle(color: Colors.white),
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               );
            //             },
            //           );
            //         } else {
            //           loading = false;
            //           return showDialog(
            //             context: context,
            //             builder: (context) {
            //               return AlertDialog(
            //                 title: Text("Try again"),
            //                 content: Text(
            //                   e.toString(),
            //                 ),
            //                 actions: <Widget>[
            //                   Center(
            //                     child: RaisedButton(
            //                       onPressed: () {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text(
            //                         "OK",
            //                         style: TextStyle(color: Colors.white),
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               );
            //             },
            //           );
            //         }
            //       }
            //     },
            //     color: mainAccentColor,
            //     text: 'Register',
            //   ),
            //   OvalButtonForLogIn(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     color: Colors.black,
            //     text: "Go Back",
            //   )
            // ],
          ),
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return new Container(
      height: 200.0,
      child: Center(
        child: Hero(
          tag: "logo",
          child: Icon(
            Icons.check,
            size: 174.0,
            color: Color(0xFF15C96C),
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: new Text('Go Back',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new OvalButtonForLogIn(
      onPressed: _primarySubmit,
      color: Color(0xFF15C96C),
      text: 'Register',
    );
  }
}
