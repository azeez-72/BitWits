import 'package:bitwitsapp/Main_Screen/Dashboard_screen.dart';
import 'package:bitwitsapp/Classroom/Choose.dart';
import 'package:bitwitsapp/Classroom/CodeDisplay.dart';
import 'package:bitwitsapp/Classroom/create_class.dart';
import 'package:bitwitsapp/Classroom/join_class.dart';
import 'package:bitwitsapp/Reg&Log/resetpass.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/Reg&Log/SignUp.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'test_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, userSnapShot) {
            if (userSnapShot.connectionState == ConnectionState.waiting)
              return LoadingScreen();
            if (userSnapShot.hasData) return BottomNavigation();
            return SignUp();
          }),
      routes: {
        BottomNavigation.id: (context) => BottomNavigation(),
        ResetPassword.id: (context) => ResetPassword(),
        Navigate.id: (context) => Navigate(),
        CreateClass.id: (context) => CreateClass(),
        JoinClass.id: (context) => JoinClass(),
        Test.id: (context) => Test(),
        SignUp.id: (context) => SignUp(),
        SignIn.id: (context) => SignIn(),
        CodeDisplay.id: (context) => CodeDisplay(),
      },
    );
  }
}

//TODO: add ic_launcher for hdpi
