import 'package:flutter/material.dart';
import 'components/BottomHomeBar.dart';
import 'components/category_icons.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'RepeatPage.dart';
import 'step_builder.dart';
import 'components/step_card.dart';
import 'components/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int oldStepIndex;
bool editStepWasPressed = false;
bool createdAlready = false;
int specialCounter = 1;
int specialOnPressed = 1;
String notificationFormatTime = "Time";
String notificationFormatDay = "Day";
int notificationCounter = 0;
bool didTheyToggleToTrue = false;
bool didTheyToggleToFalse = true;
int uniqueNumber = 0;
bool needsDate = false;
bool needsTime = false;
bool invalidStuff = false;
Map<int, int> notificationMap = new Map<int, int>();
String dayOfTheWeek = "-1";

class StepMaker extends StatefulWidget {
  static const id = "StepMaker";

  String reminderTime;
  String stepName;
  String dateVariable;
  bool wantsRemind;
  String reminderDate;
  String repeatType;
  StepMaker(this.reminderTime, this.stepName, this.dateVariable,
      this.wantsRemind, this.reminderDate, this.repeatType);
  @override
  _StepMakerState createState() => _StepMakerState();
}

class _StepMakerState extends State<StepMaker> {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  var myController;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

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

  //These variables are for the calendar, so when the user re clicks the calendar there
  //last submission was saved
  DateTime selected;
  DateTime dateVar = new DateTime.now();
  DateTime remDate = new DateTime.now();
  DateTime timeVar = new DateTime.now();

  //Calendar pop up and format to mm, dd year
  _showDateTimePicker() async {
    var selected = await showDatePicker(
        context: context,
        initialDate: dateVar,
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2050));

