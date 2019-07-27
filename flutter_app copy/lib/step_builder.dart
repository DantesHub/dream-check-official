import 'package:flutter/material.dart';
import 'components/BottomHomeBar.dart';
import 'components/category_icons.dart';
import 'StepMakerPage.dart';
import 'components/step_card.dart';
import 'components/Constants.dart';
import 'home_page.dart';
import 'components/dream_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RepeatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/local_notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/Confirmation.dart';
import 'settings_page.dart';

List<StepCard> steps;

class Steps extends StatefulWidget {
  IconData icon;
  List<StepCard> stepsList;
  Steps({@required this.icon, @required this.stepsList});
  static const String id = "id";
  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 20.0);

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

  Expanded _buildCardList(context) {
    return Expanded(
      child: ReorderableListView(
        children: widget.stepsList
            .map((item) => Dismissible(
                  key: new Key(UniqueKey().toString()),
                  onDismissed: (direction) {
                    setState(() {
                      StepCard ss = item;
                      if (ss.cardWantsRemind == true) {
                        print("deleted from swipe");
                        flutterLocalNotificationPlugin.cancel(ss.uniqueNumber);
                      }
                      deletedStepNumber = item.stepNumber;
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
                            'repeatType': sc.repeatType,
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
                              .document("dream" + dreamCards.length.toString())
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
                      widget.stepsList.removeAt(widget.stepsList.indexOf(item));
                      stepIndexCounter--;
                      if (positionOfDreamPressed != 0) {
                        Firestore.instance
                            .collection('users')
                            .document(loggedInUser.email)
                            .collection("dreams")
                            .document(
                                "dream" + (dreamCards.length - 1).toString())
                            .collection('stepListForDream')
                            .document((item.stepNumber).toString())
                            .delete();
                      } else {
                        Firestore.instance
                            .collection('users')
                            .document(loggedInUser.email)
                            .collection("dreams")
                            .document("dream" + (dreamCards.length).toString())
                            .collection('stepListForDream')
                            .document((item.stepNumber).toString())
                            .delete();
                      }
                      weDeletedStepNumber = false;
                      for (int i = 0; i < widget.stepsList.length; i++) {
                        StepCard sc = widget.stepsList[i];
                        sc.stepIndex = i;
                      }
                    });
                  },
                  direction: DismissDirection.endToStart,
                  child: new StepCard(
                    key: new Key(UniqueKey().toString()),
                    stepNumber: item.stepNumber,
                    stepName: item.stepName,
                    cardReminderDate: item.cardReminderDate,
                    cardReminderTime: item.cardReminderTime,
                    cardDateVariable: item.cardDateVariable,
                    cardWantsRemind: item.cardWantsRemind,
                    repeatType: item.repeatType,
                    uniqueNumber: item.uniqueNumber,
                    stepIndex: item.stepIndex,
                  ),
                ))
            .toList(),
        onReorder: (int start, int current) {
          // dragging from top to bottom
          if (start < current) {
            int end = current - 1;
            StepCard startItem = steps[start];
            int i = 0;
            int local = start;
            do {
              steps[local] = steps[++local];
              i++;
            } while (i < end - start);
            widget.stepsList[end] = startItem;
          }
          // dragging from bottom to top
          else if (start > current) {
            StepCard startItem = widget.stepsList[start];
            for (int i = start; i > current; i--) {
              widget.stepsList[i] = widget.stepsList[i - 1];
            }
            widget.stepsList[current] = startItem;
          }

          //REOREDER SETSTATE
          setState(() {
            for (int i = 0; i < widget.stepsList.length; i++) {
              StepCard sc = widget.stepsList[i];
              sc.stepNumber = i + 1;
              sc.stepIndex = i;
            }

            for (int i = 0; i <= steps.length; i++) {
              print(i);
              if (positionOfDreamPressed != 0) {
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
                    .delete();
              } else {
                if (i == deletedStepNumber - 1) {
                  weDeletedStepNumber = true;
                  continue;
                }
                Firestore.instance
                    .collection('users')
                    .document(loggedInUser.email)
                    .collection("dreams")
                    .document("dream" + dreamCards.length.toString())
                    .collection('stepListForDream')
                    .document((i + 1).toString())
                    .delete();
              }
            }

            for (int i = 0; i < widget.stepsList.length; i++) {
              print("Whatsup");
              StepCard sc = widget.stepsList[i];
              if (positionOfDreamPressed != 0) {
                Firestore.instance
                    .collection('users')
                    .document(loggedInUser.email)
                    .collection("dreams")
                    .document(fsTitleDelete)
                    .collection('stepListForDream')
                    .document((i + 1).toString())
                    .setData({
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
                Firestore.instance
                    .collection('users')
                    .document(loggedInUser.email)
                    .collection("dreams")
                    .document("dream" + dreamCards.length.toString())
                    .collection('stepListForDream')
                    .document((i + 1).toString())
                    .setData({
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
            weDeletedStepNumber = false;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    steps = widget.stepsList;
    print("From initState stepbuilder");
    super.initState();
    getCurrentUser();
  }

  List<StepCard> stepsClone;
  Card tempForAddingButtonInQueue;
  bool pressedAddForFirstTime = false;

  @override
  Widget build(BuildContext context) {
    widget.stepsList = steps;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  "Steps to Success",
                  //"Steps to achieve dream",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF15C96C),
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Icon(
                  widget.icon,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ],
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
              Navigator.pop(context);
            },
          ),
        ],
//
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 8.0,
                      height: 40.0,
                      minWidth: 50.0,
                      color: mainAccentColor,
                      textColor: Colors.white,
                      onPressed: () {
                        onHomePage = true;
                        onSettingsPage = false;
                        if (addDreamGotPressed == true) {
                          _firestore
                              .collection('users')
                              .document(loggedInUser.email.toString())
                              .collection("dreams")
                              .document("dream" + dreamCards.length.toString())
                              .setData({
                            'title': userDreamTitle,
                            'position': dreamCards.length.toString(),
                            'icon': chosenCategoryText,
                          });
                        }
                        setState(() {
                          stepsClone = List.from(widget.stepsList);
                          print('Cloned list: $stepsClone');
                          if (addDreamGotPressed == true) {
                            dreamCards.add(new DreamCard(
                              icon: usersIconData,
                              dreamTitle: userDreamTitle,
                              stepList: stepsClone,
                              position: dreamCards.length,
                              fsTitle: "dream" + counter.toString(),
                            ));
                            counter++;
                            stepIndexCounter = 0;
                            widget.stepsList.clear();
                            addDreamGotPressed = false;
                            editStepWasPressed = false;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        });
                      },
                      splashColor: Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "FINISHED",
                          style: TextStyle(
                            fontSize: 15.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 8.0,
                      height: 40.0,
                      minWidth: 50.0,
                      color: Colors.black,
                      textColor: Colors.white,
                      onPressed: () {
                        editStepWasPressed = false;
                        notificationFormatDay = "Day";
                        stepIndexCounter = widget.stepsList.length;
                        userSelection = "Repeat";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new StepMaker(
                                  "Time",
                                  "",
                                  "Target Date",
                                  false,
                                  "Day",
                                  "Repeat",
                                ),
                          ),
                        );
                      },
                      splashColor: Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Add Step",
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (widget.stepsList.length != 0)
                ? _buildCardList(context)
                : Text(
                    "No Dreams yet\n Swipe left to delete step\nTap step to edit"),
          ],
        ),
      ),
      bottomNavigationBar: new BottomHomeBar(),
    );
  }
}
