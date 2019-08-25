import 'package:flutter/material.dart';
import 'components/BottomHomeBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';
import 'components/step_card.dart';
import 'components/Constants.dart';
import 'components/target_page_step_card.dart';
import 'step_builder.dart';
import 'components/dream_card.dart';

String loggedInUserTargetPage;
bool targetInitCalled = false;
List<TargetCard> firstStepList = new List<TargetCard>();
HomePage h = new HomePage();
bool onTargetPage = false;

class TargetPage extends StatefulWidget {
  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 20.0);

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        loggedInUserTargetPage = loggedInUser.email;
      }
    } catch (e) {
      print("************\n***********" + e);
    }
  }

  @override
  void initState() {
    print("target page inited");
    checkDifference();
    super.initState();
    getCurrentUser();
    onTargetPage = true;
  }

  void checkDifference() {
    firstStepList.clear();
    TargetCard tc;
    for (int i = 1; i < dreamCards.length; i++) {
      DreamCard d = dreamCards[i];
      StepCard s;
      if (d.stepList.length > 0) {
        s = d.stepList.elementAt(0);
        tc = new TargetCard(
            dreamTitle: d.dreamTitle,
            stepNumber: s.stepNumber,
            stepName: s.stepName,
            cardReminderDate: s.cardReminderDate,
            cardReminderTime: s.cardReminderTime,
            cardWantsRemind: s.cardWantsRemind,
            cardDateVariable: s.cardDateVariable,
            icon: d.icon,
            stepsList: d.stepList);
      }
      if (d.stepList.length > 0 && !firstStepList.contains(tc)) {
        firstStepList.add(tc);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 20.0,
        backgroundColor: Colors.white,
        title: Text(
          'Target Steps',
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
              onTargetPage = false;
              onHomePage = true;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: (firstStepList.length == 0)
            ? Text(
                "You have no steps \nto be completed",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 20.0),
              )
            : ListView.builder(
                // Must have an item count equal to the number of items!
                itemCount: firstStepList.length,
                controller: _scrollController,

                // A callback that will return a widget.
                itemBuilder: (context, index) {
                  // In our case, a stepCard for each step
                  return Dismissible(
                    key: new Key(UniqueKey().toString()),
                    child: firstStepList[index],
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomHomeBar(),
    );
  }
}
