import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:ledcontroller/CustomClasses/NotificationBuilder.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new MyNotificationPage(),
    );
  }
}

NotificationBuilder notificationBuilder;

class MyNotificationPage extends StatefulWidget {
  @override
  _MyAppState createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyNotificationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    notificationBuilder = new NotificationBuilder(context);
  }

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
            icon: new Icon(_backIcon()),
            alignment: Alignment.centerLeft,
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Navigation drawer'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new Text(
                        'Tap on a notification when it appears to trigger navigation'),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Show plain notification with payload'),
                      onPressed: () async {
                        var title = "Plain Notification";
                        var body = "My Testing";
                        await notificationBuilder.showPlainNotification(
                            title, body);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Cancel notification'),
                      onPressed: () async {
                        await notificationBuilder.cancelNotification();
                      },
                    ),
                  ),
                  new Padding(
                      padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                      child: new RaisedButton(
                          child: new Text(
                              'Schedule notification to appear in 5 seconds, custom sound, red colour, large icon'),
                          onPressed: () async {
                            var title = "Schedule Notification";
                            var body = "My Testing";
                            Map map = new Map();
                            Int64List vibrationPattern = new Int64List(4);
                            vibrationPattern[0] = 0;
                            vibrationPattern[1] = 1000;
                            vibrationPattern[2] = 5000;
                            vibrationPattern[3] = 2000;
                            map["icon"] = 'secondary_icon';
                            map["sound"] = 'slow_spring_board';
                            map["largeIcon"] = 'sample_large_icon';
                            map["vibrationPattern"] = vibrationPattern;
                            await notificationBuilder.scheduleNotification(
                                title, body, 5, map);
                          })),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Repeat notification every minute'),
                      onPressed: () async {
                        var title = "Repeat Notification";
                        var body = "My Testing";
                        await notificationBuilder.repeatNotification(
                            title, body, RepeatInterval.EveryMinute);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text(
                          'Repeat notification every day at approximately 21:00:00 pm'),
                      onPressed: () async {
                        var title = "Show daily Notification";
                        var body = "My Testing";
                        var time = new Time(21, 0, 0);
                        await notificationBuilder.showDailyAtTime(
                            title, body, time);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text(
                          'Repeat notification weekly on Monday at approximately 10:00:00 am'),
                      onPressed: () async {
                        var title = "Show weekly Notification";
                        var body = "My Testing";
                        var time = new Time(21, 06, 00);
                        await notificationBuilder.showWeeklyAtDayAndTime(
                            title, body, time, Day.Monday);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Show notification with no sound'),
                      onPressed: () async {
                        var title = "Show notification with no sound";
                        var body = "My Testing";
                        await notificationBuilder.showNotificationWithNoSound(
                            title, body);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child:
                          new Text('Show big picture notification [Android]'),
                      onPressed: () async {
                        var title = "Big Picture Notification";
                        var body = "My Testing";
                        Map map = new Map();

                        map["largeIconResponse"] =
                            await http.get('http://via.placeholder.com/48x48');
                        map["largeIconPath"] = 'largeIcon';
                        map["bigPictureResponse"] = await http
                            .get('http://via.placeholder.com/400x800');
                        map["bigPicturePath"] = 'bigPicture';
                        map["contentTitle"] =
                            'overridden <b>big</b> content title';
                        map["summaryText"] = 'summary <i>text</i>';

                        await notificationBuilder.showBigPictureNotification(
                            title, body, map);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Show big text notification [Android]'),
                      onPressed: () async {
                        var title = "Big Text Notification";
                        var body = "My Testing";
                        Map map = new Map();
                        var bigTextStyleInformation =
                            'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>,' +
                                'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.' +
                                ' Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris ' +
                                'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in ' +
                                'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.' +
                                ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia ' +
                                'deserunt mollit anim id est laborum.';
                        map["text"] = bigTextStyleInformation;
                        map["contentTitle"] =
                            'overridden <b>big</b> content title';
                        map["summaryText"] = 'summary <i>text</i>';
                        await notificationBuilder.showBigTextNotification(
                            title, body, map);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Show inbox notification [Android]'),
                      onPressed: () async {
                        var title = "Inbox Notification";
                        var body = "My Testing";
                        Map map = new Map();
                        List<String> list = ['line <b>1</b>', 'line <i>2</i>'];
                        map["contentTitle"] =
                            'overridden <b>inbox</b> context title';
                        map["summaryText"] = 'summary <i>text</i>';
                        map["lines"] = list;
                        await notificationBuilder.showInboxNotification(
                            title, body, map);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Show grouped notifications [Android]'),
                      onPressed: () async {
                        var title = "Grouped Notification";
                        var body = "My Testing";
                        Map map1 = new Map();
                        map1["contentTitle"] = 'Alex Faarborg';
                        map1["contentSummary"] = 'You will not believe...';
                        Map map2 = new Map();
                        map2["contentTitle"] = 'Yatheesha';
                        map2["contentSummary"] = 'I will believe...';
                        List<Map> list = [map1, map2];
                        Map map = new Map();
                        map["titlemessage"] = "new messages";
                        map["summaryText"] = "roboticsjyt@gmail.com";
                        map["lines"] = list;
                        await notificationBuilder.showGroupedNotifications(
                            title, body, map);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('Show ongoing notification [Android]'),
                      onPressed: () async {
                        var title = "Ongoing Notification";
                        var body = "My Testing";
                        await notificationBuilder.showOngoingNotification(
                            title, body);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text(
                          'Show notification with no badge, alert only once [Android]'),
                      onPressed: () async {
                        var title =
                            "Show notification with no badge, alert only once [Android]";
                        var body = "My Testing";
                        await notificationBuilder.showNotificationWithNoBadge(
                            title, body);
                      },
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new RaisedButton(
                      child: new Text('cancel all notifications'),
                      onPressed: () async {
                        await notificationBuilder.cancelAllNotifications();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
