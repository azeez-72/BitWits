import 'package:bitwitsapp/Assignments.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'SignIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SignUp.id,
      routes: {
        SignUp.id: (context) => SignUp(),
        SignIn.id: (context) => SignIn(),
        Assignments.id: (context) => Assignments(),
      },
    );
  }
}
