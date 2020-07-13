import 'package:bitwitsapp/exports.dart';
import 'package:bitwitsapp/Reg&Log/SignIn.dart';
import 'package:bitwitsapp/Classroom/create_class.dart';
import 'package:bitwitsapp/Classroom/join_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SvgPicture.asset('svgs/features_clarsi.svg',height: 400,),
                // Expanded(
                //   child: Container(
                //     width: double.infinity,
                //     color: Colors.white,
                //     child: Center(
                //         child: Text(
                //       "Making the college spree easy -Clarsi!",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(color: Color(0xFF2265B3), fontSize: 32,fontWeight: FontWeight.bold,fontFamily: 'Pacifico'),
                //     )),
                //   ),
                // ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 20),
                  child: Row(children: <Widget>[
                    buttonExp(
                        label: "Join class",
                        onPressed: () {
                          Navigator.pushNamed(context, JoinClass.id);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    buttonExp(
                        label: "Create class",
                        onPressed: () {
                          Navigator.pushNamed(context, CreateClass.id);
                        }),
                  ]),
                ),
                SizedBox(height: 5),
                FlatButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, SignIn.id, (route) => false);
                  },
                  child: Text(
                    "Sign out",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
