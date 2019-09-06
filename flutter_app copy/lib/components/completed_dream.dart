import 'package:flutter/material.dart';
import 'Constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vision_check_test/completed_dreams.dart';
import 'finished_dream_delete_confirmation.dart';
import 'package:vision_check_test/home_page.dart';

int completedDreamPositionPressed;

class CompletedDream extends StatelessWidget {
  CompletedDream(
      {this.dreamText,
      this.iconData,
      this.dateCompleted,
      this.finishedUniqueNumber});

  final String dreamText;
  final String iconData;
  final String dateCompleted;
  final int finishedUniqueNumber;
  void showAlert(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          child: FinishedDreamConfirmation(),
          type: PageTransitionType.downToUp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        completedDreamPositionPressed = completedDreamsList.indexOf(this);
        Future.delayed(Duration.zero, () => showAlert(context));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.1),
            bottom: BorderSide(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Completed on ${this.dateCompleted}",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    MdiIcons.trophyVariant,
                    color: Colors.yellow[400],
                    size: 35.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    this.dreamText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    iconMap[iconData],
                    size: 30,
                    color: mainAccentColor,
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
