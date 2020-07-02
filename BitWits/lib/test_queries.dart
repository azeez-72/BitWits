import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test extends StatefulWidget {
  static String id = "test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isValid = false;
  String code = 'cs523243';

  @override
  void initState() {
    super.initState();

    // writeQuery();
    _executeQuery();
    print('hello');
  }

  // Future<void> getDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     code = prefs.getString("sql@gmail.com");
  //     year = code.substring(5, 6);
  //     if (year == "1")
  //       batch = code.substring(1, 2);
  //     else {
  //       Map reversed = Info.getBranch().map((k, v) => MapEntry(v, k));
  //       String b = code.substring(0, 2);
  //       branch = reversed[b];
  //     }
  //   });
  // }

  _executeQuery() {
    //write your  queries
    Firestore.instance.collection('Classrooms').getDocuments()
      .then((snapshot) async {
        var docs = snapshot.documents;
        for(var doc in docs) {
          await Firestore.instance.collection('Classrooms/${doc.documentID}/Assignments').getDocuments()
          .then((snap) {
            snap.documents.forEach((element) {
              if(element.data['G-drive link'] != null) print(doc.documentID);
            });
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Text('Testing!'),
    ));
  }
}