import 'package:flutter/material.dart';
import 'package:ledcontroller/AppBars/main_page_with_drawer_appbar.dart';
import 'package:ledcontroller/CustomBottomNavigation/custom_bottom_navigation.dart';
import 'package:ledcontroller/Drawer/DrawerPageController.dart';

const String _kAsset0 = 'graphics/india_chennai_flower_market.png';
const String _kAsset1 = 'graphics/india_chennai_flower_market.png';
const String _kAsset2 = 'graphics/india_chennai_flower_market.png';
// const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class DrawerDemo extends StatefulWidget {
  // static const String routeName = '/material/drawer';

  @override
  DrawerDemoState createState() => new DrawerDemoState();
}

class DrawerDemoState extends State<DrawerDemo> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int i = 0;
  CustomBottomNavigationBar customBottomNavigationBar =
      new CustomBottomNavigationBar();
  CustomDrawerPage customDrawerPage = new CustomDrawerPage();

  // static const List<String> _drawerContents = <String>[
  //   'Firebase',
  //   'B',
  //   'C',
  //   'D',
  //   'Notification',
  // ];

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new MainPageAppBar(
          context: context,
          title: customBottomNavigationBar.bottomNavigationBarItems[i].title),
      //     new AppBar(
      //   leading: new IconButton(
      //     // icon: new Icon(_backIcon()),
      //     icon: new Icon(Icons.menu),
      //     alignment: Alignment.centerLeft,
      //     tooltip: 'Back',
      //     onPressed: () {
      //       // Navigator.pop(context);
      //       _scaffoldKey.currentState.openDrawer();
      //     },
      //   ),
      //   title: const Text('Navigation drawer'),
      // ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: const Text('Yatheesha Widget'),
              accountEmail: const Text('yatheesha@example.com'),
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
                            children: customDrawerPage.drawerPageItems
                                .map((DrawerPageItem drawerPageItem) {
                              return new ListTile(
                                leading: new Icon(drawerPageItem.icon),
                                // new CircleAvatar(
                                //     child: new Text(
                                //         '${drawerPageItem.title[0].toUpperCase()}')),
                                title: new Text('${drawerPageItem.title}'),
                                onTap: new CustomDrawerPageNavigator(
                                        title: drawerPageItem.title,
                                        context: context)
                                    .pages,
                              );
                            }).toList(),

                            //     _drawerContents.map((String id) {
                            //   return new ListTile(
                            //     leading: new CircleAvatar(
                            //         child: new Text('${id[0].toUpperCase()}')),
                            //     title: new Text('$id'),
                            //     onTap: _showNotImplementedMessage,
                            //   );
                            // }).toList(),
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
                                  onTap: new CustomDrawerPageNavigator(
                                          context: context)
                                      .pages,
                                ),
                                new ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('Manage accounts'),
                                  onTap: new CustomDrawerPageNavigator(
                                          context: context)
                                      .pages,
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
      body: customBottomNavigationBar.bottomNavigationBarItems[i].page,
      // drawer: new AppNavigationDrawer(),
      bottomNavigationBar: new BottomNavigationBar(
        items: customBottomNavigationBar.getBottomNavigationBarItems(),
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
