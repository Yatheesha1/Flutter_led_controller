import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ledcontroller/AppBarIconActions/addnewdevice.dart';
import 'package:ledcontroller/CustomStyles/flushbar-style.dart';
import 'package:ledcontroller/Data/device_data.dart';
import 'package:ledcontroller/DialogStyles/cupertino_alert_sheet.dart';
import 'package:ledcontroller/database/deviceDBhelper.dart';

List<String> items = <String>[];
// LocalStorage localStorage;
String myDataString = "";
DeviceDBHelper deviceDBHelper;

Future<List<DeviceData>> fetchDeviceFromDatabase() async {
  deviceDBHelper = DeviceDBHelper();
  Future<List<DeviceData>> models = deviceDBHelper.getDeviceDatas();
  return models;
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: DialogWindowStateful(),
    );
  }
}

class DialogWindowStateful extends StatefulWidget {
  @override
  State createState() => new DialogWindow();
}

void navigateToAddNewDevice(context) {
  Navigator.push(
    context,
    new MaterialPageRoute(builder: (context) => new AddNewDevice()),
  );
}

class DialogWindow extends State<DialogWindowStateful>
    with WidgetsBindingObserver {
  String mytitle;
  String mymodel;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void showDialogActionSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<Map>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((Map value) {
      if (value != null) {
        if (value["status"] == "Delete") {
          delete(value["data"]);
        }
      }
    });
  }

  void openDialogActionSheet(snapshot, index) {
    Map mymap = new Map();
    List<String> list = ['Open', 'Add New', 'Edit', 'Delete'];

    mymap["title"] = "Name: " + snapshot.data[index].name;
    mymap["content"] = "Model: " + snapshot.data[index].model;
    mymap["column"] = "id";
    mymap["data"] = snapshot.data[index].id;
    mymap["actions"] = list;
    print(snapshot.data[index].model);
    showDialogActionSheet<String>(
      context: context,
      child: ActionSheetDialog(map: mymap),
    );
  }

  void delete(int id) {
    setState(() {
      Map snackBuilder = new Map();
      CustomFlushBar customFlashBar = new CustomFlushBar();
      if (deviceDBHelper.deleteDeviceData(id) != null) {
        snackBuilder["message"] = "Device deleted successfully";
        snackBuilder["status"] = "Success";
        snackBuilder["icon"] = Icons.check;
        snackBuilder["color"] = Colors.green[300];
      } else {
        snackBuilder["message"] = "Device not deleted";
        snackBuilder["status"] = "Failure";
        snackBuilder["icon"] = Icons.info_outline;
        snackBuilder["color"] = Colors.red[300];
      }
      customFlashBar.flushBar(snackBuilder)..show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      // appBar: new AppBar(title: new Text("Home Page"), actions: <Widget>[
      //   new IconButton(
      //     icon: new Icon(Icons.add),
      //     onPressed: () {
      //       // _showDialog();
      //       navigateToAddNewDevice();
      //     },
      //   ),
      // ]),
      body: new FutureBuilder<List<DeviceData>>(
        future: fetchDeviceFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
              itemBuilder: (context, index) {
                return new GestureDetector(
                  child: new Card(
                    child: GridTile(
                      footer: new GridTileBar(
                        backgroundColor: Colors.black26,
                        title: new _GridTitleText(snapshot.data[index].name),
                        subtitle:
                            new _GridTitleText(snapshot.data[index].model),
                        trailing: new IconButton(
                          alignment: Alignment.centerRight,
                          icon: new Icon(Icons.more_vert),
                          iconSize: 20.0,
                          // color: Colors.white,
                          padding: const EdgeInsets.all(1.0),
                          onPressed: () {
                            // _showDialog();
                            openDialogActionSheet(snapshot, index);
                          },
                        ),
                      ),
                      // ),
                      child:
                          // new Image.asset(
                          //   'graphics/india_chennai_flower_market.png',
                          //   fit: BoxFit.cover,
                          // )

                          new Icon(
                        Icons.access_time,
                        size: 75.0,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  onLongPress: () {
                    openDialogActionSheet(snapshot, index);
                  },

                  // child: new Card(
                  //   child: new Stack(
                  //     children: <Widget>[
                  //       new Column(
                  //         crossAxisAlignment: CrossAxisAlignment.stretch,
                  //         children: <Widget>[
                  //           new Stack(
                  //             children: <Widget>[
                  //               //new Center(child: new CircularProgressIndicator()),
                  //               new Center(
                  //                 child: new Center(
                  //                   child: new Padding(
                  //                     padding: const EdgeInsets.all(4.0),
                  //                     child: new Icon(
                  //                       Icons.access_time,
                  //                       size: 75.0,
                  //                       color: Colors.orange,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //       new Positioned(
                  //         bottom: 0.0,
                  //         left: 0.0,
                  //         // top: -12.0,
                  //         // right: 2.0,
                  //         child: new Container(
                  //             // decoration: new BoxDecoration(color: Colors.red),
                  //             child: new Stack(
                  //           children: <Widget>[
                  //             new Padding(
                  //               padding: const EdgeInsets.all(2.0),
                  //               child: new Column(
                  //                 children: <Widget>[
                  //                   new Text(
                  //                     snapshot.data[index].name,
                  //                     style: const TextStyle(
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                   new Text(
                  //                     snapshot.data[index].model,
                  //                     style:
                  //                         const TextStyle(color: Colors.grey),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         )),
                  //       ),
                  //       new Positioned(
                  //         top: -13.0,
                  //         right: 0.0,
                  //         // top: -13.0,
                  //         // right: 2.0,
                  //         child: new IconButton(
                  //           alignment: Alignment.centerRight,
                  //           icon: new Icon(Icons.more_vert),
                  //           iconSize: 15.0,
                  //           padding: const EdgeInsets.all(1.0),
                  //           onPressed: () {
                  //             // _showDialog();
                  //             openDialogActionSheet(snapshot, index);
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // onLongPress: () {
                  //   openDialogActionSheet(snapshot, index);
                  // },
                );
              },
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Container(
            alignment: AlignmentDirectional.center,
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _GridTitleText extends StatelessWidget {
  const _GridTitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return new FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: new Text(text),
    );
  }
}
