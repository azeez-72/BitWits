import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Home_Screen/Students_list.dart';
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
import 'test_queries.dart';
import 'package:bitwitsapp/StudentData.dart';

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
        initialRoute: SignUp.id,
        routes: {
          Students_list.id: (context) => Students_list(),
          ResetPassword.id: (context) => ResetPassword(),
          Navigate.id: (context) => Navigate(),
          CreateClass.id: (context) => CreateClass(),
          JoinClass.id: (context) => JoinClass(),
          Test.id: (context) => Test(),
          SignUp.id: (context) => SignUp(),
          Details.id: (context) => Details(),
          SignIn.id: (context) => SignIn(),
          CodeDisplay.id: (context) => CodeDisplay(),
          Assignments.id: (context) => Assignments(),
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