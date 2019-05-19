import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionAlertWithTitleDialog extends StatelessWidget {
  const ActionAlertWithTitleDialog({Key key, this.map}) : super(key: key);
  final Map map;

  List<Widget> listMyWidgets(context, mymap) {
    List<Widget> list = new List();
    for (String st in mymap["actions"]) {
      list.add(
        new CupertinoDialogAction(
          child: Text(st),
          onPressed: () {
            map["status"] = st;
            Navigator.pop(context, map);
          },
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoAlertDialog(
      title: Text(map["title"]),
      content: Text(map["content"]),
      actions: listMyWidgets(context, map),
    );
  }
}
