import 'package:flutter/material.dart';
import 'step_card.dart';
import 'Constants.dart';
import 'package:vision_check_test/completed_dreams.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'completed_dream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/step_builder.dart';

int deletedStepNumber;
bool weDeletedStepNumber = false;

class FinishedDreamConfirmation extends StatefulWidget {
  @override
  createState() => _FinishedDreamConfirmation();
}

class _FinishedDreamConfirmation extends State<FinishedDreamConfirmation> {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Are you sure you want to delete this dream?",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 170.0,
                  color: mainAccentColor,
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        CompletedDream cdCard =
                            completedDreamsList[completedDreamPositionPressed];
                        completedDreamsList
                            .removeAt(completedDreamPositionPressed);
                        Firestore.instance
                            .collection('users')
                            .document(loggedInUser.email)
                            .collection('completedDreams')
                            .document(cdCard.finishedUniqueNumber.toString())
                            .delete();
                        uniqueFinishedNumber--;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Container(
                  width: 170.0,
                  color: Colors.grey[200],
                  child: FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Nope!",
                        style:
                            TextStyle(color: mainAccentColor, fontSize: 30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
