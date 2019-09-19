import 'package:flutter/material.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'Constants.dart';
import 'package:vision_check_test/step_finished_confirmation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vision_check_test/RepeatPage.dart';
import 'package:vision_check_test/home_page.dart';

int stepNumberPressed;
bool pressedX = false;
int removeNum;
bool pleaseChange = false;
var epochDate;
int stepIndexCounter = 0;

class StepCard extends StatefulWidget {
  StepCard({
    @required this.key,
    @required this.stepNumber,
    @required this.stepName,
    @required this.cardReminderDate,
    @required this.cardReminderTime,
    @required this.cardWantsRemind,
    @required this.cardDateVariable,
    @required this.uniqueNumber,
    @required this.stepIndex,
    @required this.repeatType,
  });

  //6 variables
  Key key;
  int stepNumber;
  String stepName;
  int uniqueNumber;
  String cardReminderTime;
  String cardDateVariable;
  bool cardWantsRemind;
  DateTime dateTime;
  String cardReminderDate;
  int myNotificationNumber;
  int stepIndex;
  String repeatType;

  @override
  _StepCardState createState() => _StepCardState();
}

int getStepNumber() {
  return stepNumberPressed;
}

class _StepCardState extends State<StepCard> {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  void showAlert(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          child: ConfirmationPage(), type: PageTransitionType.downToUp),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Constant for wrapping text
    double c_width = MediaQuery.of(context).size.width * 0.70;
//    double c_width = (MediaQuery.of(context).size.width < 710.0)
//        ? ((MediaQuery.of(context).size.width < 600.0))
//            ? MediaQuery.of(context).size.width * 0.70
//            : MediaQuery.of(context).size.width * 0.75
//        : MediaQuery.of(context).size.width * 0.82;
//    double c_width = MediaQuery.of(context).size.width * 0.70;
    return SafeArea(
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              userSelection = widget.repeatType;
              stepNumberPressed = widget.stepIndex;
              print(stepNumberPressed);
              editStepWasPressed = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new StepMaker(
                    widget.cardReminderTime,
                    widget.stepName,
                    widget.cardDateVariable,
                    widget.cardWantsRemind,
                    widget.cardReminderDate,
                    widget.repeatType,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(5.0),
              height: 124.0,
              child: Card(
                elevation: 3.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(widget.stepNumber.toString(),
                          style: (widget.stepNumber > 9)
                              ? TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)
                              : TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 10.0, 4.0, 10.0),
                            child: Text(
                              "Finish By: " + widget.cardDateVariable,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: (MediaQuery.of(context).size.width > 400)
                                  ? c_width
                                  : 250.0,
                              child: Text(
                                widget.stepName,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SafeArea(
                            child: MaterialButton(
                              elevation: 8.0,
                              height: 30.0,
                              minWidth: 10.0,
                              color: Colors.grey[100],
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  Future.delayed(
                                      Duration.zero, () => showAlert(context));
                                  stepNumberPressed = widget.stepIndex;
                                });
                              },
                              splashColor: Colors.greenAccent,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 6.0, top: 6.0),
                                child: (widget.stepNumber > 9)
                                    ? Icon(
                                        Icons.check,
                                        size: 20.0,
                                        color: mainAccentColor,
                                      )
                                    : Icon(
                                        Icons.check,
                                        size: 26.0,
                                        color: mainAccentColor,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
