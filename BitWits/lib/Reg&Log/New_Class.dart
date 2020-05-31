import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Reg&Log/Details.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class New_Class extends StatelessWidget {
  static String id = "new_class";

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
                padding: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 40),
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
                //TODO: fix slow loading
                height: 149.526,
                width: 233.635,
                child: SvgPicture.asset('svgs/class.svg'),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Text('Your classroom code is:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18)),
                    SizedBox(height: 15),
                    Text(
                      DetailsState.code == null ? "NA" : DetailsState.code,
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
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 15,),
                    button('Proceed to classroom', 18 , (){
                      Navigator.pushNamed(context, Assignments.id);
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