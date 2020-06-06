import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'info.dart';

class Test extends StatefulWidget {
  static String id = "test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final ClassRef = FirebaseDatabase.instance.reference();
  String data = "hello";
  String year,batch,branch;
  List<String> names;
  String code;

  @override
  void initState(){
    super.initState();

    // writeQuery();
    getDetails();
  }

  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      code = prefs.getString("sql@gmail.com");
      year = code.substring(5,6);
      if(year == "1") batch = code.substring(1,2);
      else {
        Map reversed = Info.getBranch().map((k, v) => MapEntry(v, k));
        String b = code.substring(0,2);
        branch = reversed[b];
      }
    });
  }
  
  Future<void> writeQuery() async {
    //write your  queries
    await ClassRef.child("Students").child("Year 1/Batch 3").once().then((DataSnapshot snapshot){
      data = snapshot.value.toString();
        var re = RegExp('(?<=name:)(.*?)(?=, )');
        Iterable match = re.allMatches(data);
        List<String> names = [];
        match.forEach((match) {
          names.add(data.substring(match.start,match.end).trim());
        });
        print(names);
        // var match = re.allMatches(snapshot.value);
        // print(match.toString());
        // List<String> names = new List<String>();
        // match.forEach((match) {
        //   names.add(snapshot.value.substring(match.start,match.end).trim());
        // });
        // print(names);
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: (Text(year))),
    );
  }
}