import 'package:flutter/material.dart';
import 'components/Constants.dart';
import 'components/BottomHomeBar.dart';
import 'components/completed_dream.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

bool onFinishedDreams = false;
List<CompletedDream> completedDreamsList = new List<CompletedDream>();

class FinishedDreams extends StatefulWidget {
  @override
  _FinishedDreamsState createState() => _FinishedDreamsState();
}

class _FinishedDreamsState extends State<FinishedDreams> {
  ScrollController _scrollController =
      new ScrollController(initialScrollOffset: 20.0);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(
                MdiIcons.trophyOutline,
                color: Colors.black,
                size: 30,
              ),
            ),
            Center(
              child: Text(
                "Trophy Case",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: (completedDreamsList.length != 0)
            ? ListView.builder(
                itemCount: completedDreamsList.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return completedDreamsList[index];
                },
              )
            : Text(
                "You must complete a dream \nin order to add a trophy!",
                style: TextStyle(color: Colors.grey[700], fontSize: 20.0),
              ),
      ),
      bottomNavigationBar: BottomHomeBar(),
    );
  }
}
