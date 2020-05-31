import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/material.dart';

class JoinClass extends StatefulWidget {
  static String id = "join_class";

  @override
  _JoinClassState createState() => _JoinClassState();
}

class _JoinClassState extends State<JoinClass> {
  final mycon = TextEditingController();
  int a;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 40,left: 20,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget> [
              Text(
                'Enter code to join a class',
                style: TextStyle(fontSize: 24,color: mainColor),
              ),
              SizedBox(height: 50),
              CodeFields('Code', TextInputType.text, mycon),
              SizedBox(height: 20),
              button('Join', 18, (){
                String enteredCode = mycon.text;
                print(enteredCode);
                a = int.parse(enteredCode.substring(1,2));
              })
            ]
          ),
        ),
      ),
    );
  }
}