import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/SignUp.dart';

String s = SignUp.rollno.toString();
var lastTwoDigits = s.substring(s.length - 2);

class New_Class extends StatefulWidget {
  @override
  _New_ClassState createState() => _New_ClassState();
}

class _New_ClassState extends State<New_Class> {
  int codeNumber = Random().nextInt(9999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'New Classroom'
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
              ],
            ),
            Text(
              'Your batch is: 2 / Your branch is: x',

            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton(
                elevation: 5.0,
                child: Text(
                  'Generate classroom code',

                ),
                onPressed: (){

                },
              ),
            ),
            Text(
              'Classroom code is: \n CODE (b2$codeNumber$lastTwoDigits)',
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RaisedButton(
                elevation: 5.0,
                child: Text(
                  'Proceed to classroom',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


