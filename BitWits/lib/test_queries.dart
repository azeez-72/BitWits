import 'package:bitwitsapp/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  static String id = "test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final ClassRef = FirebaseDatabase.instance.reference().child("Classroom");
  String data = "hello";

  @override
  void initState(){
    super.initState();

    writeQuery();
  }

  Future<void> writeQuery() async {
    //write your  queries
    await ClassRef.child("Year 1").once().then((DataSnapshot snapshot){
      print(snapshot.value);
      setState(() {
        data = snapshot.value;
        });
      }).catchError((error){
      print(error);
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(60),
            child: Column(children: <Widget>[
              // RaisedButton(
              //   onPressed: () {
              //     writeQuery();
              //   },
              //   child: Text('Get Data'),
              // ),
              SizedBox(height: 32,),
              Text(data == null ? "Error!" : data,
                style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold)
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }
}