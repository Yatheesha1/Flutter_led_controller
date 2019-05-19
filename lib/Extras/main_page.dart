import 'package:flutter/material.dart';
import 'package:ledcontroller/Drawer/DraverPages/notification.dart';
import '../CustomBottomNavigation/BottomNavigationPage/home_page.dart';
import '../CustomBottomNavigation/BottomNavigationPage/info_page.dart';
import '../CustomBottomNavigation/BottomNavigationPage/profile_page.dart';

class MainApp extends StatefulWidget {
  @override
  State createState() => new _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int i = 0;
  var pages = [
    new HomePage(),
    new ProfilePage(),
    new InfoPage(),
    // new SettingsPage(),
    new NotificationPage(),
    // new DrawerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: pages[i],
      // drawer: new AppNavigationDrawer(),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text('Profie'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.info),
            title: new Text('Info'),
          ),
          // new BottomNavigationBarItem(
          //   icon: new Icon(Icons.settings),
          //   title: new Text('Settings'),
          // ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.menu),
            title: new Text('Menus'),
          ),
        ],
        currentIndex: i,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            i = index;
          });
        },
      ),
    );
  }
}
