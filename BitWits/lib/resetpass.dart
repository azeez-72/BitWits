import 'package:bitwitsapp/textFields.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'package:flushbar/flushbar.dart';

class ResetPassword extends StatelessWidget {
  static String id = "resetpass";
  final _auth = FirebaseAuth.instance;
  final emailcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 40,left: 20,right: 20),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
                Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 25,color: mainColor,fontWeight: FontWeight.w500,)
                ),
                SizedBox(height: 20),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    'Enter your email address so that we can send you a password reset link',
                    style: TextStyle(color: Colors.grey[800],fontSize: 16,fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 30),
                CodeFields("Email", TextInputType.text, emailcon),
                SizedBox(height: 15,),
                button("Submit", 18, () async{
                  await _auth.sendPasswordResetEmail(email: emailcon.text);
                  Flushbar(
                    messageText: Text("Password reset link has been sent to ${emailcon.text}",
                    style: TextStyle(fontSize: 15,color: Colors.white),),
                    icon: Icon(Icons.info_outline,color: Colors.black,),
                    duration: Duration(seconds: 5),
                    backgroundColor: Colors.yellow[600],
                  )..show(context);
                })
              ], 
            ),
          ),
        ),
      ),
    );
  }
}