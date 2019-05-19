import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ledcontroller/Data/device_data.dart';
import 'package:ledcontroller/database/deviceDBhelper.dart';
import 'package:ledcontroller/Extras/modellist.dart';

List<String> items = <String>[];
// LocalStorage localStorage;
String myDataString = "";
DeviceDBHelper deviceDBHelper;

Future<List<DeviceData>> fetchDeviceFromDatabase() async {
  deviceDBHelper = DeviceDBHelper();
  Future<List<DeviceData>> models = deviceDBHelper.getDeviceDatas();
  return models;
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: DialogWindowStateful(),
    );
  }
}

// class ChitmappingStateful extends StatefulWidget {
//   @override
//   State createState() => new Chitmapping();
// }

// class Chitmapping extends State<ChitmappingStateful> {
//   bool _showDividers = true;
//   // bool _reverseSort = false;

//   Widget buildListTile(BuildContext context, String item) {
//     return new MergeSemantics(
//       child: new ListTile(
//         dense: false,
//         leading: new ExcludeSemantics(
//             child: new CircleAvatar(child: new Text(item[0].toUpperCase()))),
//         title: new Text('$item'),
//         subtitle: new Text('subtitle'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Iterable<Widget> listTiles =
//         items.map((String item) => buildListTile(context, item));
//     if (_showDividers)
//       listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

//     return new Scaffold(
//         resizeToAvoidBottomPadding: false,
//         body:
//         new ListView(
//           children: <Widget>[
//             new Container(
//               child:
//               new Column(
//                 // padding: new EdgeInsets.symmetric(vertical: 8.0),
//                 children: listTiles.toList(),
//               ),
//             ),
//           ],
//         ));
//   }
// }

class DialogWindowStateful extends StatefulWidget {
  @override
  State createState() => new DialogWindow();
}

class DialogWindow extends State<DialogWindowStateful>
    with WidgetsBindingObserver {
  DeviceData employee = new DeviceData();

  String mytitle;
  String mymodel;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // localStorage=new LocalStorage();
    // var temp=[];
    // myDataString=json.encode(temp);
    // localStorage.setItem("mydata", myDataString);
  }

  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");
  final TextEditingController t3 = new TextEditingController(text: "");
  addclicked() {
    setState(() {
      items.add(t1.text);
      var model = DeviceData();
      model.name = t1.text;
      model.model = t2.text;
      model.uid = t3.text;
      deviceDBHelper.insertDeviceData(model);
      // _showSnackBar("Data saved successfully");
      // print("Data saved successfully");
    });
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void navigateToModelList() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new MyModelList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      // appBar: new AppBar(title: new Text("Profile"), actions: <Widget>[
      //   new IconButton(
      //     icon: new Icon(Icons.add),
      //     onPressed: () {
      //       _showDialog();
      //     },
      //   ),
      //   new IconButton(
      //     icon: const Icon(Icons.view_list),
      //     tooltip: 'Next choice',
      //     onPressed: () {
      //       navigateToModelList();
      //     },
      //   ),
      // ]),
      body:
          // ChitmappingStateful(),
          new FutureBuilder<List<DeviceData>>(
        future: fetchDeviceFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(snapshot.data[index].name,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                        new Text(snapshot.data[index].model,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                        new Text(snapshot.data[index].uid,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0)),
                        new Divider()
                      ]);
                });
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator());
        },
      ),
    );
  }

  showAlertDialog() async {
    await showDialog<String>(
      context: context,
      builder: (_) => new _SystemPadding(
            child: new AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // new Expanded(
                  //   child:
                  new TextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        labelText: 'Title', hintText: 'Input title'),
                    controller: t1,
                  ),
                  // ),
                  // new Expanded(
                  //   child:
                  new TextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        labelText: 'Model', hintText: 'Input model'),
                    controller: t2,
                  ),
                  // )
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('SAVE'),
                    onPressed: () {
                      addclicked();
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.padding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
