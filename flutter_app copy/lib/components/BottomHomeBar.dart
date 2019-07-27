import 'package:flutter/material.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:vision_check_test/settings_page.dart';
import 'package:vision_check_test/main.dart';
import 'package:vision_check_test/target_page.dart';
import 'package:page_transition/page_transition.dart';

class BottomHomeBar extends StatelessWidget {
  const BottomHomeBar();

  @override
  Widget build(BuildContext context) {
    return new BottomAppBar(
      color: Color(0xFFFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.gps_fixed,
              size: 35.0,
            ),
            onPressed: () {
              onHomePage = false;
              //when pressed this should lead to the target's page
              if (targetPageCalled != true) {
                onHomePage = false;
                onSettingsPage = false;
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: TargetPage()));
                targetPageCalled = true;
              }
              if (onSettingsPage == true) {
                onHomePage = false;
                onSettingsPage = false;
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: TargetPage()));
                targetPageCalled = true;
              }
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.home,
              size: 35.0,
            ),
            onPressed: () {
              //If already on home page dont do page transition
              //when pressed this should lead to the home page again
              if (onHomePage != true && targetPageCalled == true) {
                onSettingsPage = false;
                targetPageCalled = false;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                onHomePage = true;
              } else if (onHomePage != true && onSettingsPage) {
                onSettingsPage = false;
                targetPageCalled = false;
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: HomePage()));
              } else if (onHomePage != true) {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.downToUp, child: HomePage()));
              }
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.settings,
              size: 33.0,
            ),
            onPressed: () {
              onHomePage = false;
              //this  leads to the settings section
              if (onSettingsPage != true) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
                onSettingsPage = true;
              }
            },
          ),
        ],
      ),
    );
  }
}
