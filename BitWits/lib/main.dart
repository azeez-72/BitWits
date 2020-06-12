import 'package:bitwitsapp/BottomNavigation.dart';
import 'package:bitwitsapp/Navigate.dart';
import 'package:bitwitsapp/Reg&Log/CodeDisplay.dart';
import 'package:bitwitsapp/create_class.dart';
import 'package:bitwitsapp/join_class.dart';
import 'package:bitwitsapp/resetpass.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/Reg&Log/SignUp.dart';
import 'package:bitwitsapp/Reg&Log/Details.dart';
import 'package:provider/provider.dart';
import 'package:bitwitsapp/loading.dart';
import 'test_queries.dart';
import 'package:bitwitsapp/StudentData.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentData(),),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged,builder: (context,userSnapShot){
            if(userSnapShot.connectionState == ConnectionState.waiting) return LoadingScreen();
            if(userSnapShot.hasData) return BottomNavigation();
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
          Details.id: (context) => Details(),
          SignIn.id: (context) => SignIn(),
          CodeDisplay.id: (context) => CodeDisplay(),
        },
      ),
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