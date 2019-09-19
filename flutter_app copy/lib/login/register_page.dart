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
import 'package:email_validator/email_validator.dart';


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
  String errorMessage = "";

  final _formKey = new GlobalKey<FormState>();

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
    if (_validateAndSave()) {
      setState(() {
        errorMessage = "";
        _isLoading = true;
      });
  
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
        if (newUser != null) {
          await _firestore
              .collection('users')
              .document(email)
              .setData(
                  {'wantsPopUp': true, 'themeColor': '0xFF15C96C'});
          registerWasPressed = true;
          isFinished = true;
          _ensureLoggedIn();

          setState(() {
            _isLoading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage()));
        }

        setState(() {
          _isLoading = false;
        });

      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    errorMessage = "";
    _isLoading = false;
    super.initState();
    getCurrentUser();
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    errorMessage = "";
    Navigator.pop(context);
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
          ),
        ),
      ),
    );
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

  }

  Widget _showBody(){
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              SizedBox(
                height: 18.0,
              ),
              _showEmailInput(),
              SizedBox(
                height: 8.0,
              ),
              _showPasswordInput(),
              SizedBox(
                height: 8.0,
              ),
              _showPassword2Input(),
              SizedBox(
                height: 24.0,
              ),
              _showPrimaryButton(),
              _showSecondaryButton(),
              SizedBox(
                height: 8.0,
              ),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (this.errorMessage != null && this.errorMessage.length > 0) {
      return new Text(
        errorMessage,
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
            color: mainAccentColor,
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(
          hintText: 'Enter Your Email'),
      maxLines: 1,
      autofocus: false,
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : (
        !EmailValidator.Validate(value, true) ? 'Not a valid email' : null
      ),
      onChanged: (value) => email = value.trim(),
    );
  }

  Widget _showPasswordInput() {
    return TextFormField(
      obscureText: true,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(
          hintText: 'Enter Your Password'),
      maxLines: 1,
      autofocus: false,
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : (
        value.length < 6 ? 'Password length must be greater than 6 characters' : null
      ),
      onChanged: (value) => password = value.trim(),
    );
  }

  Widget _showPassword2Input() {
    return TextFormField(
      obscureText: true,
      textAlign: TextAlign.center,
      decoration: kTextFieldDecoration.copyWith(
          hintText: 'Re-enter Your Password'),
      maxLines: 1,
      autofocus: false,
      validator: (value) => value.isEmpty ? 'Confirm Password can\'t be empty' : (
        value.length < 6 ? 'Password length must be greater than 6 characters' : (
          password != null && password.isNotEmpty && value != password ? 'Passwords do not match' : null
        )
      ),
      onChanged: (value) => password2 = value.trim(),
    );
  }

  Widget _showPrimaryButton() {
    return new OvalButtonForLogIn(
      onPressed: _validateAndSubmit,
      color: mainAccentColor,
      text: 'Register',
    );
  }

  Widget _showSecondaryButton() {
    return OvalButtonForLogIn(
      onPressed: _changeFormToLogin,
      color: Colors.black,
      text: "Go Back",
    );
  }
}
