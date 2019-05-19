import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class TodoItem {
//   final String id;
//   String title;
//   bool completed;

//   TodoItem({
//     @required this.id,
//     @required this.title,
//     this.completed = false,
//   })  : assert(id != null && id.isNotEmpty),
//         assert(title != null && title.isNotEmpty),
//         assert(completed != null);

//   TodoItem.fromMap(Map<String, dynamic> data)
//       : this(id: data['id'], title: data['title'], completed: data['completed'] ?? false);

//   Map<String, dynamic> toMap() => {
//         'id': this.id,
//         'title': this.title,
//         'completed': this.completed,
//       };
// }

// final Future<FirebaseApp> app = FirebaseApp.configure(
//   name: 'test',
//   options: FirebaseOptions(
//       googleAppID: '1:387101173584:android:236f9daea101f77e',
//       apiKey: 'AIzaSyDv4iX_AeAv51Q8WsGoIQBAZ1Qx6mci-Dg',
//       projectID: 'myflutterapp-y9496',
//       databaseURL: "https://myflutterapp-y9496.firebaseio.com"),
// );

class FirebasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final Firestore firestore = Firestore(app: app);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new MyHomePage(),
    );
  }
}

class MessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('todos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return ListView.builder(
          itemCount: messageCount,
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            return ListTile(
              title: Text(document['title'] ?? '<No message retrieved>'),
              subtitle: Text(document['uid'] ?? '<No uid retrieved>'),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  CollectionReference get todos => Firestore.instance.collection('todos');

  Future _addMessage() async {
    // final DocumentReference document = todos.document();

    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(todos.document());
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data["id"] = newDoc.documentID;
      data["title"] = 'Hello world!';
      data["uid"] = "jkjkl";
      data['created'] = new DateTime.now().toUtc().toIso8601String();

      await tx.set(newDoc.reference, data);

      return data;
    };

    // document.setData(<String, dynamic>{
    //   'title': 'Hello world!',
    //   'uid': 'jsdfd',
    //   'created': new DateTime.now().toUtc().toIso8601String(),
    // });

    return Firestore.instance.runTransaction(createTransaction).then((fromMap) {
      print(fromMap);
    }).catchError((e) {
      print('dart error: $e');
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Page'),
      ),
      body: MessageList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
