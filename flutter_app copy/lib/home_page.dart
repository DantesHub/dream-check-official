import 'package:flutter/material.dart';
import 'components/BottomHomeBar.dart';
import "components/dream_card.dart";
import "components/Constants.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DreamTitleMakerPage.dart';
import 'login/register_page.dart';
import 'components/step_card.dart';
import 'restart_widget.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/whatshouldhappen.dart';
import 'step_builder.dart';
import 'completed_dreams.dart';
import 'settings_page.dart';
import 'components/completed_dream.dart';
import 'components/user_isnt_pro_alert.dart';

String pressedThemeColor;
Color mainAccentColor = Color(0xFF15C96C);
String mainAccentColorString;
String fsTitleDelete;
int counter = 1;
String userDreamTitle;
bool addDreamGotPressed;
int positionOfDreamPressed;
bool onHomePage = false;
bool calledAlready = false;
bool isFinished = false;
bool alreadyCalled = false;
int length;
int highestUniqueNumber = 0;
int highestCdUniqueNumber = 0;
bool removedDream = false;
bool initStateCalled = false;
bool wantsPopUpTest = false;

List<String> dreamTitles = new List<String>();
List<IconData> icons = new List<IconData>();
List<int> positions = new List<int>();

String loggedInUserString;

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 20.0);
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> getCurrentUser() async {
    try {
      print("were over here");
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        loggedInUserString = loggedInUser.email;
        await _firestore
            .collection('users')
            .document(loggedInUser.email)
            .updateData({
          'user': loggedInUser.email,
        });
        _ensureLoggedIn();
      } else {
        print("user is null");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print("home page initState");
    super.initState();
    onHomePage = true;
    if (!initStateCalled) {
      calledAlready = false;
      if (registerWasPressed == false) {
        getData();
      }
    }
    initStateCalled = true;
    onHomePage = true;
  }

  NotificationDetails get _ongoing {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: true,
    );
    final iOSChannelSpecifics = IOSNotificationDetails();
    return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
  }

  Future<Null> _ensureLoggedIn() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();

    //sign in the user here and if it is successful then do following

    prefs.setString("username", loggedInUser.email);
    this.setState(() {
      /*
     updating the value of loggedIn to true so it will
     automatically trigger the screen to display homeScaffold.
  */
      loggedIn = true;
    });
  }

  Future<void> getData() async {
    print("were over here");
    await getCurrentUser();
    if (calledAlready == false) {
      List<StepCard> sCards;
      try {
        print("getting from firestore");
        await _firestore
            .collection('users')
            .document(loggedInUser.email)
            .get()
            .then((DocumentSnapshot) =>
                wantsPopUpTest = DocumentSnapshot.data['wantsPopUp']);
        await _firestore
            .collection('users')
            .document(loggedInUser.email)
            .get()
            .then((DocumentSnapshot) =>
                mainAccentColorString = DocumentSnapshot.data['themeColor']);
      } catch (e) {
        print(e);
        return;
      }
      if (wantsPopUpTest != null) {
        wantsPopUp = wantsPopUpTest;
        print('wantsPopUPPPP $wantsPopUp');
      } else {
        wantsPopUpTest = true;
      }

      final completedDreams = await _firestore
          .collection('users')
          .document(loggedInUserString)
          .collection('completedDreams')
          .getDocuments();
      for (var cd in completedDreams.documents) {
        final dateCompleted = cd.data['dateCompleted'];
        final icon = cd.data['icon'];
        final title = cd.data['title'];
        final fireCdUniqueNumber = cd.data['uniqueFinishedNumber'];

        completedDreamsList.add(
          new CompletedDream(
            dreamText: title,
            iconData: icon,
            dateCompleted: dateCompleted,
            finishedUniqueNumber: fireCdUniqueNumber,
          ),
        );
        if (fireCdUniqueNumber != null) {
          if (fireCdUniqueNumber >= highestCdUniqueNumber) {
            highestCdUniqueNumber = fireCdUniqueNumber;
          }
        }
      }

      final dreams = await _firestore
          .collection('users')
          .document(loggedInUserString)
          .collection('dreams')
          .getDocuments();
      length = dreams.documents.length.toInt();
      for (var d in dreams.documents) {
        final dreamTitle = d.data['title'];
        final iconTitle = d.data['icon'];
        icons.add(iconMap[iconTitle]);

        final position = d.data['position'];

        positions.add(position);
        final fireSteps = await _firestore
            .collection('users')
            .document(loggedInUserString)
            .collection('dreams')
            .document('dream' + dreamCards.length.toString())
            .collection('stepListForDream')
            .getDocuments();

        sCards = new List<StepCard>();

        for (var step in fireSteps.documents) {
          final stepTitle = step.data['stepName'];
          final stepNumber = step.data['stepNumber'];
          final repeatType = step.data['repeatType'];
          final cardWantsRemind = step.data['cardWantsRemind'];
          final cardReminderTime = step.data['cardReminderTime'];
          final cardReminderDate = step.data['cardReminderDate'];
          final cardDateVariable = step.data['cardDateVariable'];
          final uniqueNumberr = step.data['uniqueNumber'];
          final stepIndex = step.data['stepIndex'];

          if (uniqueNumberr != null) {
            if (uniqueNumberr >= highestUniqueNumber) {
              highestUniqueNumber = uniqueNumberr;
            }
          }

          sCards.add(
            new StepCard(
              stepNumber: stepNumber,
              stepName: stepTitle,
              cardReminderDate: cardReminderDate,
              cardReminderTime: cardReminderTime,
              cardWantsRemind: cardWantsRemind,
              cardDateVariable: cardDateVariable,
              stepIndex: stepIndex,
              repeatType: repeatType,
              uniqueNumber: uniqueNumberr,
            ),
          );

          if (cardWantsRemind == true && repeatType == "Every Day") {
            notificationFormatTime = cardReminderTime;
            if (notificationFormatTime.substring(6, 8) == 'PM') {
              int x = int.parse(notificationFormatTime.substring(0, 2));
              int y = x + 12;
              String z = notificationFormatTime.substring(2, 5);
              notificationFormatTime = y.toString() + z;
            } else {
              notificationFormatTime = notificationFormatTime.substring(0, 5);
            }
            Time t = new Time(
                int.parse((notificationFormatTime.substring(0, 2))),
                int.parse((notificationFormatTime.substring(3, 5))),
                0);
            flutterLocalNotificationPlugin.showDailyAtTime(
              uniqueNumberr,
              "Dream Check!",
              stepTitle,
              t,
              _ongoing,
            );
          } else if (cardWantsRemind == true && repeatType == "Every Week") {
            notificationFormatTime = cardReminderTime;
            if (notificationFormatTime.substring(6, 8) == 'PM') {
              int x = int.parse(notificationFormatTime.substring(0, 2));
              int y = x + 12;
              String z = notificationFormatTime.substring(2, 5);
              notificationFormatTime = y.toString() + z;
            } else {
              notificationFormatTime = notificationFormatTime.substring(0, 5);
            }
            Time t = new Time(
                int.parse((notificationFormatTime.substring(0, 2))),
                int.parse((notificationFormatTime.substring(3, 5))),
                0);
            print("not date $cardReminderDate");
            DateTime dt = DateTime.parse(cardReminderDate);
            String dayOfTheWeekk = new DateFormat("EEEE").format(dt);
            //convert day of week to int
            if (dayOfTheWeekk == "Monday") {
              dayOfTheWeekk = "1";
            } else if (dayOfTheWeekk == "Tuesday") {
              dayOfTheWeekk = "2";
            } else if (dayOfTheWeekk == "Wednesday") {
              dayOfTheWeekk = "3";
            } else if (dayOfTheWeekk == "Thursday") {
              dayOfTheWeekk = "4";
            } else if (dayOfTheWeekk == "Friday") {
              dayOfTheWeekk = "5";
            } else if (dayOfTheWeekk == "Saturday") {
              dayOfTheWeekk = "6";
            } else if (dayOfTheWeekk == "Sunday") {
              dayOfTheWeekk = "7";
            }
            Day d = new Day(int.parse(dayOfTheWeekk));
            print("step 2");
            flutterLocalNotificationPlugin.showWeeklyAtDayAndTime(
              uniqueNumberr,
              "Dream Check!",
              stepTitle,
              d,
              t,
              _ongoing,
            );
            print("step 1");
            flutterLocalNotificationPlugin.schedule(
              uniqueNumberr,
              "Dream Check!",
              stepTitle,
              DateTime.parse(cardReminderDate + " " + notificationFormatTime),
              _ongoing,
            );
          } else if (cardWantsRemind == true &&
              repeatType == "Just on that day and time") {
            notificationFormatTime = cardReminderTime;
            if (notificationFormatTime.substring(6, 8) == 'PM') {
              int x = int.parse(notificationFormatTime.substring(0, 2));
              int y = x + 12;
              String z = notificationFormatTime.substring(2, 5);
              notificationFormatTime = y.toString() + z;
            } else {
              notificationFormatTime = notificationFormatTime.substring(0, 5);
            }
            flutterLocalNotificationPlugin.schedule(
              uniqueNumberr,
              "Dream Check!",
              stepTitle,
              DateTime.parse(cardReminderDate + " " + notificationFormatTime),
              _ongoing,
            );
          }
        }

        dreamCards.add(
          new DreamCard(
            icon: iconMap[iconTitle],
            dreamTitle: dreamTitle,
            stepList: sCards,
            position: position,
            fsTitle: "dream" + counter.toString(),
          ),
        );
        counter++;
      }

      setState(() {
        uniqueNumber = highestUniqueNumber;
        if (uniqueNumber == null) {
          uniqueNumber = 0;
        } else {
          uniqueNumber++;
        }
        if (mainAccentColorString != null) {
          mainAccentColor = Color(int.parse(mainAccentColorString));
        }
        uniqueFinishedNumber = highestCdUniqueNumber;
        if (uniqueFinishedNumber == null) {
          uniqueFinishedNumber = 0;
        } else {
          uniqueFinishedNumber++;
        }
        calledAlready = true;
        isFinished = true;
        dreamCards = dreamCards;
        return;
      });
    }
  }

  GridView returnGridView(mainContext) {
    return GridView.builder(
        itemCount: dreamCards.length,
        controller: _scrollController,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (mainContext, index) {
          return dreamCards[index];
        });
  }

  @override
  Widget build(BuildContext mainContext) {
    if (dreamCards.length == 0) {
      dreamCards.add(
        new GestureDetector(
          onTap: () {
            //TODO: IF user tries to add more then 2 dreams and they are not pro a pop up will come up telling them to go pro, when user clicks yes they should be prompted to pay the $1.99
            if (dreamCards.length == 3) {
              if (isUserPro != true) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return new userNotProDialog();
                    });
              }
            }
            addDreamGotPressed = true;
            positionOfDreamPressed = 0;
            //if user who isnt pro tries to create a new dream after making 2
            //user isnt pro pop up will appear
            if (isUserPro == true ||
                (isUserPro == false && dreamCards.length != 3)) {
              Navigator.push(
                mainContext,
                MaterialPageRoute(
                  builder: (mainContext) => TitleMakerPage(),
                ),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(
                  Radius.circular(8.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 20.0,
                  ),
                ]),
            height: 180.0,
            width: 180.0,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 15.0, left: 3.0, right: 3.0),
                    child: Text(
                      "Add Dream",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Icon(
                    Icons.add,
                    size: 70.0,
                    //TODO: this plus button icon (home page) color is not changing even though its color is mainAccentColor which changes when the user chooses a new color
                    color: mainAccentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return RestartWidget(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Visions',
            style: TextStyle(
              color: titleColor,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFFFFFFF),
        ),
        body: (isFinished == true)
            ? returnGridView(mainContext)
            : Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomHomeBar(),
      ),
    );
  }
}
