import 'package:flutter/material.dart';
import 'package:flutter_athena/pages/scriptinfo/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

MaterialColor syskol = Colors.deepPurple;

void main() => runApp(new Appln());

class Appln extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Communicator for LICET",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Communicator"),
          backgroundColor: syskol,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black54, Colors.black87], begin: Alignment.topLeft, end: Alignment.bottomRight)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Center(
                heightFactor: 1.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Login(),
                ),
              ),
            ],
          ),
        ),
        //resizeToAvoidBottomPadding: false,
      ),
    );
  }
}

Future<bool> setLoginDataPref(String user, pass) async {
  SharedPreferences userpref = await SharedPreferences.getInstance();
  userpref.setString("user", user);
  userpref.setString("pass", pass);
  return userpref.commit();
}

Future<String> getLoginDataPref() async {
  SharedPreferences userpref = await SharedPreferences.getInstance();
  String data, username, password;
  if (userpref.getString("user").length != 0) {
    username = userpref.getString("user");
    password = userpref.getString("pass");
    data = '["$username", "$password"]';
//    var info = json.decode(data);
//    return info;
  } else
    data = "negative";
  return Future.value(data);
}