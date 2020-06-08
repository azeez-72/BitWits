import 'package:bitwitsapp/BottomNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bitwitsapp/constants.dart';

class CodeDisplay extends StatefulWidget {
  static String id = "new_class";

  @override
  _CodeDisplayState createState() => _CodeDisplayState();
}

class _CodeDisplayState extends State<CodeDisplay> {

  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String code,img;

  @override
  void initState(){
    super.initState();

    getCode();
  }

  
  Future<void> registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
  }

  Future<void> getCode() async {
    await registeredCurrentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      code = prefs.getString(currentUser.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: SingleChildScrollView(
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
                    fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SvgPicture.asset('svgs/class.svg',width: 270,fit: BoxFit.fitWidth,alignment: Alignment.topCenter,),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Text('Your classroom code is:',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20)),
                      SizedBox(height: 15),
                      Text(code == null ? "Not available" : code,
                      style:TextStyle(fontWeight: FontWeight.bold,fontSize: 30)),
                      SizedBox(height: 15,),
                      Text(
                        'You can view the code later',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 100,),
                        button('Proceed to classroom', 18 , (){
                          Navigator.pushNamed(context, BottomNavigation.id);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}