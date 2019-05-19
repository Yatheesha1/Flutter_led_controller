import 'package:flutter/material.dart';
import 'package:ledcontroller/Data/device_data.dart';
import 'dart:async';

import 'package:ledcontroller/database/deviceDBhelper.dart';

DeviceDBHelper deviceDBHelper;

Future<List<DeviceData>> fetchDeviceFromDatabase() async {
  deviceDBHelper = DeviceDBHelper();
  Future<List<DeviceData>> models = deviceDBHelper.getDeviceDatas();
  return models;
}

class MyModelList extends StatefulWidget {
  @override
  MyModelListPageState createState() => new MyModelListPageState();
}

class MyModelListPageState extends State<MyModelList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Model List'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(4.0),
        child: new FutureBuilder<List<DeviceData>>(
          future: fetchDeviceFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return new Card(
                    child: new Column(
                      children: <Widget>[
                        new Stack(
                          children: <Widget>[
                            //new Center(child: new CircularProgressIndicator()),
                            new Center(
                              child: new Center(
                                child: new Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: new Icon(
                                    Icons.access_time,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: new Column(
                            children: <Widget>[
                              new Text(
                                snapshot.data[index].name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              new Text(
                                snapshot.data[index].uid,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                  // new Card(
                  //   child: new GridTile(
                  //     footer: new Text(data[index]['name']),
                  //       child: new Text(data[index]['image']), //just for testing, will fill with image later
                  //   ),
                  // );
                },
              );

              // new ListView.builder(
              //     itemCount: snapshot.data.length,
              //     itemBuilder: (context, index) {
              //       return new Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             new Text(snapshot.data[index].title,
              //                 style: new TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 18.0)),
              //             new Text(snapshot.data[index].model,
              //                 style: new TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 14.0)),
              //             new Divider()
              //           ]);
              //     });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
