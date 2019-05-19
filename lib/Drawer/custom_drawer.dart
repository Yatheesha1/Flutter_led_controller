import 'package:flutter/material.dart';

const String _kAsset0 = 'graphics/india_chennai_flower_market.png';
const String _kAsset1 = 'graphics/india_chennai_flower_market.png';
const String _kAsset2 = 'graphics/india_chennai_flower_market.png';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key, this.map}) : super(key: key);
  final Map map;
  // List<Widget> listMyWidgets(context, mymap) {
  //   List<Widget> list = new List();
  //   for (String st in mymap["actions"]) {
  //     // list.add(new CupertinoActionSheetAction(
  //     //   child: Text(st),
  //     //   onPressed: () {
  //     //     map["status"] = st;
  //     //     Navigator.pop(context, map);
  //     //     // Navigator.pop(context, st);
  //     //   },
  //     // ));
  //   }
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    AnimationController _controller;
    Animation<double> _drawerContentsOpacity;
    Animation<Offset> _drawerDetailsPosition;
    bool _showDrawerContents = true;
    const List<String> _drawerContents = <String>[
      'A',
      'B',
      'C',
      'D',
      'E',
    ];
    return new Drawer(
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
                              // onTap: _showNotImplementedMessage,
                            );
                          }).toList(),
                        ),
                      ),
                      // The drawer's "details" view.
                      new SlideTransition(
                        position: _drawerDetailsPosition,
                        child: new FadeTransition(
                          opacity: new ReverseAnimation(_drawerContentsOpacity),
                          child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              new ListTile(
                                leading: const Icon(Icons.add),
                                title: const Text('Add account'),
                                // onTap: _showNotImplementedMessage,
                              ),
                              new ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Manage accounts'),
                                // onTap: _showNotImplementedMessage,
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

  // void _showNotImplementedMessage() {
  //   Navigator.pop(context); // Dismiss the drawer.
  //   _scaffoldKey.currentState.showSnackBar(
  //       const SnackBar(content: Text("The drawer's items don't do anything")));
  // }
}
