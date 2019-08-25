import 'package:flutter/material.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'VerticalDivider.dart';
import 'package:vision_check_test/category_page.dart';
import 'Constants.dart';
import 'package:vision_check_test/step_builder.dart';
import 'package:vision_check_test/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vision_check_test/are_you_sure_page.dart';

class DreamCard extends StatefulWidget {
  DreamCard({
    @required this.icon,
    @required this.dreamTitle,
    @required this.stepList,
    @required this.position,
    @required this.fsTitle,
  });

  IconData icon;
  String dreamTitle;
  int position;
  String fsTitle;
  List<Widget> stepList;
  List<Future> scheduledNotifications = new List<Future>();
  Map<int, int> notificationMap = new Map<int, int>();

  @override
  _DreamCardState createState() => _DreamCardState();
}

class _DreamCardState extends State<DreamCard> {
  void showAlert(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
          child: AreYouSurePage(
            iconData: widget.icon,
            dreamTitle: widget.dreamTitle,
            position: widget.position,
          ),
          type: PageTransitionType.downToUp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        fsTitleDelete = widget.fsTitle;
        print(widget.fsTitle);
        dreamPosition = widget.position;
        print(widget.position);
        positionOfDreamPressed = widget.position;
        setState(() {
          positionOfDreamPressed = widget.position;
          Future.delayed(Duration.zero, () => showAlert(context));
        });
      },
      onTap: () {
        onHomePage = false;
        fsTitleDelete = widget.fsTitle;
        dreamPosition = widget.position;
        positionOfDreamPressed = widget.position;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Steps(
              icon: widget.icon,
              stepsList: widget.stepList,
              title: widget.dreamTitle,
            ),
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
                  widget.dreamTitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Icon(
                widget.icon,
                size: 50.0,
                color: mainAccentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
