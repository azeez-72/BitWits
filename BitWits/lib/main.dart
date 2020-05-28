import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/Reg&Log/SignUp.dart';
import 'package:bitwitsapp/Reg&Log/Details.dart';

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

class errorMessage extends StatelessWidget {

  final String errorText;
  
  errorMessage(this.errorText);

  @override
  Widget build(BuildContext context) {
    return Row(
       children: [
         Icon(Icons.error,),
         SizedBox(width: 10,),
         Expanded(
          child: Text(
           errorText,
           style: TextStyle(
             fontSize: 14,
             color: Colors.white,
             ),
           ),
         ),
       ]
    );
  }
}
//TODO: add ic_launcher for hdpi