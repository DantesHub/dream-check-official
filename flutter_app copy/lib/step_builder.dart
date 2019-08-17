import 'package:flutter/material.dart';
import 'components/BottomHomeBar.dart';
import 'components/category_icons.dart';
import 'StepMakerPage.dart';
import 'components/step_card.dart';
import 'components/Constants.dart';
import 'home_page.dart';
import 'components/dream_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RepeatPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/Confirmation.dart';
import 'settings_page.dart';
import 'components/choices_constants.dart';
import 'finished_dream_alert.dart';
import 'package:intl/intl.dart';
import 'components/popup_item.dart';
import 'completed_dreams.dart';
import 'components/completed_dream.dart';
import 'components/alert_dialog.dart';

int uniqueFinishedNumber = 0;
List<StepCard> steps;
bool wantsPopUp = true;
bool onStepBuilderPage = false;
bool checkBoxState = false;

class Steps extends StatefulWidget {
  IconData icon;
  List<StepCard> stepsList;
  String title;
  Steps({@required this.icon, @required this.stepsList, @required this.title});
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
        if (wantsPopUp == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showInstructions();
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void _showInstructions() async {
    await showDialog(
        context: context,
        builder: (_) {
          return new MyDialog(
            loggedInUser: loggedInUser,
          );
        });
  }

  Expanded _buildCardList(context) {
    return Expanded(
      child: SafeArea(
        child: ReorderableListView(
          children: widget.stepsList
              .map((item) => new Dismissible(
                    key: GlobalKey(),
                    onDismissed: (direction) {
                      setState(() {
                        StepCard ss = item;
                        if (ss.cardWantsRemind == true) {
                          print("deleted from swipe");
                          flutterLocalNotificationPlugin
                              .cancel(ss.uniqueNumber);
                        }
                        deletedStepNumber = item.stepNumber;
                        for (int i = 0; i < steps.length; i++) {
                          StepCard sc = steps[i];
                          if (weDeletedStepNumber == true) {
                            sc.stepIndex = i - 1;
                          } else {
                            sc.stepIndex = i;
                          }
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
                        widget.stepsList
                            .removeAt(widget.stepsList.indexOf(item));
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
                              .document(
                                  "dream" + (dreamCards.length).toString())
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
                      key: new GlobalKey(),
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
            Future.delayed(Duration(milliseconds: 20), () {
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
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    steps = widget.stepsList;
    super.initState();
    onStepBuilderPage = true;
    getCurrentUser();
  }

  List<StepCard> stepsClone;

  void _choiceSelected(Item choice) {
    setState(() {
      if (addDreamGotPressed == false) {
        if (choice == Choices.Add) {
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
        } else if (choice == Choices.Done) {
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
              'position': dreamCards.length,
              'icon': chosenCategoryText,
            });
          }
          setState(() {
            stepsClone = List.from(widget.stepsList);
            if (addDreamGotPressed == true) {
              dreamCards.add(new DreamCard(
                icon: usersIconData,
                dreamTitle: userDreamTitle,
                stepList: stepsClone,
                position: dreamCards.length,
                fsTitle: "dream" + dreamCards.length.toString(),
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
        } else if (choice == Choices.Finished) {
          if (widget.stepsList.length != 0) {
            showDialog(
                context: context,
                builder: (_) {
                  return FinishedDreamAlert(
                    dreamTitle: widget.title,
                    iconData: widget.icon,
                  );
                });
          } else {
            for (int i = 1; i < dreamCards.length; i++) {
              Firestore.instance
                  .collection('users')
                  .document(loggedInUser.email)
                  .collection("dreams")
                  .document("dream" + i.toString())
                  .collection("stepListForDream")
                  .getDocuments()
                  .then((snapshot) {
                for (DocumentSnapshot ds in snapshot.documents) {
                  ds.reference.delete();
                }
              });
            }
            dreamCards.removeAt(positionOfDreamPressed);
            counter--;
            for (int i = 1; i < dreamCards.length; i++) {
              DreamCard d = dreamCards[i];
              d.position = i;
            }
            for (int i = 1; i < dreamCards.length; i++) {
              DreamCard dCard = dreamCards[i];
              Firestore.instance
                  .collection('users')
                  .document(loggedInUser.email)
                  .collection("dreams")
                  .document("dream" + i.toString())
                  .setData({
                'title': dCard.dreamTitle,
                'position': dCard.position,
                'icon': inverseIconMap[dCard.icon],
              });
            }
            Firestore.instance
                .collection('users')
                .document(loggedInUser.email)
                .collection("dreams")
                .document("dream" + (dreamCards.length).toString())
                .delete();
            removedDream = true;
            onFinishedDreams = true;
            var now = new DateTime.now();
            completedDreamsList.add(new CompletedDream(
              dreamText: widget.title,
              iconData: inverseIconMap[widget.icon],
              dateCompleted: new DateFormat("dd-MM-yyyy").format(now),
              finishedUniqueNumber: uniqueFinishedNumber,
            ));
            Firestore.instance
                .collection('users')
                .document(loggedInUser.email)
                .collection("completedDreams")
                .document(uniqueFinishedNumber.toString())
                .setData({
              "title": widget.title,
              "icon": inverseIconMap[widget.icon],
              "dateCompleted": new DateFormat("dd-MM-yyyy").format(now),
              "uniqueFinishedNumber": uniqueFinishedNumber,
            });
            print("unq $uniqueFinishedNumber");
            uniqueFinishedNumber++;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FinishedDreams(),
              ),
            );
          }
        }
      } else if (addDreamGotPressed == true) {
        if (choice == Choices.Add || choice == AddDreamChoices.Add) {
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
        } else if (choice == Choices.Done || choice == AddDreamChoices.Done) {
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
              'position': dreamCards.length,
              'icon': chosenCategoryText,
            });
          }
          setState(() {
            stepsClone = List.from(widget.stepsList);
            if (addDreamGotPressed == true) {
              dreamCards.add(new DreamCard(
                icon: usersIconData,
                dreamTitle: userDreamTitle,
                stepList: stepsClone,
                position: dreamCards.length,
                fsTitle: "dream" + dreamCards.length.toString(),
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
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.stepsList = steps;
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<Item>(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          itemBuilder: (addDreamGotPressed == false)
              ? (BuildContext context) {
                  return Choices.choices.map((Item choice) {
                    return new PopupMenuItem<Item>(
                      value: choice,
                      child: new ListTile(
                        title: choice.title,
                        trailing: choice.icon,
                      ),
                    );
                  }).toList();
                }
              : (BuildContext context) {
                  return AddDreamChoices.finisheddreamchoices
                      .map((Item choice) {
                    return new PopupMenuItem<Item>(
                      value: choice,
                      child: new ListTile(
                        title: choice.title,
                        trailing: choice.icon,
                      ),
                    );
                  }).toList();
                },
          onSelected: _choiceSelected,
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                widget.icon,
                color: mainAccentColor,
                size: 30,
              ),
            ),
            Container(
              child: Flexible(
                child: Text(
                  widget.title,
                  //"Steps to achieve dream",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: titleColor,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (widget.stepsList.length != 0)
                ? _buildCardList(context)
                : Padding(
                    padding: EdgeInsets.only(bottom: 120.0),
                    child: Text(
                      "No Dreams yet\nto add a step press \nthe icon on the top left\nMUST PRESS Done \nediting to save work",
                      style: TextStyle(color: Colors.grey[700], fontSize: 20.0),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
