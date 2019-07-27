import 'package:flutter/material.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'VerticalDivider.dart';
import 'Constants.dart';
import 'dream_card.dart';
import 'package:vision_check_test/step_builder.dart';
import 'Constants.dart';
import 'package:vision_check_test/Confirmation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notification_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vision_check_test/RepeatPage.dart';

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
    print("teq");
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
    return GestureDetector(
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
                        ? TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                        : TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),

                RotatedBox(
                  quarterTurns: 1,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),

                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 4.0, 10.0),
                      child: Text(
                        "Finish By: " + widget.cardDateVariable,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: c_width,
                        child: Text(
                          widget.stepName,
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      elevation: 8.0,
                      height: 30.0,
                      minWidth: 10.0,
                      color: mainAccentColor,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          Future.delayed(
                              Duration.zero, () => showAlert(context));
                          stepNumberPressed = widget.stepIndex;
                          print("green $stepNumberPressed");
                        });
                      },
                      splashColor: Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                        child: (widget.stepNumber > 9)
                            ? Icon(Icons.check, size: 20.0)
                            : Icon(
                                Icons.check,
                                size: 26.0,
                              ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: <Widget>[],
                ),
//              Container(
//                  width: c_width,
//                  child: ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
