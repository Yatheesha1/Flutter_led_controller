import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ledcontroller/CustomStyles/flushbar-style.dart';
import 'package:ledcontroller/Data/device_data.dart';
import 'package:ledcontroller/DialogStyles/cupertino_alert_with_title.dart';
// import 'package:ledcontroller/Global/global.dart';
// import 'package:ledcontroller/DataClasses/device_data_helper.dart';
import 'package:ledcontroller/database/deviceDBhelper.dart';
import 'package:flushbar/flushbar.dart';

DeviceDBHelper deviceDBHelper;

Future<List<DeviceData>> fetchModelsFromDatabase() async {
  deviceDBHelper = new DeviceDBHelper();
  Future<List<DeviceData>> models = deviceDBHelper.getDeviceDatas();
  return models;
}

class AddNewDevice extends StatefulWidget {
  @override
  AddNew createState() {
    return new AddNew();
  }
}

class AddNew extends State<AddNewDevice> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DeviceData mydevice = new DeviceData();
  DeviceData mydeviceold = new DeviceData();
  bool _obscureText = true;

  bool _autovalidate = false;
  bool _formWasEdited = false;
  bool _formSaved = false;
  bool uniq = true;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();

  CustomFlushBar customFlushBar = new CustomFlushBar();
  Flushbar flushbar = Flushbar();
  // final IndiaNumberTextInputFormatter _phoneNumberFormatter =
  //     new IndiaNumberTextInputFormatter();

  addclicked() async {
    deviceDBHelper = new DeviceDBHelper();

    final FormState form = _formKey.currentState;
    form.save();
    _formSaved = false;

    Map snackBuilder = new Map();

    DeviceData temp = await deviceDBHelper.insertDeviceData(mydevice);

    if (temp != null) {
      snackBuilder["message"] = "Data saved successfully";
      snackBuilder["status"] = "Success";
      snackBuilder["icon"] = Icons.check;
      snackBuilder["color"] = Colors.green[300];
      // customFlushBar.flushBar(snackBuilder)..dismiss(true);
      flushbar = customFlushBar.flushBar(snackBuilder);
      flushbar..show(context);
      mydeviceold = mydevice;
      mydevice = new DeviceData();
      _formWasEdited = false;
      _formSaved = true;
    } else {
      uniq = false;
      if (!form.validate()) {
        _autovalidate = true; // Start validating on every change.
        snackBuilder["message"] =
            'Please fix the errors in red before submitting.';
        snackBuilder["status"] = "Failure";
        snackBuilder["icon"] = Icons.info_outline;
        snackBuilder["color"] = Colors.red[300];
        flushbar = customFlushBar.flushBar(snackBuilder);
        flushbar..show(context);
      }
      print(snackBuilder["message"]);
    }
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    Map snackBuilder = new Map();
    uniq = true;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      snackBuilder["message"] =
          'Please fix the errors in red before submitting.';
      snackBuilder["status"] = "Failure";
      snackBuilder["icon"] = Icons.info_outline;
      snackBuilder["color"] = Colors.red[300];
      // customFlushBar.flushBar(snackBuilder)..dismiss(true);
      // _scaffoldKey.currentState
      //     .removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
      flushbar = customFlushBar.flushBar(snackBuilder);
      flushbar..show(context);
      // showInFlashBar(snackBuilder);
    } else {
      addclicked();
      // _warnUserAboutSave();
    }
  }

  String _validateDeviceName(String value) {
    _formWasEdited = true;
    _formSaved = false;
    if (value.isEmpty) return 'Device name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9_ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alpha-numeric characters.';
    return null;
  }

  String _validateDeviceModel(String value) {
    _formWasEdited = true;
    _formSaved = false;
    if (value.isEmpty) return 'Device name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9_ ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alpha-numeric characters.';
    return null;
  }

  String _validateDeviceUID(String value) {
    _formWasEdited = true;
    _formSaved = false;
    if (value.isEmpty) return 'Device UID is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alpha-numeric characters.';
    else if (!uniq) return 'UID should be unique.';
    return null;
  }

  String _validateDeviceUserName(String value) {
    _formWasEdited = true;
    _formSaved = false;
    // if (value.isEmpty) return 'User name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9_ ]+$');
    // if (!nameExp.hasMatch(value))
    //   return 'Please enter only alpha-numeric characters.';
    return null;
  }

  String _validatePassword(String value) {
    _formWasEdited = true;
    _formSaved = false;
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    // if (passwordField.value == null || passwordField.value.isEmpty)
    //   return 'Please enter a password.';
    if (passwordField.value != value) return 'The passwords don\'t match';
    return null;
  }

  Future<bool> showDialogActionAlertWithTitle<T>(
      {BuildContext context, Widget child}) async {
    return await showCupertinoModalPopup<Map>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<bool>((Map value) {
      if (value != null) {
        if (value["status"] == "YES") {
          return true;
        }
        if (value["status"] == "NO") {
          return false;
        }
      }
    });
  }

  Future<bool> openDialogActionAlertWithTitle() async {
    Map mymap = new Map();
    List<String> list = ['NO', 'YES'];

    mymap["title"] = "Device is not added";
    mymap["content"] = 'Are you sure you want to leave this form?';
    mymap["actions"] = list;
    // print(snapshot.data[index].model);
    return await showDialogActionAlertWithTitle<bool>(
      context: context,
      child: ActionAlertWithTitleDialog(map: mymap),
    );
  }

  Future<bool> _warnUserAboutLeaveForm() async {
    final FormState form = _formKey.currentState;
    form.save();
    if (mydevice.model == "" && mydevice.name == "" && mydevice.uid == "")
      return true;
    if (_formSaved) {
      if (mydevice.name == mydeviceold.name &&
          mydevice.model == mydeviceold.model &&
          mydevice.uid == mydeviceold.uid) return true;
    }
    // if (form.validate());

    return await openDialogActionAlertWithTitle();
    // return await showDialog<bool>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return new AlertDialog(
    //           title: const Text('Device is not added'),
    //           content: const Text('Really leave this form?'),
    //           actions: <Widget>[
    //             new FlatButton(
    //               child: const Text('YES'),
    //               onPressed: () {
    //                 Navigator.of(context).pop(true);
    //               },
    //             ),
    //             new FlatButton(
    //               child: const Text('NO'),
    //               onPressed: () {
    //                 Navigator.of(context).pop(false);
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     ) ??
    //     false;
  }

  // Future<bool> _warnUserAboutSave() async {
  //   final FormState form = _formKey.currentState;
  //   _formSaved = false;
  //   form.save();
  //   return await showDialog<bool>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return new AlertDialog(
  //             title: const Text('Confirm'),
  //             content: const Text('Do you want to add this device?'),
  //             actions: <Widget>[
  //               new FlatButton(
  //                 child: const Text('YES'),
  //                 onPressed: () {
  //                   addclicked();
  //                   Navigator.of(context).pop(true);
  //                 },
  //               ),
  //               new FlatButton(
  //                 child: const Text('NO'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       ) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Add New Device'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: () {
              _handleSubmitted();
            },
          ),
        ],
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          onWillPop: _warnUserAboutLeaveForm,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      filled: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Device Name *',
                      hintText: 'Name the device to identify yourself',
                      suffixStyle: const TextStyle(color: Colors.green)),
                  maxLines: 1,
                  onSaved: (String value) {
                    mydevice.name = value;
                  },
                  validator: _validateDeviceName,
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      filled: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Device Model *',
                      hintText: 'Type of the model',
                      suffixStyle: const TextStyle(color: Colors.green)),
                  maxLines: 1,
                  onSaved: (String value) {
                    mydevice.model = value;
                  },
                  validator: _validateDeviceModel,
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  // textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    hintText: 'Unique identifiation of the device',
                    labelText: 'UID *',
                  ),
                  onSaved: (String value) {
                    mydevice.uid = value;
                  },
                  validator: _validateDeviceUID,
                ),
                // const SizedBox(height: 24.0),
                // new Center(
                //   child: new RaisedButton(
                //     color: Colors.green,
                //     child: const Text('Add Device'),
                //     onPressed: _handleSubmitted,
                //   ),
                // ),
                const SizedBox(height: 24.0),
                new Text('* indicates required field',
                    style: Theme.of(context).textTheme.caption),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
