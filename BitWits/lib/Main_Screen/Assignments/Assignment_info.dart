import 'package:flutter/material.dart';


class AssignmentsInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: Text(
              "Assignments",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2265B3)),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15.0),
            child: Text(
              "Having trouble remembering pending assignments? Not any more!!",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15.0),
            child: Text(
              "Click on the name of assignment to read description and download PDF.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}