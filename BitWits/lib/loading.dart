import 'package:bitwitsapp/constants.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        child: Center(
          child: Text("loading...",style: TextStyle(color: Colors.grey),)
        ),
      ),
    );
  }
}