import 'package:flutter/material.dart';
import 'textFields.dart';
import 'package:bitwitsapp/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {

  static final String id = 'sign_in';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
              begin: Alignment.topCenter,
              colors: [
                Color(0xFF0B3A70),
                Color(0xFF00498D),
                Color(0xFF0052A2),
              ]
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 1,
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
                    padding: EdgeInsets.only(top: 80,left: 20,right: 20),
                    child: Column(
                      children: <Widget>[
                        TextFields("Email",false,TextInputType.emailAddress,Icon(Icons.email),(value){
                          email = value;
                        }),
                        SizedBox(height: 16,),
                        TextFields("Password",true,TextInputType.text,Icon(Icons.lock_outline),(value){
                          password = value;
                        }),
                        SizedBox(height: 16,),
                        Padding(
                          padding: EdgeInsets.only(left: 190,),
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 16,),
                        button(
                            'Login',
                            () async{
                              final loginUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                              Navigator.pushNamed(context, SignUp.id);
                            }
                        ),
                        SizedBox(height: 10,),
                        Divider(
                          color: Colors.grey[400],
                          thickness: 1,
                          height: 40,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Create a new account?',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 10,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, SignUp.id);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              SizedBox(height: 24,),
                              Text(
                                "Clarsi",
                                style: TextStyle(
                                  fontFamily: 'Pacifico',
                                  fontSize: 18,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

