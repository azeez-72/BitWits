import 'package:flutter/material.dart';
import 'textFields.dart';

class test_field extends StatefulWidget {
  static String id = "test_field";

  @override
  _test_fieldState createState() => _test_fieldState();
}

class _test_fieldState extends State<test_field> {
  final mycon = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CodeFields('Code',TextInputType.text,mycon),
              SizedBox(height: 10),
              RaisedButton(onPressed: (){
                print(mycon.text);
              },child: Text("Press"),
              )
            ],
          ),
        ),
      ),
    );
  }
}