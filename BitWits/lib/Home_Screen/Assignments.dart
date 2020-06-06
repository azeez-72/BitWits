import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/constants.dart';

class Assignments extends StatefulWidget {

  static final String id  = 'assignments';

  @override
  _assignmentsState createState() => _assignmentsState();
}

// ignore: camel_case_types
class _assignmentsState extends State<Assignments> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Assignments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            _auth.signOut();
            Navigator.pushNamed(context, SignIn.id);
          },
        ),
        backgroundColor: mainColor,
      ),
    );
  }
}
