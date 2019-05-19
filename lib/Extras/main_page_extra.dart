import 'package:flutter/material.dart';
// import 'bottom_navigation_main.dart';
import 'navigation_page_view.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() => new BottomNavigationMain();
}

class BottomNavigationMain extends State<MainPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.fixed;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: const Icon(Icons.home),
        title: 'Home',
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.account_circle),
        title: 'Profile',
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.settings),
        title: 'Settings',
        vsync: this,
      ),
      new NavigationIconView(
        icon: const Icon(Icons.info),
        title: 'Info',
        vsync: this,
      )
    ];

    for (NavigationIconView view in _navigationViews)
      view.controller.addListener(_rebuild);

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews) view.controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(_type, context));

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _navigationViews
          .map((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      fixedColor: Colors.orange[300],
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Bottom navigation'),
      //   actions: <Widget>[
      //     new PopupMenuButton<BottomNavigationBarType>(
      //       onSelected: (BottomNavigationBarType value) {
      //         setState(() {
      //           _type = value;
      //         });
      //       },
      //       itemBuilder: (BuildContext context) =>
      //           <PopupMenuItem<BottomNavigationBarType>>[
      //             const PopupMenuItem<BottomNavigationBarType>(
      //               // value: BottomNavigationBarType.fixed,
      //               child: const Text('Fixed'),
      //             ),
      //             const PopupMenuItem<BottomNavigationBarType>(
      //               // value: BottomNavigationBarType.shifting,
      //               child: const Text('Shifting'),
      //             )
      //           ],
      //     )
      //   ],
      ),
      body: new Center(child: _buildTransitionsStack()),
      bottomNavigationBar: botNavBar,
    );
  }
}