import 'package:bitwitsapp/Assignments.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'SignIn.dart';
import 'Details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SignUp.id,
      routes: {
        SignUp.id: (context) => SignUp(),
        Details.id: (context) => Details(),
        SignIn.id: (context) => SignIn(),
        Assignments.id: (context) => Assignments(),
      },
    );
  }
}

// ignore: camel_case_types
class appName extends StatelessWidget {
  final double fontSize;
  final Color color;

  appName({this.fontSize,this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      'Clarsi',
      style: TextStyle(
        fontFamily: 'Pacifico',
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

//TODO: add ic_launcher for hdpi