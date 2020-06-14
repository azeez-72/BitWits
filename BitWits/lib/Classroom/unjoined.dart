import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Classroom/join_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/Classroom/create_class.dart';

class Unjoined extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 200, left: 25, right: 25),
                child: Column(
                  children: [
                    Text(
                      'You are not in a class!',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Text(
                        "Select one of the following options",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 50),
                      child: Row(children: <Widget>[
                        buttonExp(
                            label: "Join class",
                            onPressed: () {
                              Navigator.pushNamed(context, JoinClass.id);
                            }),
                        SizedBox(
                          width: 15,
                        ),
                        buttonExp(
                            label: "Create class",
                            onPressed: () {
                              Navigator.pushNamed(context, CreateClass.id);
                            }),
                      ]),
                    ),
                    SizedBox(height: 80),
                    FlatButton(
                      onPressed: () {
                        _auth.signOut();
                      },
                      child: Text(
                        "Sign out",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
