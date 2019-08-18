import 'package:flutter/material.dart';
import 'components/step_card.dart';
import 'components/Constants.dart';
import 'home_page.dart';
import 'step_builder.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RepeatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/local_notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int deletedStepNumber;
bool weDeletedStepNumber = false;

class ConfirmationPage extends StatefulWidget {
  @override
  createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
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
              "Are you sure you have completed this step?",
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
                        "Yes!",
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        print(stepNumberPressed);
                        StepCard s = steps[stepNumberPressed];
                        deletedStepNumber = s.stepNumber;
                        if (s.cardWantsRemind == true) {
                          print("deleted from check");
                          flutterLocalNotificationPlugin.cancel(s.uniqueNumber);
                        }
                        for (int i = 0; i < steps.length; i++) {
                          StepCard sc = steps[i];
                          print(i);
                          if (weDeletedStepNumber == true) {
                            sc.stepIndex = i - 1;
                            print("new stepIndex ${i - 1}");
                          } else {
                            sc.stepIndex = i;
                            print("old stepIndex $i");
                          }
                          if (positionOfDreamPressed != 0) {
                            print("if amazing ${sc.stepIndex}");
                            if (i == deletedStepNumber - 1) {
                              weDeletedStepNumber = true;
                              continue;
                            }
                            Firestore.instance
                                .collection('users')
                                .document(loggedInUser.email)
                                .collection("dreams")
                                .document(fsTitleDelete)
                                .collection('stepListForDream')
                                .document((i + 1).toString())
                                .updateData({
                              'stepNumber': (i + 1),
                              'stepName': sc.stepName,
                              'cardDateVariable': sc.cardDateVariable,
                              'cardReminderDate': sc.cardReminderDate,
                              'cardReminderTime': sc.cardReminderTime,
                              'cardWantsRemind': sc.cardWantsRemind,
                              'repeatType': userSelection,
                              'uniqueNumber': sc.uniqueNumber,
                              'stepIndex': sc.stepIndex,
                            });
                          } else {
                            if (i == deletedStepNumber - 1) {
                              weDeletedStepNumber = true;
                              continue;
                            }

                            Firestore.instance
                                .collection('users')
                                .document(loggedInUser.email)
                                .collection("dreams")
                                .document(
                                    "dream" + dreamCards.length.toString())
                                .collection('stepListForDream')
                                .document((i + 1).toString())
                                .updateData({
                              'stepNumber': (i + 1),
                              'stepName': sc.stepName,
                              'cardDateVariable': sc.cardDateVariable,
                              'cardReminderDate': sc.cardReminderDate,
                              'cardReminderTime': sc.cardReminderTime,
                              'cardWantsRemind': sc.cardWantsRemind,
                              'repeatType': userSelection,
                              'uniqueNumber': sc.uniqueNumber,
                              'stepIndex': sc.stepIndex,
                            });
                          }
                        }
                        steps.removeAt(stepNumberPressed);
                        if (positionOfDreamPressed != 0) {
                          Firestore.instance
                              .collection('users')
                              .document(loggedInUser.email)
                              .collection("dreams")
                              .document(
                                  "dream" + (dreamCards.length - 1).toString())
                              .collection('stepListForDream')
                              .document((s.stepNumber).toString())
                              .delete();
                        } else {
                          Firestore.instance
                              .collection('users')
                              .document(loggedInUser.email)
                              .collection("dreams")
                              .document(
                                  "dream" + (dreamCards.length).toString())
                              .collection('stepListForDream')
                              .document((s.stepNumber).toString())
                              .delete();
                        }

                        for (int i = 0; i < steps.length; i++) {
                          StepCard sc = steps[i];
                          sc.stepIndex = i;
                        }
                        weDeletedStepNumber = false;
                        Navigator.of(context).pop();
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
