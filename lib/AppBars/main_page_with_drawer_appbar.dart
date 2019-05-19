import 'package:flutter/material.dart';
import 'package:ledcontroller/AppBarIconActions/addnewdevice.dart';
import 'package:ledcontroller/CustomBottomNavigation/BottomNavigationPage/settings_page.dart';

class MainPageAppBar extends AppBar {
  MainPageAppBar({Key key, String title, BuildContext context})
      : super(
            key: key,
            title: new Text(title),
            actions: appbaraction(title, context));
}

List<Widget> appbaraction(title, context) {
  List<Widget> list = new List();
  switch (title) {
    case "Home Page":
      list.add(new IconButton(
        icon: new Icon(Icons.add),
        onPressed: () {
          // _showDialog();
          navigateToAddNewDevice(context);
        },
      ));
      break;

    case "Info Page":
      list.add(
        new IconButton(
          icon: new Icon(Icons.add),
          onPressed: () {
            // _showDialog();
            // navigateToAddNewDevice(context);
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                      title: new Text("Dialog Title"),
                      content: new Text("This is my conent"),
                    ));
          },
        ),
      );
      break;

    case "Profile Page":
      list.add(new IconButton(
        icon: new Icon(Icons.add),
        onPressed: () {
          // showAlertDialog();
        },
      ));
      list.add(
        new IconButton(
          icon: const Icon(Icons.view_list),
          tooltip: 'Next choice',
          onPressed: () {
            // navigateToModelList();
          },
        ),
      );
      break;

    case "Settings Page":
      list.add(new IconButton(
        icon: new Icon(choices[0].icon),
        onPressed: () {
          // _select(choices[0]);
        },
      ));
      list.add(new IconButton(
        icon: new Icon(choices[1].icon),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Dialog Title"),
                    content: new Text("This is my conent"),
                  ));
        },
      ));
      list.add(
        new IconButton(
          icon: new Icon(choices[2].icon),
          onPressed: () {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Sending Message"),
            ));
          },
        ),
      );
      break;

    default:
      break;
  }
  return list;
}

void navigateToAddNewDevice(context) {
  Navigator.push(
    context,
    new MaterialPageRoute(builder: (context) => new AddNewDevice()),
  );
}
