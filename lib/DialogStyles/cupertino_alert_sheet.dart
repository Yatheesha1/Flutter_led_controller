import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheetDialog extends StatelessWidget {
  const ActionSheetDialog({Key key, this.map}) : super(key: key);
  final Map map;

  List<Widget> listMyWidgets(context, mymap) {
    List<Widget> list = new List();
    for (String st in mymap["actions"]) {
      list.add(new CupertinoActionSheetAction(
        child: Text(st),
        onPressed: () {
          map["status"] = st;
          Navigator.pop(context, map);
          // Navigator.pop(context, st);
        },
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return new CupertinoActionSheet(
        title: Text(map["title"]),
        message: Text(map["content"]),
        actions: listMyWidgets(context, map),
        cancelButton: new CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            map["status"] = "Cancel";
            Navigator.pop(context, map);
            // Navigator.pop(context, "Cancel");
          },
        ));
  }
}
