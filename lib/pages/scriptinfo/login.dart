import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_athena/pages/home.dart';
import 'package:flutter_athena/pages/signup.dart';

MaterialColor syskol = Colors.deepPurple;
MaterialColor buttonkol = Colors.deepPurple;
//final _userType = ['Student', 'Staff', 'Pilot'];
//String _defType = 'Student';
//String _loginInputType = 'Enrollment Number';
GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
FirebaseUser user;

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      alignment: Alignment(-1, -1),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            "Loyola-ICAM College of Engineering and Technology",
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Segoe',
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ImageWidget(),
          LoginInfo(),
          Text(
            "Product of Athena PnC Labs. Consumer Software.\n\u00A9 2019 Athena Corporation.",
            style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 10.0,
                fontWeight: FontWeight.w200,
                color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
//    else{
//      var info = getLoginDataPref();
//      _LoginInfo().login(context, info[0], info[1]);
//    }
  }

  String sayHello() {
    return "SSID: LICET-HOSTEL";
  }
}

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage logoAsset2 = AssetImage('images/licetlogo.png');
    Image logoLicetImage = new Image(
      image: logoAsset2,
    );
    return Container(
      child: logoLicetImage,
      width: 180,
      height: 180,
    );
  }
}

class LoginInfo extends StatefulWidget {
  String user, pass;

  @override
  State<StatefulWidget> createState() => _LoginInfo();
}

class _LoginInfo extends State<LoginInfo> {
  FocusNode _focusNode = FocusNode();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: (input) {
                  if (!RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(input)) return 'Check your email address';
                },
                onFieldSubmitted: (input) {
                  FocusScope.of(context).requestFocus(_focusNode);
                },
                controller: userController,
                //keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: "Email address",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: "e.g. licet2k10@licet.ac.in",
                    errorStyle: TextStyle(
                      color: Colors.redAccent,
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 1.0,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                focusNode: _focusNode,
                validator: (input) {
                  if (input.length < 8)
                    return 'Password must be minimum of 8 characters';
                },
                controller: passController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                obscureText: true,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 5, right: 5),
                    child: RaisedButton(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Segoe',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      color: Colors.black,
                      splashColor: Colors.grey,
                      elevation: 5.0,
                      onPressed: signUp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 5),
                    child: RaisedButton(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        color: buttonkol,
                        splashColor: Colors.purple,
                        elevation: 5.0,
                        onPressed: () {
                          login(context);
                        }),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context) async {
    _formKey.currentState.validate();
    var dialog = new AlertDialog(
      title: Text("Something isn't right"),
      content: Text(
          "Check your credentials, ensure that you are connected to the internet and try again."),
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
    var dialogVerify = new AlertDialog(
      title: Text("Your email address isn't verified!"),
      content: Text(
          "Check your email and click on the verification link to continue."),
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
        user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userController.text, password: passController.text);
        if (user.isEmailVerified)
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        else
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return dialogVerify;
              });
      }
    } catch (exception) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  void signUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }
}
