import 'package:flutter/material.dart';

class RegisterHeading extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            "Register",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 1,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Get Started",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
