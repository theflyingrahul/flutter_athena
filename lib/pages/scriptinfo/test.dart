import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

String _name = '';
String _dept = '';
String _batch = '';

final userKey = user.uid;
final db = Firestore.instance;

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot){
        if(snapshot.connectionState==ConnectionState.done){
          return Text("Hi $_name");
        }
        else{
          return LinearProgressIndicator();
        }
      },

    );
  }

  Future<void> getUserData() async {
    await db
        .collection('users')
        .document('$userKey')
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          _name = documentSnapshot.data['name'];
          _dept = documentSnapshot.data['dept'];
          _batch = documentSnapshot.data['batch'];
        });
      }
    });
  }
}
