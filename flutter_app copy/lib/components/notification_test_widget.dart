import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_notification_widget.dart';
import 'local_notification_helper.dart';

class NotificationPage extends StatefulWidget {
  static const String id = 'titlemaker_page';
  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  FirebaseUser loggedInUser;
  String titleOfDream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Chivo').copyWith(
        secondaryHeaderColor: Color(0xFF15C96C),
        primaryColor: Color(0xFFFFFFFF),
        scaffoldBackgroundColor: Color(0xFFD9DFE3),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "What is your Dream?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color(0xFF15C96C),
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
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: LocalNotificationWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
