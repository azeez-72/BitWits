import 'package:bitwitsapp/SignIn.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Assignments extends StatefulWidget {

  static final String id  = 'assignments';

  @override
  _assignmentsState createState() => _assignmentsState();
}

// ignore: camel_case_types
class _assignmentsState extends State<Assignments> {
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
            fontFamily: 'Pacifico',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pushNamed(context, SignIn.id);
          },
        ),
        backgroundColor: mainColor,
      ),
    );
  }
}
