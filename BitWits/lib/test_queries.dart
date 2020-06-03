import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  static String id = "test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final ClassRef = FirebaseDatabase.instance.reference();
  String data = "hello";
  List<String> names;

  @override
  void initState(){
    super.initState();

    writeQuery();
  }

  Future<void> writeQuery() async {
    //write your  queries
    await ClassRef.child("Students").child("Year 2").once().then((DataSnapshot snapshot){
      print(snapshot.value);
      setState(() {
        data = snapshot.value;
        var re = RegExp('(?<=name:)(.*?)(?=,)');
        var match = re.allMatches(data);
        List<String> names = new List<String>();
        match.forEach((match) {
          names.add(data.substring(match.start,match.end).trim());
        });
        print(names);
      });
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}