import 'package:bitwitsapp/constants.dart';
import 'package:bitwitsapp/main.dart';
import 'package:bitwitsapp/resetpass.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/textFields.dart';
import 'SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/Headings/LoginHeading.dart';

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
  final _formKey = GlobalKey<FormState>();
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
          decoration: BGDecoration,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                LoginHeading(),
                Expanded(
                  child: Container(
                    decoration: textCardDecoration,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50,left: 20,right: 20),
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFields("Email",TextInputType.emailAddress,Icon(Icons.email),(String value){
                                if(value.isEmpty){
                                  return "Enter your email";
                                }
                                return null;
                              },(String value){
                                email = value;
                              }),
                              SizedBox(height: 16,),
                              TextFields("Password",TextInputType.text,Icon(Icons.lock_outline),(String value){
                                if(value.isEmpty){
                                  return "Enter your password";
                                }
                                return null;
                              },(String value){
                                password = value;
                              }),
                                ]
                              ),
                            ),
                            SizedBox(height: 16,),
                            Padding(
                              padding: EdgeInsets.only(left: 190,),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, ResetPassword.id);
                                },
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16,),
                            Builder(
                              builder: (context) =>
                              button(
                                  'Login',18,
                                  () async{
                                    if(_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
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
                                      error = getError(e);
                                      print(error);
                                      Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: errorMessage(error),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 3,),
                                        ),
                                      );
                                    }
                                  }
                              ),
                            ),
                            SizedBox(height: 40),
                            Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                              height: 30,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushNamed(context, SignUp.id);
                                    },
                                    child: Text(
                                      'Create a new account?',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
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
                                  SizedBox(height: 16,),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



