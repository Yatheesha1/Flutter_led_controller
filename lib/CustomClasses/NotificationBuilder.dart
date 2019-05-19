import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ledcontroller/Extras/secondscreen.dart';
import 'package:path_provider/path_provider.dart';

class NotificationBuilder {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var context;
  NotificationBuilder(context) {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    this.context = context;
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        selectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
      );
    }
  }

  Future showPlainNotification(title, body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  Future cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future scheduleNotification(title, body, duration, Map map) async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: duration));

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: map["icon"],
        sound: map["sound"],
        largeIcon: map["largeIcon"],
        largeIconBitmapSource: BitmapSource.Drawable,
        vibrationPattern: map["vibrationPattern"],
        color: const Color.fromARGB(255, 255, 0, 0));
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0, title, body, scheduledNotificationDateTime, platformChannelSpecifics,
        payload: title);
  }

  Future showNotificationWithNoSound(title, body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'silent channel id',
        'silent channel name',
        'silent channel description',
        playSound: false,
        styleInformation: new DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, '<b>silent</b> $title',
        '<b>silent</b> $body', platformChannelSpecifics,
        payload: title);
  }

  Future showBigPictureNotification(title, body, Map map) async {
    var directory = await getApplicationDocumentsDirectory();
    var largeIconResponse = map["largeIconResponse"];
    var largeIconPath = '${directory.path}/${map["largeIconPath"]}';
    var file = new File(largeIconPath);
    await file.writeAsBytes(largeIconResponse.bodyBytes);
    var bigPictureResponse = map["bigPictureResponse"];
    var bigPicturePath = '${directory.path}/${map["bigPicturePath"]}';
    file = new File(bigPicturePath);
    await file.writeAsBytes(bigPictureResponse.bodyBytes);
    var bigPictureStyleInformation = new BigPictureStyleInformation(
        bigPicturePath, BitmapSource.FilePath,
        largeIcon: largeIconPath,
        largeIconBitmapSource: BitmapSource.FilePath,
        contentTitle: map["content"],
        htmlFormatContentTitle: true,
        summaryText: map["summary"],
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigPicture,
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  Future showBigTextNotification(title, body, Map map) async {
    var bigTextStyleInformation = new BigTextStyleInformation(map["text"],
        htmlFormatBigText: true,
        contentTitle: map["contentTitle"],
        htmlFormatContentTitle: true,
        summaryText: map["summaryText"],
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  Future showInboxNotification(title, body, Map map) async {
    var lines = new List<String>();
    for (String st in map["lines"]) {
      lines.add('$st <b>1</b>');
    }
    var inboxStyleInformation = new InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: map["contentTitle"],
        htmlFormatContentTitle: true,
        summaryText: map["summaryText"],
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name', 'inbox channel description',
        style: AndroidNotificationStyle.Inbox,
        styleInformation: inboxStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  Future showGroupedNotifications(title, body, Map map) async {
    var groupKey = 'com.android.example.WORK_EMAIL';
    var groupChannelId = 'grouped channel id';
    var groupChannelName = 'grouped channel name';
    var groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html

    // create the summary notification required for older devices that pre-date Android 7.0 (API level 24)
    var lines = new List<String>();
    var i = 0;
    for (i = 0; i < map["lines"].length; i++) {
      map["lines"][i]["notificationAndroidSpecifics"] =
          new AndroidNotificationDetails(
              groupChannelId, groupChannelName, groupChannelDescription,
              importance: Importance.Max,
              priority: Priority.High,
              groupKey: groupKey);
      map["lines"][i]["notificationSpecifics"] = new NotificationDetails(
          // notificationSpecifics["notificationAndroidSpecifics" + i.toString()],
          map["lines"][i]["notificationAndroidSpecifics"],
          null);
      await flutterLocalNotificationsPlugin.show(
          i + 1,
          map["lines"][i]["contentTitle"],
          map["lines"][i]["contentSummary"],
          map["lines"][i]["notificationSpecifics"],
          payload: map["lines"][i]["contentTitle"]);
      lines.add(map["lines"][i]["contentTitle"]);
    }
    var inboxStyleInformation = new InboxStyleInformation(lines,
        contentTitle: '${i + 1} ${map["titlemessage"]}',
        summaryText: map["summaryText"]);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        style: AndroidNotificationStyle.Inbox,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin
        .show(i + 2, title, body, platformChannelSpecifics, payload: title);
  }

  Future cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future showOngoingNotification(title, body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  Future repeatNotification(title, body, interval) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, interval, platformChannelSpecifics,
        payload: title);
  }

  Future showDailyAtTime(title, body, Time time) async {
    // var time = new Time(10, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        title,
        '$body ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics,
        payload: title);
  }

  Future showWeeklyAtDayAndTime(title, body, Time time, Day day) async {
    // var time = new Time(10, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        title,
        '$body ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        day,
        time,
        platformChannelSpecifics,
        payload: title);
  }

  Future showNotificationWithNoBadge(title, body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'no badge channel', 'no badge name', 'no badge description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
}
