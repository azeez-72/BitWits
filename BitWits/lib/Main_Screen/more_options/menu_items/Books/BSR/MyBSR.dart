import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'AddBSR.dart';

class MyBSR extends StatefulWidget {
  @override
  _MyBSRState createState() => _MyBSRState();
}

class _MyBSRState extends State<MyBSR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(Icons.add,color: Colors.white,size: 24,),
        onPressed: () => Navigator.pushNamed(context, AddBSR.id)
      ),
    );
  }
}