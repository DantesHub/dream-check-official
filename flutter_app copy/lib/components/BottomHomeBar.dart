import 'package:flutter/material.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:vision_check_test/settings_page.dart';
import 'package:vision_check_test/main.dart';
import 'Constants.dart';
import 'package:vision_check_test/target_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vision_check_test/completed_dreams.dart';

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
              size: 30.0,
              color: (onTargetPage == true) ? mainAccentColor : titleColor,
            ),
            onPressed: () {
              onHomePage = false;
              onFinishedDreams = false;
              //when pressed this should lead to the target's page
              if (onTargetPage != true) {
                onHomePage = false;
                onSettingsPage = false;
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: TargetPage()));
                onTargetPage = true;
              }
              if (onSettingsPage == true) {
                onHomePage = false;
                onSettingsPage = false;
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: TargetPage()));
                onTargetPage = true;
              }
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.home,
              size: 33.0,
              color: (onHomePage == true) ? mainAccentColor : titleColor,
            ),
            onPressed: () {
              //If already on home page dont do page transition
              //when pressed this should lead to the home page again
              onFinishedDreams = false;
              if (onHomePage != true && onTargetPage == true) {
                onSettingsPage = false;
                onTargetPage = false;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
                onHomePage = true;
              } else if (onHomePage != true && onSettingsPage) {
                onSettingsPage = false;
                onTargetPage = false;
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
              MdiIcons.trophyVariant,
              size: 33.0,
              color: (onFinishedDreams == true) ? mainAccentColor : titleColor,
            ),
            onPressed: () {
              onHomePage = false;
              onSettingsPage = false;
              onTargetPage = false;
              //this  leads to the settings section
              if (onFinishedDreams != true) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FinishedDreams()));
                onFinishedDreams = true;
              }
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.settings,
              size: 30.0,
              color: (onSettingsPage == true) ? mainAccentColor : titleColor,
            ),
            onPressed: () {
              onHomePage = false;
              onFinishedDreams = false;
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
