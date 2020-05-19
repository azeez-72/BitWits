import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Assignments.dart';
import 'Assignments.dart';
import 'SignIn.dart';
import 'textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {

  static final String id = 'sign_up';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String name;
  String email;
  String password;
  final _auth = FirebaseAuth.instance;

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
                        TextFields("Name",false,TextInputType.text,Icon(Icons.person),(value){
                          name = value;
                        }),
                        SizedBox(height: 16,),
                        TextFields("Email",false,TextInputType.emailAddress,Icon(Icons.email),(value){
                          email = value;
                        }),
                        SizedBox(height: 16,),
                        TextFields("Password",true,TextInputType.text,Icon(Icons.lock_outline),(value){
                          password = value;
                        }),
                        SizedBox(height: 20,),
                        button(
                            'Register',
                                () async{
                              try {
                                final newUser = await _auth
                                    .createUserWithEmailAndPassword(
                                    email: email, password: password);
                                if(newUser != null){
                                  Navigator.pushNamed(context, Assignments.id);
                                }
                              } catch(e){
                                print(e);
                              }
                              Navigator.pushNamed(context, Assignments.id);
                            }
                        ),
                        SizedBox(height: 10,),
                        Divider(
                          color: Colors.grey[400],
                          thickness: 1,
                          height: 30,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Already a user?',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, SignIn.id);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
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