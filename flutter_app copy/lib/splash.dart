import 'package:flutter/material.dart';
import 'components/auth.dart';
import 'login/login_page.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _handleStartScreen();
  }

  Future<void> _handleStartScreen() async {
    Auth _auth = Auth();
    if (await _auth.isLoggedIn()) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }
}
