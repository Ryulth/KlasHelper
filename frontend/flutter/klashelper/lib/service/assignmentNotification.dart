import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:klashelper/models/assignment.dart';
import 'package:date_format/date_format.dart';

final AssignmentNotification assignmentNotification =new AssignmentNotification._private();

class AssignmentNotification {
  AssignmentNotification._private();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;
  var platform;

  init(BuildContext context) {
    this.context = context;
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: onSelectNotification);
    var androidDetail = new AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var iOSDetail = new IOSNotificationDetails();
    platform = new NotificationDetails(androidDetail, iOSDetail);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    };
    showDialog(context: context, builder: (_) =>
    new AlertDialog(
      title: new Text('notification'),
      content: new Text("$payload"),
    ));
    //Navigator.pushNamedAndRemoveUntil(
    //            context, '/assignmentPage', (_) => false);
  }

  showNotification() async {
    var scheduledNotificationDateTime = new DateTime.now().add(
        new Duration(seconds: 5));

    await flutterLocalNotificationsPlugin.show(
        0, "new video is out", "flutter noti local body", platform,
        payload: "test payload ");
    await flutterLocalNotificationsPlugin.schedule(
        0, "5초 뒤 알람 is out", "flutter noti local body",
        scheduledNotificationDateTime, platform, payload: "test payload ");
    scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(
        1, "10초 뒤 알람 is out", "flutter noti local body",
        scheduledNotificationDateTime, platform, payload: "test payload ");
  }
  enrollAssignments(List<Assignment> assignments) async {
    var now = DateTime.now();
    for (final assignment in assignments) {
      String workFinishTime = assignment.workFinishTime;
      var finishDateTime = DateTime.parse(workFinishTime);
      if (now.isBefore(finishDateTime) && assignment.isAlarm == 1) {
      await enrollAssignment(assignment);
      }
    }
  }
  enrollAssignment(Assignment assignment) async {
    String workAlarmTime = assignment.workAlarmTime;
    if (workAlarmTime != "0") {
        var scheduledNotificationDateTime = DateTime.parse(workAlarmTime);
        await flutterLocalNotificationsPlugin.schedule(
            assignment.workCode.hashCode, "과제 1 일전!", assignment.workTitle,
            scheduledNotificationDateTime, platform);
    }
  }
  removeAssignment(Assignment assignment) async{
    await flutterLocalNotificationsPlugin.cancel(assignment.workCode.hashCode);
  }
}
