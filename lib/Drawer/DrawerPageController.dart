import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/CustomStyles/flushbar-style.dart';
import 'package:ledcontroller/Drawer/DraverPages/FirebasePage.dart';
import 'package:ledcontroller/Drawer/DraverPages/notification.dart';

class DrawerPageItem {
  String title;
  var page;
  IconData icon;
  DrawerPageItem({this.title, this.page, this.icon});
}

class CustomDrawerPage {
  BuildContext context;
  CustomDrawerPage();

  List<DrawerPageItem> drawerPageItems = <DrawerPageItem>[
    new DrawerPageItem(
      title: 'Firebase Page',
      // page: (context) => navigateToFirebasePage(context),
      icon: Icons.home,
    ),
    new DrawerPageItem(
      title: 'Notification Page',
      // page: (context) => navigateToFirebasePage(context),
      icon: Icons.notifications,
    ),
  ];
}

class CustomDrawerPageNavigator {
  CustomDrawerPageNavigator({this.title, this.context});
  String title;
  BuildContext context;
  void pages() {
    Navigator.pop(context);
    switch (title) {
      case "Firebase Page":
        // Navigator.pop(context); // Dismiss the drawer.
        // _scaffoldKey.currentState.showSnackBar(
        //     const SnackBar(content: Text("The drawer's items don't do anything")));
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new FirebasePage()),
        );
        break;
      case "Notification Page":
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new MyNotificationPage()),
        );
        break;
      default:
        Map snackBuilder = new Map();
        CustomFlushBar customFlushBar = new CustomFlushBar();
        Flushbar flushbar = Flushbar();

        snackBuilder["message"] = "The drawer's items don't do anything";
        snackBuilder["status"] = "Failure";
        snackBuilder["icon"] = Icons.info_outline;
        snackBuilder["color"] = Colors.red[300];
        // customFlushBar.flushBar(snackBuilder)..dismiss(true);
        flushbar = customFlushBar.flushBar(snackBuilder);
        flushbar..show(context);
    }
  }
}
