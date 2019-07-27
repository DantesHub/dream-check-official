import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

NotificationDetails get _noSound {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'silent channel id',
    'silent channel name',
    'silent channel description',
    playSound: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails(presentSound: false);

  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showSilentNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _noSound);

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: true,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

//Future showScheduledNotification(
//  FlutterLocalNotificationsPlugin schedule, {
//  @required String title,
//  @required String body,
//  @required DateTime dateTime,
//  int id = 0,
//}) => showScheduledNotification(
//        title: title, body: body, id: id, dateTime: dateTime,  );

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);

Future showCustomScheduledNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required int id,
  @required stepNumber,
  @required String title,
  @required String body,
  @required DateTime dateTime,
}) =>
    _showSchedNotification(notifications,
        stepNumber: stepNumber,
        id: id,
        title: title,
        body: body,
        type: _ongoing,
        dateTime: dateTime);

Future showCustomDailyScheduledNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required int id,
  @required stepNumber,
  @required String title,
  @required String body,
  @required Time time,
}) =>
    _showDailyNotificaion(notifications,
        stepNumber: stepNumber,
        id: id,
        title: title,
        body: body,
        type: _ongoing,
        time: time);

Future showCustomWeeklyScheduleNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required int id,
  @required int stepNumber,
  @required String title,
  @required String body,
  @required Time time,
  @required Day day,
}) =>
    _showWeeklyNotification(notifications,
        stepNumber: stepNumber,
        id: id,
        title: title,
        body: body,
        day: day,
        type: _ongoing,
        time: time);

Future _showSchedNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required int stepNumber,
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required DateTime dateTime,
  @required int id,
}) =>
    notifications.schedule(id, title, body, dateTime, type);

Future _showDailyNotificaion(
  FlutterLocalNotificationsPlugin notifications, {
  @required int stepNumber,
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required Time time,
  @required int id,
}) =>
    notifications.showDailyAtTime(id, title, body, time, type);

Future _showWeeklyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required int stepNumber,
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required Time time,
  @required Day day,
  @required int id,
}) =>
    notifications.showWeeklyAtDayAndTime(id, title, body, day, time, type);
