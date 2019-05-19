import 'package:flutter/material.dart';

import './BottomNavigationPage/settings_page.dart';
import './BottomNavigationPage/home_page.dart';
import './BottomNavigationPage/info_page.dart';
import './BottomNavigationPage/profile_page.dart';

class BottomNavigationItem {
  String title;
  var page;
  IconData icon;
  String text;
  BottomNavigationItem({this.title, this.page, this.icon, this.text});
}

class CustomBottomNavigationBar {
  CustomBottomNavigationBar();

  List<BottomNavigationItem> bottomNavigationBarItems = <BottomNavigationItem>[
    new BottomNavigationItem(
        title: 'Home Page',
        page: new HomePage(),
        icon: Icons.home,
        text: "Home"),
    new BottomNavigationItem(
        title: 'Profile Page',
        page: new ProfilePage(),
        icon: Icons.account_circle,
        text: "Profile"),
    new BottomNavigationItem(
        title: 'Info Page',
        page: new InfoPage(),
        icon: Icons.info,
        text: "Info"),
    new BottomNavigationItem(
        title: 'Settings Page',
        page: new SettingsPage(),
        icon: Icons.settings,
        text: "Settings"),
  ];

  List<BottomNavigationBarItem> getBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = new List();
    for (var item in bottomNavigationBarItems) {
      items.add(new BottomNavigationBarItem(
        icon: new Icon(item.icon),
        title: new Text(item.text),
      ));
    }
    return items;
  }
}
