import 'package:flutter/material.dart';
import 'components/BottomHomeBar.dart';
import "components/dream_card.dart";
import "components/Constants.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'DreamTitleMakerPage.dart';
import 'step_builder.dart';
import 'components/step_card.dart';
import 'restart_widget.dart';
import 'dart:async';
import 'target_page.dart';
import 'components/MyGlobals.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'components/local_notification_helper.dart';
import 'package:vision_check_test/StepMakerPage.dart';

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
bool removedDream = false;
bool initStateCalled = false;

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
      }
    } catch (e) {
      print("************\n***********" + e);
    }
  }

  @override
  void initState() {
    super.initState();
    print("called " + initStateCalled.toString());
    if (!initStateCalled) {
      calledAlready = false;
      getData();
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

  Future<void> getData() async {
    await getCurrentUser();
    if (calledAlready == false) {
      List<StepCard> sCards;

      final dreams = await _firestore
          .collection('users')
          .document(loggedInUserString)
          .collection('dreams')
          .getDocuments();
      length = dreams.documents.length.toInt();
      print("documents:::::::" + dreams.documents.toString());
      for (var d in dreams.documents) {
        final dreamTitle = d.data['title'];
        final iconTitle = d.data['icon'];
        icons.add(iconMap[iconTitle]);

        final position = d.data['position'];
        positions.add(int.parse(position));

        final fireSteps = await _firestore
            .collection('users')
            .document(loggedInUserString)
            .collection('dreams')
            .document('dream' + dreamCards.length.toString())
            .collection('stepListForDream')
            .getDocuments();

        sCards = new List<StepCard>();
        print("made it here");

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
            DateTime dt = DateTime.parse(notificationFormatDay);
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
        print("added");
        dreamCards.add(
          new DreamCard(
            icon: iconMap[iconTitle],
            dreamTitle: dreamTitle,
            stepList: sCards,
            position: int.parse(position),
            fsTitle: "dream" + counter.toString(),
          ),
        );
        counter++;
      }

      setState(() {
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
    print("we building");
    if (dreamCards.length == 0) {
      dreamCards.add(
        new GestureDetector(
          onTap: () {
            addDreamGotPressed = true;
            positionOfDreamPressed = 0;
            Navigator.push(
              mainContext,
              MaterialPageRoute(
                builder: (mainContext) => TitleMakerPage(),
              ),
            );
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
          title: Text(
            'My Visions',
            style: TextStyle(
              color: Color(0xFF39414C),
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