    setState(() {
      if (selected != null) {
        widget.dateVariable = new DateFormat.yMMMMd("en_US")
            .format(DateTime.parse(selected.toString()));
        dateVar = selected;
      }
    });
  }

  _showDateTimePickerForRemind() async {
    var selected = await showDatePicker(
        context: context,
        initialDate: remDate,
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2050));

    setState(() {
      needsDate = false;
      if (selected != null) {
        notificationFormatDay = new DateFormat("yyyy-MM-dd").format(selected);
        widget.reminderDate = new DateFormat("MM-dd-yyyy").format(selected);
        remDate = selected;
        DateTime dt = DateTime.parse(notificationFormatDay);
        dayOfTheWeek = new DateFormat("EEEE").format(dt);
        print("yureka $dayOfTheWeek");
        //convert day of week to int
        if (dayOfTheWeek == "Monday") {
          dayOfTheWeek = "1";
        } else if (dayOfTheWeek == "Tuesday") {
          dayOfTheWeek = "2";
        } else if (dayOfTheWeek == "Wednesday") {
          dayOfTheWeek = "3";
        } else if (dayOfTheWeek == "Thursday") {
          dayOfTheWeek = "4";
        } else if (dayOfTheWeek == "Friday") {
          dayOfTheWeek = "5";
        } else if (dayOfTheWeek == "Saturday") {
          dayOfTheWeek = "6";
        } else if (dayOfTheWeek == "Sunday") {
          dayOfTheWeek = "7";
        }
      }
    });
  }

  //Show time alert popup
  _showTime() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Input time",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle: TextStyle(fontSize: 20, color: Colors.black),
                  highlightedTextStyle:
                      TextStyle(fontSize: 20, color: Colors.black),
                  spacing: 40,
                  itemHeight: 80,
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      needsTime = false;
                      notificationFormatTime =
                          new DateFormat("hh:mm a").format(time);
                      if (notificationFormatTime.substring(6, 8) == 'PM') {
                        int x =
                            int.parse(notificationFormatTime.substring(0, 2));
                        int y = x + 12;
                        String z = notificationFormatTime.substring(2, 5);
                        notificationFormatTime = y.toString() + z;
                      } else {
                        notificationFormatTime =
                            notificationFormatTime.substring(0, 5);
                      }
                      widget.reminderTime =
                          new DateFormat("hh:mm a").format(time);
                      timeVar = time;
                    });
                  },
                ),
                MaterialButton(
                  elevation: 8.0,
                  height: 40.0,
                  minWidth: 50.0,
                  color: mainAccentColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashColor: Colors.greenAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    myController = TextEditingController(text: widget.stepName);
    initializeDateFormatting();
    getCurrentUser();
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (
      id,
      title,
      body,
      payload,
    ) =>
            onSelectNotification(payload));

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    flutterLocalNotificationPlugin.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
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

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width;
    DateTime date3;
    var dateStringParsing = new Column(
      children: <Widget>[
        new SizedBox(
          height: 30.0,
        ),
        selected != null
            ? new Text(
                widget.dateVariable = new DateFormat('yyyy-MM-dd h:m:s')
                    .format(DateTime.parse("2018-09-15 20:18:04Z")),
                style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                ),
              )
            : new SizedBox(
                width: 0.0,
                height: 0.0,
              ),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: SafeArea(
            child: Row(
              children: <Widget>[
                Text(
                  "Step builder",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: mainAccentColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    usersIconData,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ],
            ),
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
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 30.0, bottom: 20.0),
                        child: Text(
                          "What will you be doing for this step?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontFamily: 'Chivo',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        //TextField Row
                        child: Container(
                          margin: EdgeInsets.only(bottom: 40.0),
                          height: 40.0,
                          child: TextField(
                            style: TextStyle(fontSize: 20.0),
                            controller: myController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                                hintText: "Enter your step here"),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //Add date row
              Divider(),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5.0, bottom: 20.0),
                        child: Text(
                          "What is your target date for this step?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontFamily: 'Chivo',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 40.0),
                          child: Text(
                            widget.dateVariable,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 30.0),
                        child: MaterialButton(
                          elevation: 8.0,
                          height: 40.0,
                          minWidth: 50.0,
                          color: mainButtonColor,
                          textColor: mainButtonTextColor,
                          onPressed: () => _showDateTimePicker(),
                          splashColor: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              "Target Date",
                              style: TextStyle(
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 30.0, bottom: 20.0),
                          child: Text(
                            "Do you want to be reminded of this?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //fontFamily: 'Chivo',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //This is the 3rd row
                    Container(
                      margin: EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (widget.dateVariable != "Target Date")
                                  ? Switch(
                                      value: widget.wantsRemind,
                                      onChanged: (value) {
                                        if (widget.wantsRemind == false) {
                                          didTheyToggleToTrue = true;
                                        } else if (widget.wantsRemind == true) {
                                          didTheyToggleToFalse = true;
                                          widget.reminderTime = "Time";
                                          userSelection = "Repeat";
                                          widget.reminderDate = "Day";
                                          notificationFormatDay = "Day";
                                          notificationFormatTime = "Time";
                                          dayOfTheWeek = "-1";
                                        }
                                        setState(() {
                                          widget.wantsRemind = value;
                                        });
                                      },
                                      activeTrackColor: mainAccentColor,
                                      activeColor: mainAccentColor,
                                    )
                                  : Text(
                                      "    Please select target Date first")),

                          //If toggled on then display pick a date row card
                          widget.wantsRemind
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          MaterialButton(
                                            elevation: 8.0,
                                            height: 40.0,
                                            minWidth: 50.0,
                                            color: mainButtonColor,
                                            textColor: mainButtonTextColor,
                                            onPressed: () {
                                              _showTime();
                                            },
                                            splashColor: Colors.greenAccent,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Text(
                                                widget.reminderTime,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: MaterialButton(
                                              elevation: 8.0,
                                              height: 40.0,
                                              minWidth: 50.0,
                                              color: mainButtonColor,
                                              textColor: mainButtonTextColor,
                                              onPressed: () =>
                                                  _showDateTimePickerForRemind(),
                                              splashColor: Colors.greenAccent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Text(
                                                  widget.reminderDate,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      (needsTime == false)
                                          ? Text("")
                                          : Text(
                                              "Please enter Time",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                      MaterialButton(
                                        elevation: 8.0,
                                        height: 40.0,
                                        minWidth: 50.0,
                                        color: mainButtonColor,
                                        textColor: mainButtonTextColor,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RepeatPage(),
                                            ),
                                          );
                                        },
                                        splashColor: Colors.greenAccent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Container(
                                            child: Text(
                                              userSelection,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      (needsDate == false)
                                          ? Text("")
                                          : Text(
                                              "Please enter Date",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                    ],
                                  ),
                                )
                              : Card(),
                        ],
                      ),
                    ),
                    Divider(),

                    //Finished button and all the shit that happens when
                    //u finished creating and all info to card
                    Expanded(
                      child: Center(
                        child: Container(
                          child: MaterialButton(
                            elevation: 8.0,
                            height: 40.0,
                            minWidth: 50.0,
                            color: mainAccentColor,
                            textColor: Colors.white,
                            onPressed: () {
                              widget.stepName = myController.text.toString();
                              print(widget.reminderTime);
                              print(widget.reminderDate);
                              if (widget.reminderTime == "Time" &&
                                  widget.reminderDate != "Day" &&
                                  widget.wantsRemind == true) {
                                setState(() {
                                  needsTime = true;
                                  invalidStuff = true;
                                });
                              } else if (widget.reminderTime != "Time" &&
                                  widget.reminderDate == "Day" &&
                                  userSelection != "Every Day" &&
                                  widget.wantsRemind == true) {
                                setState(() {
                                  needsDate = true;
                                  invalidStuff = true;
                                });
                              } else if (userSelection != "Repeat" &&
                                  widget.reminderDate == "Day" &&
                                  widget.reminderTime == "Time") {
                                setState(() {
                                  if (userSelection == "Every Day") {
                                    needsTime = true;
                                    invalidStuff = true;
                                  } else {
                                    needsTime = true;
                                    needsDate = true;
                                    invalidStuff = true;
                                  }
                                });
                              } else {
                                needsTime = false;
                                needsDate = false;
                                invalidStuff = false;
                              }
                              if (invalidStuff == false) {
                                Navigator.pop(context);
                                if (positionOfDreamPressed == 0 &&
                                    editStepWasPressed == false) {
                                  if (steps.length != 0) {
                                    StepCard lastStepCardInList =
                                        steps[steps.length - 1];
                                    _firestore
                                        .collection('users')
                                        .document(loggedInUser.email)
                                        .collection("dreams")
                                        .document("dream" +
                                            dreamCards.length.toString())
                                        .collection("stepListForDream")
                                        .document(
                                            (lastStepCardInList.stepNumber + 1)
                                                .toString())
                                        .setData(
                                      {
                                        'stepNumber':
                                            (lastStepCardInList.stepNumber + 1),
                                        'stepName': widget.stepName,
                                        'cardDateVariable': widget.dateVariable,
                                        'cardReminderDate':
                                            notificationFormatDay,
                                        'cardReminderTime': widget.reminderTime,
                                        'cardWantsRemind': widget.wantsRemind,
                                        'repeatType': userSelection,
                                        'uniqueNumber': uniqueNumber,
                                        'stepIndex': stepIndexCounter,
                                      },
                                    );
                                  } else {
                                    //steps.length == 0
                                    //positionOfDreamPressed ==0 && editStepWasPressed == false
                                    _firestore
                                        .collection('users')
                                        .document(loggedInUser.email)
                                        .collection("dreams")
                                        .document("dream" +
                                            dreamCards.length.toString())
                                        .collection("stepListForDream")
                                        .document((steps.length + 1).toString())
                                        .setData(
                                      {
                                        'stepNumber': (steps.length + 1),
                                        'stepName': widget.stepName,
                                        'cardDateVariable': widget.dateVariable,
                                        'cardReminderDate':
                                            notificationFormatDay,
                                        'cardReminderTime': widget.reminderTime,
                                        'cardWantsRemind': widget.wantsRemind,
                                        'repeatType': userSelection,
                                        'uniqueNumber': uniqueNumber,
                                        'stepIndex': stepIndexCounter,
                                      },
                                    );
                                  }
                                } else if (editStepWasPressed == true &&
                                    positionOfDreamPressed != 0) {
                                  StepCard s = steps[stepNumberPressed];
                                  if (steps != null) {
                                    StepCard oldStep = steps[stepNumberPressed];
                                    oldStepIndex = oldStep.stepIndex;
                                  }
                                  _firestore
                                      .collection('users')
                                      .document(loggedInUser.email)
                                      .collection("dreams")
                                      .document(fsTitleDelete)
                                      .collection("stepListForDream")
                                      .document((s.stepNumber).toString())
                                      .setData(
                                    {
                                      'stepNumber': s.stepNumber,
                                      'stepName': widget.stepName,
                                      'cardDateVariable': widget.dateVariable,
                                      'cardReminderDate': notificationFormatDay,
                                      'cardReminderTime': widget.reminderTime,
                                      'cardWantsRemind': widget.wantsRemind,
                                      'repeatType': userSelection,
                                      'uniqueNumber': s.uniqueNumber,
                                      'stepIndex': oldStepIndex,
                                    },
                                  );
                                } else if (editStepWasPressed == true &&
                                    positionOfDreamPressed == 0) {
                                  StepCard s = steps[stepNumberPressed];
                                  if (steps != null) {
                                    StepCard oldStep = steps[stepNumberPressed];
                                    oldStepIndex = oldStep.stepIndex;
                                  }
                                  _firestore
                                      .collection('users')
                                      .document(loggedInUser.email)
                                      .collection("dreams")
                                      .document("dream" +
                                          dreamCards.length.toString())
                                      .collection("stepListForDream")
                                      .document(((s.stepNumber).toString()))
                                      .setData(
                                    {
                                      'stepNumber': s.stepNumber,
                                      'stepName': widget.stepName,
                                      'cardDateVariable': widget.dateVariable,
                                      'cardReminderDate': notificationFormatDay,
                                      'cardReminderTime': widget.reminderTime,
                                      'cardWantsRemind': widget.wantsRemind,
                                      'repeatType': userSelection,
                                      'uniqueNumber': s.uniqueNumber,
                                      'stepIndex': oldStepIndex,
                                    },
                                  );
                                } else if (editStepWasPressed == false &&
                                    positionOfDreamPressed != 0) {
                                  if (steps.length != 0) {
                                    StepCard lastStepCardInList =
                                        steps[steps.length - 1];
                                    _firestore
                                        .collection('users')
                                        .document(loggedInUser.email)
                                        .collection("dreams")
                                        .document(fsTitleDelete)
                                        .collection("stepListForDream")
                                        .document(
                                            (lastStepCardInList.stepNumber + 1)
                                                .toString())
                                        .setData(
                                      {
                                        'stepNumber':
                                            (lastStepCardInList.stepNumber + 1),
                                        'stepName': widget.stepName,
                                        'cardDateVariable': widget.dateVariable,
                                        'cardReminderDate':
                                            notificationFormatDay,
                                        'cardReminderTime': widget.reminderTime,
                                        'cardWantsRemind': widget.wantsRemind,
                                        'repeatType': userSelection,
                                        'uniqueNumber': uniqueNumber,
                                        'stepIndex': stepIndexCounter,
                                      },
                                    );
                                  } else {
                                    _firestore
                                        .collection('users')
                                        .document(loggedInUser.email)
                                        .collection("dreams")
                                        .document(fsTitleDelete)
                                        .collection("stepListForDream")
                                        .document((steps.length + 1).toString())
                                        .setData(
                                      {
                                        'stepNumber': (steps.length + 1),
                                        'stepName': widget.stepName,
                                        'cardDateVariable': widget.dateVariable,
                                        'cardReminderDate':
                                            notificationFormatDay,
                                        'cardReminderTime': widget.reminderTime,
                                        'cardWantsRemind': widget.wantsRemind,
                                        'repeatType': userSelection,
                                        'uniqueNumber': uniqueNumber,
                                        'stepIndex': stepIndexCounter,
                                      },
                                    );
                                  }
                                }

                                //add new step card to actual app
                                if (editStepWasPressed == false) {
                                  print("Called how many times?");
                                  if (steps.length != 0) {
                                    StepCard lastStepCardInList =
                                        steps[steps.length - 1];
                                    if (userSelection != "Every Week") {
                                      steps.add(
                                        new StepCard(
                                          stepNumber:
                                              (lastStepCardInList.stepNumber +
                                                  1),
                                          stepName: widget.stepName,
                                          cardReminderDate:
                                              notificationFormatDay,
                                          cardReminderTime: widget.reminderTime,
                                          cardDateVariable: widget.dateVariable,
                                          cardWantsRemind: widget.wantsRemind,
                                          uniqueNumber: uniqueNumber,
                                          stepIndex: stepIndexCounter,
                                          repeatType: userSelection,
                                        ),
                                      );
                                    } else {
                                      //editStepwasPressed = false, userSelection == Every week,
                                      // steps.length != 0
                                      steps.add(
                                        new StepCard(
                                          stepNumber:
                                              (lastStepCardInList.stepNumber +
                                                  1),
                                          stepName: widget.stepName,
                                          cardReminderDate:
                                              notificationFormatDay,
                                          cardReminderTime: widget.reminderTime,
                                          cardDateVariable: widget.dateVariable,
                                          cardWantsRemind: widget.wantsRemind,
                                          uniqueNumber: uniqueNumber,
                                          stepIndex: stepIndexCounter,
                                          repeatType: userSelection,
                                        ),
                                      );
                                    }
                                  } else {
                                    //steps.length == 0 and editStepWasPressed == false
                                    steps.add(
                                      new StepCard(
                                        stepNumber: (steps.length + 1),
                                        stepName: widget.stepName,
                                        cardReminderDate: notificationFormatDay,
                                        cardReminderTime: widget.reminderTime,
                                        cardDateVariable: widget.dateVariable,
                                        cardWantsRemind: widget.wantsRemind,
                                        uniqueNumber: uniqueNumber,
                                        stepIndex: stepIndexCounter,
                                        repeatType: userSelection,
                                      ),
                                    );
                                  }
                                  stepIndexCounter++;
                                }
                                if (editStepWasPressed == true) {
                                  if (steps != null) {
                                    StepCard oldStep = steps[stepNumberPressed];
                                    oldStepIndex = oldStep.stepIndex;
                                    if (userSelection != "Every Week") {
                                      steps.insert(
                                        stepNumberPressed,
                                        new StepCard(
                                          stepNumber: oldStep.stepNumber,
                                          stepName: widget.stepName,
                                          cardReminderDate:
                                              notificationFormatDay,
                                          cardReminderTime: widget.reminderTime,
                                          cardDateVariable: widget.dateVariable,
                                          cardWantsRemind: widget.wantsRemind,
                                          uniqueNumber: oldStep.uniqueNumber,
                                          stepIndex: oldStepIndex,
                                          repeatType: userSelection,
                                        ),
                                      );
                                    } else {
                                      //editStep Was PRESSED and userSelection == everyweek
                                      steps.insert(
                                        stepNumberPressed,
                                        new StepCard(
                                            stepNumber: oldStep.stepNumber,
                                            stepName: widget.stepName,
                                            cardReminderDate:
                                                notificationFormatDay,
                                            cardReminderTime:
                                                widget.reminderTime,
                                            cardDateVariable:
                                                widget.dateVariable,
                                            cardWantsRemind: widget.wantsRemind,
                                            uniqueNumber: oldStep.uniqueNumber,
                                            stepIndex: oldStepIndex,
                                            repeatType: "Every Week"),
                                      );
                                    }
                                    steps.removeAt(stepNumberPressed + 1);
                                  }
                                }

                                //When user presses finish return and create new step card
                                //add all the information and add it to steps list
                                stepIndexCounter = steps.length;

                                if (didTheyToggleToFalse == true &&
                                    editStepWasPressed == true) {
                                  print("CANCELED");
                                  StepCard s = steps[stepNumberPressed];
                                  int cancelNumber = s.uniqueNumber;
                                  flutterLocalNotificationPlugin
                                      .cancel(cancelNumber);
                                }

                                if (widget.wantsRemind == true &&
                                    editStepWasPressed == false &&
                                    (widget.reminderTime != "Time" &&
                                        widget.reminderDate != "Day")) {
                                  StepCard s = steps[steps.length - 1];
                                  if (userSelection == justOnce ||
                                      userSelection == "Repeat") {
                                    print("SCHEDULED");
                                    flutterLocalNotificationPlugin.schedule(
                                      s.uniqueNumber,
                                      "Dream Check!",
                                      widget.stepName,
                                      DateTime.parse(notificationFormatDay +
                                          " " +
                                          notificationFormatTime),
                                      _ongoing,
                                    );
                                    //edit step was NOT pressed and widget.wantsremind = true
                                  } else if (userSelection == everyDay) {
                                    print("created notification");
                                    Time t = new Time(
                                        int.parse((notificationFormatTime
                                            .substring(0, 2))),
                                        int.parse((notificationFormatTime
                                            .substring(3, 5))),
                                        0);
                                    flutterLocalNotificationPlugin
                                        .showDailyAtTime(
                                      s.uniqueNumber,
                                      "Dream Check!",
                                      widget.stepName,
                                      t,
                                      _ongoing,
                                    );
                                    //edit step was NOT pressed and widget.wantsremind = true
                                  } else if (userSelection == everyWeek) {
                                    Day d = new Day(int.parse(dayOfTheWeek));
                                    Time t = new Time(
                                        int.parse((notificationFormatTime
                                            .substring(0, 2))),
                                        int.parse((notificationFormatTime
                                            .substring(3, 5))),
                                        0);
                                    //edit step was NOT pressed and widget.wantsremind = true and userSelection
                                    // == everyWeek
                                    if (positionOfDreamPressed != 0) {
                                      Firestore.instance
                                          .collection('users')
                                          .document(loggedInUser.email)
                                          .collection("dreams")
                                          .document(fsTitleDelete)
                                          .collection('stepListForDream')
                                          .document(s.stepNumber.toString())
                                          .updateData({
                                        'stepNumber': s.stepNumber,
                                        'stepName': s.stepName,
                                        'cardDateVariable': s.cardDateVariable,
                                        'cardReminderDate': s.cardReminderDate,
                                        'cardReminderTime': s.cardReminderTime,
                                        'cardWantsRemind': s.cardWantsRemind,
                                        'repeatType': "Every Week",
                                        'uniqueNumber': s.uniqueNumber,
                                        'stepIndex': s.stepIndex,
                                      });
                                      //edit step was NOT pressed and widget.wantsremind = true and userSelection
                                      // == everyWeek
                                    } else {
                                      Firestore.instance
                                          .collection('users')
                                          .document(loggedInUser.email)
                                          .collection("dreams")
                                          .document("dream" +
                                              dreamCards.length.toString())
                                          .collection('stepListForDream')
                                          .document(s.stepNumber.toString())
                                          .updateData({
                                        'stepNumber': s.stepNumber,
                                        'stepName': s.stepName,
                                        'cardDateVariable': s.cardDateVariable,
                                        'cardReminderDate': s.cardReminderDate,
                                        'cardReminderTime': s.cardReminderTime,
                                        'cardWantsRemind': s.cardWantsRemind,
                                        'repeatType': "Every Week",
                                        'uniqueNumber': s.uniqueNumber,
                                        'stepIndex': s.stepIndex,
                                      });
                                    }
                                    //edit step was NOT pressed and widget.wantsremind = true and userSelection
                                    // == everyWeek and dreamPosition == 0
                                    print("created notification");
                                    flutterLocalNotificationPlugin
                                        .showWeeklyAtDayAndTime(
                                      uniqueNumber,
                                      "Dream Check!",
                                      widget.stepName,
                                      d,
                                      t,
                                      _ongoing,
                                    );
                                    flutterLocalNotificationPlugin.schedule(
                                        s.uniqueNumber,
                                        "Dream Check!",
                                        widget.stepName,
                                        DateTime.parse(notificationFormatDay +
                                            " " +
                                            notificationFormatTime),
                                        _ongoing);
                                  } else if (didTheyToggleToTrue == true &&
                                      editStepWasPressed == true) {
                                    editStepWasPressed = false;
                                    StepCard s = steps[stepNumberPressed];
                                    if (userSelection == justOnce ||
                                        userSelection == "Repeat") {
                                      print("SCHEDULED");
                                      flutterLocalNotificationPlugin.schedule(
                                          s.uniqueNumber,
                                          "Dream Check!",
                                          widget.stepName,
                                          DateTime.parse(notificationFormatDay +
                                              " " +
                                              notificationFormatTime),
                                          _ongoing);
                                      //DidTheyToggleToTrue == true && edit step was pressed
                                    } else if (userSelection == everyDay) {
                                      Time t = new Time(
                                          int.parse((notificationFormatTime
                                              .substring(0, 2))),
                                          int.parse((notificationFormatTime
                                              .substring(3, 5))),
                                          0);
                                      print("SCHEDULED");
                                      flutterLocalNotificationPlugin
                                          .showDailyAtTime(
                                        s.uniqueNumber,
                                        "Dream Check!",
                                        widget.stepName,
                                        t,
                                        _ongoing,
                                      );
                                      //DidTheyToggleToTrye == true && edit step was pressed
                                    } else if (userSelection == everyWeek) {
                                      StepCard s = steps[stepNumberPressed];
                                      Time t = new Time(
                                          int.parse((notificationFormatTime
                                              .substring(0, 2))),
                                          int.parse((notificationFormatTime
                                              .substring(3, 5))),
                                          0);
                                      Day d = new Day(int.parse(dayOfTheWeek));

                                      if (positionOfDreamPressed != 0) {
                                        Firestore.instance
                                            .collection('users')
                                            .document(loggedInUser.email)
                                            .collection("dreams")
                                            .document(fsTitleDelete)
                                            .collection('stepListForDream')
                                            .document(s.stepNumber.toString())
                                            .updateData({
                                          'stepNumber': s.stepNumber,
                                          'stepName': s.stepName,
                                          'cardDateVariable':
                                              s.cardDateVariable,
                                          'cardReminderDate':
                                              s.cardReminderDate,
                                          'cardReminderTime':
                                              s.cardReminderTime,
                                          'cardWantsRemind': s.cardWantsRemind,
                                          'repeatType': "Every Day",
                                          'uniqueNumber': s.uniqueNumber,
                                          'stepIndex': s.stepIndex,
                                        });
                                        //DidTheyToggleToTrue == true && edit step was
                                        // pressed and dreamPosition == 0
                                      } else {
                                        Firestore.instance
                                            .collection('users')
                                            .document(loggedInUser.email)
                                            .collection("dreams")
                                            .document("dream" +
                                                dreamCards.length.toString())
                                            .collection('stepListForDream')
                                            .document(s.stepNumber.toString())
                                            .updateData({
                                          'stepNumber': s.stepNumber,
                                          'stepName': s.stepName,
                                          'cardDateVariable':
                                              s.cardDateVariable,
                                          'cardReminderDate':
                                              s.cardReminderDate,
                                          'cardReminderTime':
                                              s.cardReminderTime,
                                          'cardWantsRemind': s.cardWantsRemind,
                                          'repeatType': "Every Week",
                                          'uniqueNumber': s.uniqueNumber,
                                          'stepIndex': s.stepIndex,
                                        });
                                      }
                                      print("SCHEDULED twice");
                                      flutterLocalNotificationPlugin
                                          .showWeeklyAtDayAndTime(
                                        s.uniqueNumber,
                                        "Dream Check!",
                                        widget.stepName,
                                        d,
                                        t,
                                        _ongoing,
                                      );
                                      flutterLocalNotificationPlugin.schedule(
                                          s.uniqueNumber,
                                          "Dream Check!",
                                          widget.stepName,
                                          DateTime.parse(notificationFormatDay +
                                              " " +
                                              notificationFormatTime),
                                          _ongoing);
                                    }
                                  }
                                }
                                needsTime = false;
                                needsDate = false;
                                invalidStuff = false;
                                uniqueNumber++;
                                print("gang affiliated  $userSelection");
                                editStepWasPressed = false;
                              }
                            },
                            splashColor: Colors.greenAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "FINSHED",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
