import 'package:bitwitsapp/Details.dart';
import 'package:bitwitsapp/main.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'Assignments.dart';
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
  String femail;
  String fpassword;
  TextEditingController emailCon;
  TextEditingController passCon;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String error = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(70),bottomRight: Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 70,left: 20,right: 20),
                      child: Column(
                        children: <Widget>[
                          TextFields("Email",TextInputType.emailAddress,Icon(Icons.email),emailCon,(value){
                            email = value;
                          }),
                          SizedBox(height: 16,),
                          TextFields("Password",TextInputType.text,Icon(Icons.lock_outline),passCon,(value){
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
                          Builder(
                            builder: (context) =>
                            button(
                                'Login',18,
                                () async{
                                  if(email == null || password == null)
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: errorMessage('Please fill in the details'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2,),
                                      ),
                                    );
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    final loginUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                                    if(loginUser != null){
                                      Navigator.pushNamed(context, Assignments.id);
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    String exception = e.toString();
                                    int i1 = exception.indexOf(',');
                                    int i2 = exception.indexOf(', null');
                                    error = exception.substring(i1+2,i2);
                                    print(error);
                                  }
                                }
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              child: Text(
                                error,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            thickness: 1,
                            height: 20,
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
                                SizedBox(height: 7,),
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
                                appName(
                                  fontSize: 18,
                                  color: Colors.grey[500],
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
      ),
    );
  }
}



