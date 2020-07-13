import 'package:bitwitsapp/Main_Screen/menu_options/menu_items/Student_details.dart';
import 'package:bitwitsapp/Main_Screen/menu_options/menu_items/Students_list.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bitwitsapp/Main_Screen/menu_options/options.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import './menu_items/Resources.dart';


class MenuList extends StatelessWidget {
  static final String id = 'menu_list';
  final _auth = FirebaseAuth.instance;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Padding(
        padding: EdgeInsets.only(top: 20,right: 10,left: 10),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text('More options',textAlign: TextAlign.center,style: TextStyle(color: mainColor,fontWeight: FontWeight.w500,fontSize: 28),),
            SizedBox(height: 30),
            OptionListTile(
              icon: SvgPicture.asset('svgs/id_icon_bitwits.svg',color: mainColor),
              title: 'Student Details',
              subtitle: 'View your account information',
              onTap: () => Navigator.pushNamed(context, Details.id),
            ),
            OptionListTile(
              icon: Icon(Icons.people,color: mainColor,size: 32,),
              title: 'Classroom',
              subtitle: 'Classmates',
              onTap: () => Navigator.pushNamed(context, Students_list.id),
            ),

            
            /* OptionListTile(
              icon: Icon(Icons.assignment,color: mainColor,size: 32,),
              title: 'Previous Years Papers',
              subtitle: 'Question Papers',
              onTap: () => {_launchURL("https://drive.google.com/open?id=0Bx7IrwIRxV6xOHNqR3Rlc1EwR2M")},
            ), */

            // OptionListTile(
            //   icon: SvgPicture.asset('svgs/stack_of_books.svg',color: Colors.grey),
            //   title: 'Books',
            //   subtitle: 'Buy or sell books',
            //   onTap: () => (){
                
            //   },
            // ),
            OptionListTile(
              icon: Icon(Icons.phone,color: mainColor,size: 32,),
              title: 'Contact us',
              subtitle: 'Email us at appbitwits@gmail.com',
              onTap: () => {_launchURL('mailto: appbitwits@gmail.com')}
            ),

            OptionListTile(
              icon: Icon(Icons.library_books,color: mainColor,size: 32,),
              title: 'Resources',
              subtitle: 'Question Papers And Reference Books',
              onTap: () => Navigator.pushNamed(context, Resources_res.id),
            ),

            SizedBox(height: 10),
            FlatButton.icon(
              onPressed: (){
                try{
                  _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context, SignIn.id, (route) => false);
                } catch(e){
                  String error = getError(e);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: errorMessage(error),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3,),
                    ),
                  );
                }
              }, 
              icon: Icon(Icons.exit_to_app,color: Colors.red[700],), 
              label: Text('Sign out',textAlign: TextAlign.start,style: TextStyle(color: Colors.red[700]),),
            ),
          ],
        ),
      )
    );
  }
}