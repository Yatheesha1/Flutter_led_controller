import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

List<String> items = <String>[];
List<Widget> _tiles = <Widget>[];
List<StaggeredTile> _staggeredTiles = <StaggeredTile>[];

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

class DialogWindow extends State<DialogWindowStateful> {
  final TextEditingController t1 = new TextEditingController(text: "");
  addclicked() {
    setState(() {
      items.add(t1.text);
      print(items);
      _tiles.add(_Example01Tile(Colors.lightBlue, Icons.widgets,t1.text));
      _staggeredTiles.add(StaggeredTile.count(2, 2));
      Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("" + t1.text + " is added"),
          ));
      t1.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(title: new Text("Profile"), actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.add),
          onPressed: () {
            _showDialog();
          },
        ),
      ]),
      body: Example01(),
    ));
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (_) => new _SystemPadding(
            child: new AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Full Name', hintText: 'Input Text'),
                      controller: t1,
                    ),
                  )
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

class Example01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: new StaggeredGridView.count(
                crossAxisCount: 6,
                staggeredTiles: _staggeredTiles,
                children: _tiles,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                padding: const EdgeInsets.all(1.0))));
  }
}

class _Example01Tile extends StatelessWidget {
  const _Example01Tile(this.backgroundColor, this.iconData,this.mytext);

  final Color backgroundColor;
  final IconData iconData;
  final String mytext;

  @override
  Widget build(BuildContext context) {
    // return new Card(
    //   color: backgroundColor,
    //   child: new InkWell(
    //     onTap: () {Scaffold.of(context).showSnackBar(new SnackBar(
    //                   content: new Text("Item pressed"),
    //                 ));},
    //     child: new Center(
    //       child: new Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: new Icon(
    //           iconData,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //   ),
    // );

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
                      iconData,
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
                  mytext.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  'Width: ',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
