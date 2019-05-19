import 'package:flutter/material.dart';
import 'package:ledcontroller/main_page_with_drawer.dart';

void main() => runApp(new LedApp());

class LedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Led Controller",
      debugShowCheckedModeBanner: false,
      // theme: new ThemeData(
      //   primaryColor: const Color(0xFFFF7700),
      //   accentColor: const Color(0xFFFF7700),
      //   primaryColorBrightness: Brightness.dark,
      // ),
      // home: new MainApp(),
      home: new DrawerDemo(),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';

// void main() {
//   runApp(new MyApp());
// }

// class LifecycleWatcher extends StatefulWidget {
//   @override
//   _LifecycleWatcherState createState() => new _LifecycleWatcherState();
// }

// class _LifecycleWatcherState extends State<LifecycleWatcher>
//     with WidgetsBindingObserver {
//   AppLifecycleState _lastLifecyleState;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void onDeactivate() {
//     super.deactivate();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print(
//         "LifecycleWatcherState#didChangeAppLifecycleState state=${state.toString()}");
//     setState(() {
//       _lastLifecyleState = state;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_lastLifecyleState == null)
//       return new Text('This widget has not observed any lifecycle changes.');
//     return new Text(
//         'The most recent lifecycle state this widget observed was: $_lastLifecyleState.');
//   }
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: new MyHomePage(title: 'Flutter App Lifecycle'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int timerCounter = 0;
//   // ignore: unused_field only created once
//   Timer timer;

//   _MyHomePageState() {
//     print("_MyHomePageState#constructor, creating new Timer.periodic");
//     timer = new Timer.periodic(
//         new Duration(milliseconds: 3000), _incrementTimerCounter);
//   }

//   void _incrementTimerCounter(Timer t) {
//     print("_timerCounter is $timerCounter");
//     setState(() {
//       timerCounter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text("config.title"),
//       ),
//       body: new Column(
//         children: [
//           new Text(
//             'Timer called $timerCounter time${timerCounter == 1 ? '' : 's'}.',
//           ),
//           new LifecycleWatcher(),
//         ],
//       ),
//     );
//   }
// }
