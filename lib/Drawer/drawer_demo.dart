// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ledcontroller/CustomClasses/NotificationBuilder.dart';
import 'package:http/http.dart' as http;

const String _kAsset0 = 'graphics/india_chennai_flower_market.png';
const String _kAsset1 = 'graphics/india_chennai_flower_market.png';
const String _kAsset2 = 'graphics/india_chennai_flower_market.png';
// const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new DrawerDemo(),
    );
  }
}

class DrawerDemo extends StatefulWidget {
  // static const String routeName = '/material/drawer';

  @override
  _DrawerDemoState createState() => new _DrawerDemoState();
}

class _DrawerDemoState extends State<DrawerDemo> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static const List<String> _drawerContents = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
  ];

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;
  NotificationBuilder notificationBuilder;

  @override
  void initState() {
    super.initState();
    notificationBuilder = new NotificationBuilder(context);
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(
        const SnackBar(content: Text("The drawer's items don't do anything")));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: new IconButton(
          // icon: new Icon(_backIcon()),
          icon: new Icon(Icons.menu),
          alignment: Alignment.centerLeft,
          tooltip: 'Back',
          onPressed: () {
            // Navigator.pop(context);
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: const Text('Navigation drawer'),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: const Text('Trevor Widget'),
              accountEmail: const Text('trevor.widget@example.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(
                  _kAsset0,
                  // package: _kGalleryAssetsPackage,
                ),
              ),
              otherAccountsPictures: <Widget>[
                new GestureDetector(
                  onTap: () {
                    _onOtherAccountsTap(context);
                  },
                  child: new Semantics(
                    label: 'Switch to Account B',
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        _kAsset1,
                        // package: _kGalleryAssetsPackage,
                      ),
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    _onOtherAccountsTap(context);
                  },
                  child: new Semantics(
                    label: 'Switch to Account C',
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        _kAsset2,
                        // package: _kGalleryAssetsPackage,
                      ),
                    ),
                  ),
                ),
              ],
              margin: EdgeInsets.zero,
              onDetailsPressed: () {
                _showDrawerContents = !_showDrawerContents;
                if (_showDrawerContents)
                  _controller.reverse();
                else
                  _controller.forward();
              },
            ),
            new MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: new Expanded(
                child: new ListView(
                  padding: const EdgeInsets.only(top: 8.0),
                  children: <Widget>[
                    new Stack(
                      children: <Widget>[
                        // The initial contents of the drawer.
                        new FadeTransition(
                          opacity: _drawerContentsOpacity,
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _drawerContents.map((String id) {
                              return new ListTile(
                                leading: new CircleAvatar(child: new Text(id)),
                                title: new Text('Drawer item $id'),
                                onTap: _showNotImplementedMessage,
                              );
                            }).toList(),
                          ),
                        ),
                        // The drawer's "details" view.
                        new SlideTransition(
                          position: _drawerDetailsPosition,
                          child: new FadeTransition(
                            opacity:
                                new ReverseAnimation(_drawerContentsOpacity),
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                new ListTile(
                                  leading: const Icon(Icons.add),
                                  title: const Text('Add account'),
                                  onTap: _showNotImplementedMessage,
                                ),
                                new ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('Manage accounts'),
                                  onTap: _showNotImplementedMessage,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                    child: new Text('Show big picture notification [Android]'),
                    onPressed: () async {
                      var title = "Big Picture Notification";
                      var body = "My Testing";
                      Map map = new Map();

                      map["largeIconResponse"] =
                          await http.get('http://via.placeholder.com/48x48');
                      map["largeIconPath"] = 'largeIcon';
                      map["bigPictureResponse"] =
                          await http.get('http://via.placeholder.com/400x800');
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
    );
  }

  void _onOtherAccountsTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: const Text('Account switching not implemented.'),
          actions: <Widget>[
            new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
