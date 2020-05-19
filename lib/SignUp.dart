import 'package:bitwitsapp/SignIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textFields.dart';

class SignUp extends StatefulWidget {

  static final String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              colors: [
                Color(0xFF0B3A70),
                Color(0xFF00498D),
                Color(0xFF0052A2),
              ]
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 14,),
              Text(
                "Clarsi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                        "Register",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Get Started",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7,),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(70),bottomRight: Radius.circular(100)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 65,left: 20,right: 20),
                    child: Column(
                      children: <Widget>[
                        TextFields("Roll number"),
                        SizedBox(height: 16,),
                        TextFields("Email"),
                        SizedBox(height: 16,),
                        TextFields("Password"),
                        SizedBox(height: 24,),
                        button('Register', (){
                              Navigator.pushNamed(context, SignIn.id);
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//0B3A70