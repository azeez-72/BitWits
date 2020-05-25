import 'dart:math';
import 'package:bitwitsapp/Details.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'package:flutter_svg/flutter_svg.dart';

String s = SignUp.rollno.toString();
var lastTwoDigits = s.substring(s.length - 2);


// ignore: camel_case_types
class New_Class extends StatefulWidget {
  static String id = "new_class";

  @override
  _New_ClassState createState() => _New_ClassState();
}

// ignore: camel_case_types
class _New_ClassState extends State<New_Class> {
  // ignore: non_constant_identifier_names
  int CodeNumber = Random().nextInt(9999);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                        "Classroom created!",
                        style: TextStyle(
                        color: mainColor,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                    ),
              ),
              SizedBox(
                height: 149.526,
                width: 233.635,
                child: SvgPicture.asset('svgs/class.svg'),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Column(children: <Widget>[
                  //branch
                  Text(
                  DetailsState.branchSelectedValue,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  )
              ),
              SizedBox(height: 20,),
              Text(
                'Classroom code is: \n (b2$CodeNumber$lastTwoDigits)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5,),
              Text(
                'You can view the code later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10,),
              button('Proceed to classroom', 18 , (){
                
              }),
                ],),
              ),
            ],
          ),
        ),
      ),
    );
  }
}