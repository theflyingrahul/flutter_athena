import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_athena/pages/collectuserinfo.dart';
import './scriptinfo/login.dart';

MaterialColor syskol = Colors.deepPurple;

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

class _SignUpState extends State<SignUp> {
  TextEditingController _mailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _pass2Controller = new TextEditingController();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  String mail = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
//    if(!"${widget.email}".toString().isEmpty)
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
        backgroundColor: syskol,
      ),
      body: Center(
        heightFactor: 1,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            child: Form(
              key: _formKey,
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "We need your email to sign up!",
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Segoe',
                        color: syskol,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: TextFormField(
                      controller: _mailController,
                      autofocus: true,
                      validator: (input) {
                        if (!RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input))
                          return 'Enter a valid email address';
                      },
                      onFieldSubmitted: (String value) {
                        setState(() {
                          mail = value;
                          FocusScope.of(context).requestFocus(_focusNode1);
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: "e.g. licet2k10@licet.ac.in",
                        labelText: "Email address",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _passController,
                      focusNode: _focusNode1,
                      validator: (input) {
                        if (input.length < 8)
                          return 'Password should be minimum of 8 characters';
                      },
                      onSaved: (String value) {
                        setState(() {
                          pass = value;
                          FocusScope.of(context).requestFocus(_focusNode2);
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelText: "Password",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: _pass2Controller,
                      focusNode: _focusNode2,
                      validator: (input) {
                        if (input != _passController.text || input.isEmpty)
                          return "Passwords don't match";
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelText: "Confirm Password",
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: signUp,
                    color: syskol,
                    elevation: 5.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    _formKey.currentState.validate();
    var alertDialog = new AlertDialog(
      title: Text("Something isn't right."),
      content: Text("Sign up failed. Please try again later."),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Segoe',
              fontWeight: FontWeight.normal,
            ),
          ),
          elevation: 5.0,
          onPressed: () {
            Navigator.pop(context);
          },
          color: syskol,
          splashColor: Colors.purple,
        ),
      ],
    );
    try {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _mailController.text, password: _pass2Controller.text);
        user.sendEmailVerification();
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CollectInfo()));
      }
    } catch (exception) {
      showDialog(
          context: context,
          builder: (BuildContext buildContext) {
            return alertDialog;
          });
    }
  }
}