import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/create_class.dart';
import 'package:bitwitsapp/join_class.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navigate extends StatelessWidget {
  static final String id = "navigate";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
         body: SafeArea(
           child: Padding(
             padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 5),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.end,
               children: <Widget>[
                 Expanded(
                   child: Container(
                     width: double.infinity,
                     color: Colors.grey[300],
                     child: Center(child: Text("GRAPHICS TBD",style: TextStyle(color: Colors.blueGrey,fontSize: 32),)),
                   ),
                 ),
                 Container(
                   color: Colors.white,
                   padding: EdgeInsets.only(top: 20),
                   child: Row(
                      children: <Widget>[
                        buttonExp(label: "Join class",onPressed: (){
                          Navigator.pushNamed(context,JoinClass.id);
                        }),
                        SizedBox(width: 20,),
                        buttonExp(label: "Create class",onPressed: (){
                          Navigator.pushNamed(context,CreateClass.id);
                        }),
                      ]
                    ),
                  ),
                  SizedBox(height: 5),
                  FlatButton(
                  onPressed: (){
                    _auth.signOut();
                    Navigator.popAndPushNamed(context, SignIn.id);
                  },
                  child: Text("Sign out",style: TextStyle(color: Colors.grey[600],fontSize: 16,decoration: TextDecoration.underline),),
                )
               ],
             ),
           ),
         ),
      ),
    );
  }
}