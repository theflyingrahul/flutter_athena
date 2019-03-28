import 'package:flutter/material.dart';
import './scriptinfo/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './home.dart';

MaterialColor syskol = Colors.deepPurple;

class CollectInfo extends StatefulWidget {
  @override
  _CollectInfoState createState() => _CollectInfoState();
}

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
final userKey = user.uid;
final db = Firestore.instance;

class _CollectInfoState extends State<CollectInfo> {
  String dept, _dept, year;
  Map<String, dynamic> userData;

  TextEditingController nameController = new TextEditingController();
  TextEditingController rollController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  final _userType = ['Student', 'Staff'];
  String _defType = 'Student';
  String _text = "";
  var _visible = true;
  var _goVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First things first"),
        backgroundColor: syskol,
      ),
      body: Center(
        heightFactor: 1,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Let's know about you.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: syskol,
                      fontSize: 25,
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) return ("Please enter a valid name");
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "What's your name?",
                        hintText: "e.g. Abraham Rufus",
                        border: OutlineInputBorder(
                          gapPadding: 1,
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "You are a",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton<String>(
                          value: _defType,
                          items: _userType.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              _defType = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    validator: (input) {
                      if (year == null || dept == null || input.length != 12)
                        return ("Check your enrollment number");
                    },
                    controller: rollController,
                    decoration: InputDecoration(
                      labelText: " What's your enrollment number?",
                      hintText: "e.g. 311117205003",
                      border: OutlineInputBorder(
                        gapPadding: 1,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onTap: () {
                      _selectDate(context);
                    },
                    controller: dobController,
                    decoration: InputDecoration(
                      labelText: "When were you born?",
                      hintText: "DD-MM-YYYY",
                      border: OutlineInputBorder(
                        gapPadding: 1,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: _evalFields(rollController.text),
                  ),
                  SizedBox(
                    height: 10,
                  ),
//                  CircularProgressIndicator(
//                    value: 1,
//                  ),
                  Text(
                    _text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: syskol,
                      fontSize: 25,
                      fontFamily: 'Segoe',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: _goVisible,
                    child: RaisedButton(
                      child: Text(
                        "LET'S GO",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      elevation: 5,
                      color: syskol,
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            findBatch(rollController.text);
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              userData = {
                "name": nameController.text,
                "userType": _defType,
                "rollNo": rollController.text,
                "dob": dobController.text,
                "dept": _dept,
                "batch": year,
              };
              uploadData(userData);
            } else {
              setState(() {
                _text = '';
              });
            }
          },
        ),
      ),
    );
  }

  Text _evalFields(String input) {
    if (!(dept == null || year == null || input.length != 12))
      return Text(
        "Department of $dept\nBatch of $year",
        style: TextStyle(
          color: Colors.purple,
          fontSize: 15,
          fontFamily: 'Segoe',
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
        context: context,
        initialDate: new DateTime(2000),
        firstDate: new DateTime(1990),
        lastDate: new DateTime.now());
    dobController.text = selected.toString().substring(0, 10);
  }

  void findBatch(String input) {
    if (input.length != 12)
      debugPrint('Length of roll != 12');
    else if (input.substring(0, 4) != "3111")
      debugPrint('College code != 3111 | Warn: Anti-Licetian!');
    else {
      year = '20' + input.substring(4, 6);
      year = (int.parse(year) + 4).toString();
      switch (input.substring(6, 9)) {
        case '205':
          {
            dept = 'Information Technology';
            _dept = 'IT';
          }
          break;
        case '105':
          {
            dept = 'Electrical and Electronics Engineering';
            _dept = 'EEE';
          }
          break;
        case '106':
          {
            dept = 'Electronics and Communication Engineering';
            _dept = 'ECE';
          }
          break;
        case '104':
          {
            dept = 'Computer Science and Engineering';
            _dept = 'CSE';
          }
          break;
        case '114':
          {
            dept = 'Mechanical Engineering';
            _dept = 'Mech';
          }
          break;
        default:
          {
            dept = null;
            debugPrint("dept nullified!");
          }
      }
    }
  }

  Future<Widget> uploadData(userData) async {
    await db
        .collection('users')
        .document('$userKey')
        .setData(userData)
        .then((bool) {
      setState(() {
        _text = "And we're all good to go!";
        _visible = false;
        _goVisible = true;
      });
    });
  }
}