import 'package:flutter/material.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'VerticalDivider.dart';
import 'Constants.dart';
import 'dream_card.dart';
import 'package:vision_check_test/step_builder.dart';
import 'Constants.dart';
import 'package:vision_check_test/Confirmation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vision_check_test/target_page.dart';
import 'package:vision_check_test/settings_page.dart';
import 'package:vision_check_test/home_page.dart';

class TargetCard extends StatefulWidget {
  TargetCard({
    @required this.stepNumber,
    @required this.stepName,
    @required this.cardReminderDate,
    @required this.cardReminderTime,
    @required this.cardWantsRemind,
    @required this.cardDateVariable,
    @required this.icon,
    @required this.stepsList,
  });

  //6 variables
  int stepNumber;
  String stepName;
  String cardReminderTime;
  String cardDateVariable;
  bool cardWantsRemind = false;
  String cardReminderDate;
  IconData icon;
  List<Widget> stepsList;

  @override
  _TargetCardState createState() => _TargetCardState();
}

class _TargetCardState extends State<TargetCard> {
  @override
  Widget build(BuildContext context) {
    //Constant for wrapping text
    double c_width = MediaQuery.of(context).size.width * 0.70;
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 140.0,
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(widget.stepNumber.toString(),
                    style: (widget.stepNumber > 9)
                        ? TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                        : TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
              ),

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
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
                        onSettingsPage = false;
                        onHomePage = false;
                        targetPageCalled = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Steps(
                                    icon: widget.icon,
                                    stepsList: widget.stepsList)));
                      });
                    },
                    splashColor: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                      child: (widget.stepNumber > 9)
                          ? Icon(Icons.more_horiz, size: 20.0)
                          : Icon(
                              Icons.more_horiz,
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
    );
  }
}
