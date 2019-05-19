import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Screen 1"), // screen title
        ),
        body: new Center(
          child: new RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/screen3");
            },
            child: new Text("Go to Screen 3"),
          ),
        ));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Screen 1"), // screen title
        ),
        body: new Center(
          child: new RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/screen3");
            },
            child: new Text("Go to Screen 3"),
          ),
        ));
  }
}

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Screen 2"), // screen title
        ),
        body: new Center(
          child: new RaisedButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/screen3");
            },
            child: new Text("Go to Screen 3"),
          ),
        ));
  }
}

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // 1
        appBar: new AppBar(
          title: new Text("Screen 3"), // screen title
        ),
        body: new Center(
          child: new RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text("Back"),
          ),
        ));
  }
}
