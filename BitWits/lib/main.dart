import 'package:bitwitsapp/Classroom/menu_options/menu_list.dart';
import 'package:bitwitsapp/Intermediate.dart';
import 'package:bitwitsapp/Main_Screen/Dashboard_screen.dart';
import 'package:bitwitsapp/Classroom/Choose.dart';
import 'package:bitwitsapp/Classroom/CodeDisplay.dart';
import 'package:bitwitsapp/Classroom/create_class.dart';
import 'package:bitwitsapp/Classroom/join_class.dart';
import 'package:bitwitsapp/Main_Screen/Students_list.dart';
import 'package:bitwitsapp/Reg&Log/resetpass.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/Reg&Log/SignUp.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'package:provider/provider.dart';
import 'Classroom/Data.dart';
import 'test_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
          create: (context) => Data(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: MenuList.id,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, userSnapShot) {
              if (userSnapShot.connectionState == ConnectionState.waiting)
                return LoadingScreen();
              if (userSnapShot.hasData) return Intermediate();
              return SignUp();
            }),
        routes: {
          Students_list.id: (context) => Students_list(),
          MenuList.id: (context) => MenuList(),
          Dashboard.id: (context) => Dashboard(),
          ResetPassword.id: (context) => ResetPassword(),
          Navigate.id: (context) => Navigate(),
          CreateClass.id: (context) => CreateClass(),
          JoinClass.id: (context) => JoinClass(),
          Intermediate.id: (context) => Intermediate(),
          Test.id: (context) => Test(),
          SignUp.id: (context) => SignUp(),
          SignIn.id: (context) => SignIn(),
          CodeDisplay.id: (context) => CodeDisplay(),
        },
      ),
    );
  }
}

//TODO: add ic_launcher for hdpi
