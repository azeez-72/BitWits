import 'package:bitwitsapp/textFields.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Details_Class/user_college_details.dart';
import 'package:flutter_svg/flutter_svg.dart';

class New_Class extends StatelessWidget {
  static String id = "new_class";

  College_Details college_details;

  New_Class(this.college_details);

  final DBRef = FirebaseDatabase.instance.reference();

  String code(){
    String fcode;
    String year = college_details.year;
    String batch = college_details.batch;
    try{
      DBRef.child("Classroom").child("Year $year").child("Batch $batch").orderByKey().equalTo("Class code").once().then((value){
      fcode = value.toString();
    });
    return fcode;
    } catch(e){
      print(e);
      return "Error";
    }
  }

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
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Text('Your classroom code is:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                    SizedBox(height: 15),
                    Text(
                      code() == null ? "Not available" : code(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20,),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}