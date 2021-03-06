import 'package:flutter/material.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'VerticalDivider.dart';
import 'Constants.dart';
import 'dream_card.dart';
import 'package:vision_check_test/step_builder.dart';
import 'Constants.dart';
import 'package:vision_check_test/step_finished_confirmation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vision_check_test/target_page.dart';
import 'package:vision_check_test/settings_page.dart';
import 'package:vision_check_test/home_page.dart';

class TargetCard extends StatefulWidget {
  TargetCard({
    @required this.dreamTitle,
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
  String dreamTitle;
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
          padding: const EdgeInsets.all(0.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 5.0, 4.0, 10.0),
                    child: Text(
                      "Finish By: " + widget.cardDateVariable,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        height: 80.0,
                        width: (MediaQuery.of(context).size.width > 400)
                            ? c_width
                            : 250.0,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Dream: ${widget.dreamTitle}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: MaterialButton(
                      elevation: 8.0,
                      height: 30.0,
                      minWidth: 10.0,
                      color: Colors.grey[100],
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          onSettingsPage = false;
                          onHomePage = false;
                          onTargetPage = false;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Steps(
                                      title: widget.dreamTitle,
                                      icon: widget.icon,
                                      stepsList: widget.stepsList)));
                        });
                      },
                      splashColor: Colors.greenAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0, top: 6.0),
                        child: (widget.stepNumber > 9)
                            ? Icon(
                                Icons.more_horiz,
                                size: 15.0,
                                color: mainAccentColor,
                              )
                            : Icon(
                                Icons.more_horiz,
                                size: 20.0,
                                color: mainAccentColor,
                              ),
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
