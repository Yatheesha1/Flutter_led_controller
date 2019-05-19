import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushBar {
  Flushbar myflashbar;

  Flushbar flushBar(map) {
    this.myflashbar = Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        // reverseAnimationCurve: Curves.decelerate, //Immutable
        // forwardAnimationCurve: Curves.elasticOut, //Immutable
        backgroundColor: Colors.red,
        shadowColor: Colors.blue[800],
        backgroundGradient:
            new LinearGradient(colors: [Colors.blue, Colors.black]),
        isDismissible: true,
        duration: Duration(seconds: 3),
        icon: Icon(
          map["icon"],
          size: 28.0,
          color: map["color"],
        ),
        // mainButton:
        // FlatButton(
        //   onPressed: () {},
        //   child: Text(
        //     "CLAP",
        //     style: TextStyle(color: Colors.amber),
        //   ),
        // ),
        showProgressIndicator: false,
        progressIndicatorBackgroundColor: Colors.blueGrey,
        // titleText:
        // new Text(
        //   "Hello Hero",
        //   style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 10.0,
        //       color: Colors.yellow[600],
        //       fontFamily: "ShadowsIntoLightTwo"),
        // ),
        messageText: new Text(
          map["message"],
          style: TextStyle(
              fontSize: 14.0,
              color: map["color"],
              fontFamily: "ShadowsIntoLightTwo"),
        ),
        leftBarIndicatorColor: Colors.orange[300]);

    return this.myflashbar;
  }
}
