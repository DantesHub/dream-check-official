import 'package:flutter/material.dart';

String justOnce = "Just on that day and time";
String everyDay = "Every Day";
String everyWeek = "Every Week";
//This will be stored in the card
String userSelection = "Repeat";

class RepeatPage extends StatelessWidget {
  static const String id = 'repeat_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: new Icon(
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          "Repeat",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0xFF15C96C),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Choice(text: justOnce),
            new Choice(text: everyDay),
            new Choice(text: everyWeek),
            Expanded(
              child: Choice(text: ""),
            ),
          ],
        ),
      ),
    );
  }
}

class Choice extends StatelessWidget {
  Choice({@required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.1),
          bottom: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: FlatButton(
        padding: EdgeInsets.all(30),
        color: Colors.white,
        onPressed: () {
          userSelection = this.text;
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              maxLines: 2,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
