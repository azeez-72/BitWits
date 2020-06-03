import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Navigate.dart';
import 'package:bitwitsapp/constants.dart';
import 'package:bitwitsapp/create_class.dart';
import 'package:bitwitsapp/join_class.dart';
import 'Details.dart';
import 'package:bitwitsapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'SignIn.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:bitwitsapp/Headings/RegsiterHeading.dart';
import 'package:bitwitsapp/StudentData.dart';

class SignUp extends StatefulWidget { 
  static final String id = 'sign_up';
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  //shifted rollno from private class to let New_Class access it
  String _email;
  String _password;
  String name;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser loggedInUser;
  bool showSpinner = false;
  String error = " ";

  //   @override
  //   void initState() {
  //     super.initState();
  //     getLoggedInUser();
  //   }

  //   void getLoggedInUser() async{
  //   try{
  //     final user = await _auth.currentUser();
  //     loggedInUser = user;
  //     if(loggedInUser != null) Navigator.pushNamed(context, Assignments.id);
  //   }catch(e){
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentData>(
      builder: (context,studentsData,child){
        return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            width: double.infinity,
            //background decoration
            decoration: BGDecoration,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  appName(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  RegisterHeading(),
                  SizedBox(height: 7),
                  Expanded(
                    child: Container(
                      //main page decoration
                      decoration: textCardDecoration,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFields("Name",TextInputType.text,
                                    Icon(Icons.person),(String value){
                                      //validate
                                      if(value.isEmpty) {
                                        return 'Enter your name';
                                      }
                                      return null;
                                    }, (String value) {
                                      //note
                                      name = value;
                                    }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFields("email",TextInputType.emailAddress,
                                      Icon(Icons.email),(String value){
                                        //validate
                                        if(value.isEmpty) {
                                        return 'Enter your email';
                                      }
                                      return null;
                                      }, (String value) {
                                        _email = value;
                                    }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFields("Password",TextInputType.text,
                                      Icon(Icons.lock_outline),(String value){
                                        //validate
                                        if(value.isEmpty) {
                                        return 'Enter your password';
                                      }
                                      return null;
                                      }, (String value) {
                                        _password = value;
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Builder(
                                builder: (context) =>
                                button('Register',18, () async {
                                  if(_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                  } 
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  try {
                                    final newUser =
                                        await _auth.createUserWithEmailAndPassword(
                                          email: _email, password: _password);
                                    if (newUser != null) {
                                      studentsData.addData(_email, "Name", name); //save name
                                      print(studentsData.data[_email]["Name"]);
                                      Navigator.pushNamed(context, Navigate.id);
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
                                      //emphasis
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: errorMessage(error),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3,),
                                          ),
                                        );
                                  }
                                }),
                              ),
                              SizedBox(height: 24,),
                              Divider(
                                color: Colors.grey[400],
                                thickness: 1,
                                height: 20,
                                indent: 20,
                                endIndent: 20,
                              ),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, SignIn.id);
                                      },
                                      child: Text(
                                        'Already a user?',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

//0B3A70
//||