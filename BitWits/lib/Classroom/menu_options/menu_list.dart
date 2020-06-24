import 'package:bitwitsapp/Main_Screen/Students_list.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'menu_options.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';

class MenuList extends StatelessWidget {
  static final String id = 'menu_list';
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Padding(
        padding: EdgeInsets.only(top: 50,right: 10,left: 10),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text('More options',textAlign: TextAlign.center,style: TextStyle(color: mainColor,fontWeight: FontWeight.w500,fontSize: 28),),
            SizedBox(height: 30),
            OptionListTile(
              icon: SvgPicture.asset('svgs/id_icon_bitwits.svg',color: mainColor),
              title: 'Student Details',
              subtitle: 'Name,roll number,year,batch and branch',
              onTap: (){},
            ),
            OptionListTile(
              icon: Icon(Icons.people,color: mainColor,size: 32,),
              title: 'Classroom',
              subtitle: 'Classmates',
              onTap: (){
                Navigator.pushNamed(context, Students_list.id);
              }
            ),
            OptionListTile(
              icon: Icon(Icons.phone,color: mainColor,size: 32,),
              title: 'Contact us',
              subtitle: 'Email us at appbitwits@gmail.com',
            ),
            SizedBox(height: 40),
            FlatButton.icon(
              onPressed: (){
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context, SignIn.id, (route) => false);
              }, 
              icon: Icon(Icons.exit_to_app,color: Colors.red[700],), 
              label: Text('Sign out',textAlign: TextAlign.start,style: TextStyle(color: Colors.red[700]),),
            ),
            // FlatButton.icon(
            //   onPressed: (){

            //   }, 
            //   icon: Icon(Icons.exit_to_app,color: Colors.red[700],), 
            //   label: Text('Leave class',style: TextStyle(color: Colors.red[700]),),
            // ),
          ],
        ),
      )
    );
  }
}

