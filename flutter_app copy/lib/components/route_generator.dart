import 'package:flutter/material.dart';
import 'package:vision_check_test/login/welcome_page.dart';
import 'package:vision_check_test/step_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vision_check_test/splash.dart';
import 'package:vision_check_test/login/whatshouldhappen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Getting arguments passed in while called calling Navigator.push

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomePage());
      case 'home':
        return MaterialPageRoute(builder: (context) => HomePage());
      default:
        return MaterialPageRoute(builder: (context) => WelcomePage());
    }
  }
}
