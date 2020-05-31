import 'package:flutter/material.dart';

class LoginHeading extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              letterSpacing: 1,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome back",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}