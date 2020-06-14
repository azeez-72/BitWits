import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/Utilities/constants.dart';

class Assignments extends StatefulWidget {
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
        backgroundColor: mainColor,
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
