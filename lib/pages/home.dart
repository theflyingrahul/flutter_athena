import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './scriptinfo/login.dart';
import 'dart:async';

MaterialColor syskol = Colors.deepPurple;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

String _name = '';
String _dept = '';
String _batch = '';

final userKey = user.uid;
final db = Firestore.instance;

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> listDocuments = new List(10);
  List<Widget> _feed = [];

  @override
  Widget build(BuildContext context) {
    //getUserData();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Dashboard",
          style: TextStyle(
            color: syskol,
          ),
        ),
        backgroundColor: Colors.white70,
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.menu),
            onPressed: (() {}),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream:
                        db.collection('users').document('$userKey').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        _name = snapshot.data['name'];
                        _dept = snapshot.data['dept'];
                        _batch = snapshot.data['batch'];
                        return Text(
                          "Hi $_name!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "What's up?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.normal,
                    color: syskol,
                  ),
                ),
              ),
              NewPost(),
              Text(
                "Circulars",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Segoe',
                  fontWeight: FontWeight.normal,
                  color: syskol,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  if (snapshot.data != null) {
                    listDocuments = snapshot.data.documents;
                    _feed.clear();
                    listDocuments.forEach((document) {
                      String name = document.data['name'];
//                      String dept = document.data['dept'];
//                      String batch = document.data['batch'];
//                      batch = (int.parse(batch)-DateTime.now().year).toString();
                      _feed.add(
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.black12),
                                bottom: BorderSide(
                                  color: Colors.black12,
                                )),
                            //borderRadius: BorderRadius.circular(5),
                          ),
                          child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    child: Icon(Icons.input),
                                    backgroundColor: syskol,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      name,//+' - '+batch+"\u207f\u1d48 Year"+' '+dept,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              initiallyExpanded: true,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 0, bottom: 8),
                                  child: Text(
                                    document.data['content'],
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ]),
                        ),
                      );
                    });
                    return Column(
                      //scrollDirection: Axis.vertical,
                      children: _feed,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController _contentController = new TextEditingController();

  //Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              style: TextStyle(
                fontFamily: 'Segoe',
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                labelText: "Speak your mind here...",
                labelStyle: TextStyle(
                  fontFamily: 'Segoe',
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            alignment: Alignment(1, -1),
            child: RaisedButton(
              child: Text(
                "Post",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Segoe',
                ),
              ),
              color: syskol,
              splashColor: Colors.purple,
              onPressed: (() {
                postMessage({
                  "uid": userKey,
                  "dateTime": DateTime.now().toString().substring(0, 16),
                  "name": _name,
                  "dept": _dept,
                  "batch": _batch,
                  "content": _contentController.text
                });
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postMessage(Map<String, dynamic> post) async {
    await db
        .collection('posts')
        .document(DateTime.now().toString().substring(0, 19) + ' $userKey')
        .setData(post)
        .then((bool) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Posted!"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(label: "Undo", onPressed: () {}),
      ));
    });
  }
}
