import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notification_helper.dart';
import 'package:vision_check_test/home_page.dart';

class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() =>
      _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  Time timePickedtime;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  var timeText;
  bool showReminder;
  String remindTime;
  var scheduledNotificationDateTime =
      new DateTime.now().add(new Duration(seconds: 10));

  @override
  void initState() {
    super.initState();

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

  _showScheduledNotification() async {
    var android = new AndroidNotificationDetails(
        'Channel ID', 'Channel NAME', 'channel DESCRIPTINO');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationPlugin.schedule(0, "scheduled title",
        "scheduled body", scheduledNotificationDateTime, platform,
        payload: "gang");
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            title('Basics'),
            RaisedButton(
              child: Text('Show dante notification'),
              onPressed: () => showCustomScheduledNotification(
                  flutterLocalNotificationPlugin,
                  title: "custom sched title",
                  body: "custom body",
                  dateTime: scheduledNotificationDateTime),
            ),
            RaisedButton(
              child: Text('Replace notification'),
              onPressed: () => showOngoingNotification(
                  flutterLocalNotificationPlugin,
                  title: 'ReplacedTitle',
                  body: 'ReplacedBody'),
            ),
            RaisedButton(
              child: Text('Other notification'),
              onPressed: () => showOngoingNotification(
                  flutterLocalNotificationPlugin,
                  title: 'OtherTitle',
                  body: 'OtherBody',
                  id: 20),
            ),
            const SizedBox(height: 32),
            title('Feautures'),
            RaisedButton(
              child: Text('Silent notification'),
              onPressed: () => showSilentNotification(
                  flutterLocalNotificationPlugin,
                  title: 'SilentTitle',
                  body: 'SilentBody',
                  id: 30),
            ),
            const SizedBox(height: 32),
            title('Cancel'),
            RaisedButton(
              child: Text('Cancel all notification'),
              onPressed: flutterLocalNotificationPlugin.cancelAll,
            ),
          ],
        ),
      );

  Widget title(String text) => Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      );
}
