import 'package:bitwitsapp/Classroom/Choose.dart';
import 'package:bitwitsapp/Intermediate.dart';
import 'package:bitwitsapp/Main_Screen/Dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';

class CodeDisplay extends StatefulWidget {
  static String id = "new_class";

  @override
  _CodeDisplayState createState() => _CodeDisplayState();
}

class _CodeDisplayState extends State<CodeDisplay> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String code, img;

  @override
  void initState() {
    super.initState();

    getCode();
  }

  Future<void> registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      title: Text('Are you sure?',style: TextStyle(color: mainColor,fontWeight: FontWeight.bold),),
      content: Text('You wanna delete this class?',),
      actions: [
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('NO'),),
        FlatButton(onPressed: () async => await deleteClass(), child: Text('DELETE',style: TextStyle(color: Colors.red[700]),))
      ],
    );

    showDialog(context: context,builder: (context) => alert);
  }

  Future<void> getCode() async {
    await registeredCurrentUser();
    await Firestore.instance
        .collection("Status")
        .document(currentUser.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        code = snapshot.data["Current class code"];
      });
    });
  }

  Future<void> deleteClass() async {
    await Firestore.instance.collection('Classrooms/$code/Students').getDocuments().then(
      (snapshot){
        for(DocumentSnapshot doc in snapshot.documents){
            doc.reference.delete();
          }
        });
    await Firestore.instance
      .collection("Status")
      .document(currentUser.email)
      .updateData({"Current class code": "NA"});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 40),
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
                  Image.asset(
                    "images/room.png",
                    height: size.height * 0.31,
                  ),
                  // SvgPicture.asset('svgs/class.svg',height: size.height*0.31),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text('Your classroom code is:',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                        SizedBox(height: 15),
                        Text(code == null ? "Loading..." : code,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'You can view the code later',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        button('Proceed to classroom', 18, () {
                          Navigator.popAndPushNamed(
                              context, Intermediate.id);
                        }),
                        SizedBox(height: 15),
                        FlatButton.icon(
                          onPressed: () async {

                            
                            await showAlertDialog(context);
                            Navigator.pushNamed(context, Navigate.id);
                          }, 
                          icon: Icon(Icons.delete,color: Colors.red,), 
                          label: Text("Delete class",style: TextStyle(color: Colors.red),))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
