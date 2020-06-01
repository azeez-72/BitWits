import 'dart:math';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Reg&Log/New_Class.dart';
import 'package:bitwitsapp/join_class.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:bitwitsapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bitwitsapp/StudentData.dart';
import 'package:bitwitsapp/info.dart';
import 'package:bitwitsapp/constants.dart';

class Details extends StatefulWidget {
  static final String id = 'details';

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  final _formKey = GlobalKey<FormState>();
  final DBRef = FirebaseDatabase.instance.reference();

  
  String branchSelectedValue;
  String batchSelectedValue;
  String yearSelectedValue;

  @override
  void initState() {
    super.initState();

    registeredCurrentUser();
  }

  void registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
  }

  /*

  void registeredCurrentUser() async{
    try {
      final regUser = await _auth.currentUser();
      if(regUser != null) {
        registeredUser = regUser;
        print(registeredUser.email);
      } else Navigator.pushNamed(context, SignUp.id);
    } catch(e){
      print(e);
    }
  }*/

  String rollnumber;
  String froll;
  static int toggleIndex = 1;

  final ClassRef = FirebaseDatabase.instance.reference().child("Classroom");
  String data = "Hello!";
  int a;

  String getCode(String b,String r){
    Info.assign();
    String i;
    if(yearSelectedValue == "1") i = "b$b";
    else i = Info.sform[branchSelectedValue];
    String m = Random().nextInt(9999).toString();
    String l = r.substring(r.length - 2);

    return "$i$m$l";
  }

  static String code;

  String enteredCode;
  String error = ' ';
  TextEditingController code_controller;

  createAlertDialog(BuildContext context){
    return (yearSelectedValue == "1" && branchSelectedValue != null) ? showDialog(context: context,builder: (context){
      return Consumer<StudentData>(
        builder: (context , studentsData , child){
          return AlertDialog(
          title: Text(
            'Select your batch',
            style: TextStyle(
              color: mainColor,
              fontSize: 16,
            ),
          ),
          content: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: textInputDecoration("Batch"),
                isEmpty: batchSelectedValue == '',
                child: DropDown(value: batchSelectedValue,
                list: Info.batches.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    );
                  }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                  batchSelectedValue = newValue;
                  state.didChange(newValue);
                  });
                },),
              );
            },
          ),
          actions: <Widget>[
             FlatButton(
              onPressed: (){
                Navigator.pop(context);
              }, child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.grey),
                ),
            ),
            FlatButton(
              onPressed: (){
                  //save data to DB of CR FY's
                  studentsData.addData(currentUser.email,"Batch",batchSelectedValue); //save batch
                  try {
                    DBRef.child("Students").child("Year ${studentsData.data[currentUser.email]["Year"]}").child(studentsData.data[currentUser.email]["Roll Number"]).set({
                      "name": studentsData.data[currentUser.email]["Name"],
                      "email": currentUser.email,
                      "branch": studentsData.data[currentUser.email]["Branch"],
                      "batch": studentsData.data[currentUser.email]["Batch"]
                    });
                    DBRef.child("Classroom").child("Year ${studentsData.data[currentUser.email]["Year"]}").child("Batch ${studentsData.data[currentUser.email]["Batch"]}").set({
                      "CR Roll number": studentsData.data[currentUser.email]["Batch"],
                      "Class code": getCode(studentsData.data[currentUser.email]["Batch"], studentsData.data[currentUser.email]["Batch"])
                    });
                    code = getCode(studentsData.data[currentUser.email]["Batch"], studentsData.data[currentUser.email]["Batch"]);
                    Navigator.pushNamed(context,New_Class.id);
                  } catch(e){
                      print(e);
                  }
                }, child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
        }
      );
    }) : null;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StudentData>(
      builder: (context , studentsData , child){
        return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Builder(
          builder: (context) =>
           Container(
            width: double.infinity,
            decoration: BGDecoration,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Enter College Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Expanded(
                    child: Container(
                      decoration: textCardDecoration,
                      child: Padding(
                        padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: TextFields("Roll Number", TextInputType.number, null,
                              (String value){
                                if(value.isEmpty){
                                  return "Enter roll number";
                                }
                                return null;
                              },
                              (String value) {
                                studentsData.addData(currentUser.email, "Roll Number", value);
                              }),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: textInputDecoration("Branch"),
                                  isEmpty: branchSelectedValue == '', //
                                  child: DropDown(value: branchSelectedValue,
                                  list: Info.branches.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                      );
                                    }).toList(),
                                  onChanged: (String newValue) {
                                      setState(() {
                                        branchSelectedValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return InputDecorator(
                                        decoration: textInputDecoration("Year"),
                                        isEmpty: yearSelectedValue == '',
                                        child: DropDown(value: yearSelectedValue,
                                          list: Info.years.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                              );
                                            }).toList(),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              yearSelectedValue = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ToggleCR(toggleIndex: toggleIndex,
                                onToggle: (index) {
                                  setState(() {
                                    toggleIndex = index;
                                  });
                                },),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            SizedBox(height: 10,),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: Builder(
                                        builder: (context) =>
                                          button('Join class', 16, () {
                                            if(_formKey.currentState.validate()){
                                              _formKey.currentState.save();
                                              studentsData.addData(currentUser.email, "Year", yearSelectedValue);
                                              studentsData.addData(currentUser.email, "Branch", branchSelectedValue);
                                            }
                                            //Emphasis
                                            if(branchSelectedValue == null)
                                            Scaffold.of(context).showSnackBar(
                                               SnackBar(
                                                content: errorMessage('Please select branch'),
                                                duration: Duration(milliseconds: 2000),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            if(yearSelectedValue == null)
                                            Scaffold.of(context).showSnackBar(
                                               SnackBar(
                                                content: errorMessage('Please select year'),
                                                duration: Duration(milliseconds: 2000),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          Navigator.pushNamed(context, JoinClass.id);
                                        }),
                                      ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Builder(
                                        builder: (context) =>
                                          button('Create class', 16, () {
                                            if(_formKey.currentState.validate()){
                                              _formKey.currentState.save();
                                              studentsData.addData(currentUser.email, "Year", yearSelectedValue); //save year
                                              studentsData.addData(currentUser.email, "Branch", branchSelectedValue); //save branch
                                            }
                                          //Emphasis
                                          if(branchSelectedValue == null)
                                            Scaffold.of(context).showSnackBar(
                                               SnackBar(
                                                content: errorMessage('Please select branch'),
                                                duration: Duration(milliseconds: 2000),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            if(yearSelectedValue == null)
                                            Scaffold.of(context).showSnackBar(
                                               SnackBar(
                                                content: errorMessage('Please select year'),
                                                duration: Duration(milliseconds: 2000),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            if(yearSelectedValue == "1") 
                                              createAlertDialog(context);
                                            else {
                                              //save seniors data
                                              DBRef.child("Students").child("Year $yearSelectedValue").child(studentsData.data[currentUser.email]["Batch"]).set({
                                                "name": studentsData.data[currentUser.email]["Name"],
                                                "email": currentUser.email,
                                                "branch": studentsData.data[currentUser.email]["Branch"],
                                              });
                                              DBRef.child("Classroom").child("Year $yearSelectedValue").child(branchSelectedValue).set({
                                                "CR Roll number": studentsData.data[currentUser.email]["Batch"],
                                                "Class code": getCode(null, studentsData.data[currentUser.email]["Batch"])
                                              });
                                              code =  getCode(null, studentsData.data[currentUser.email]["Batch"]);
                                              Navigator.pushNamed(context, New_Class.id);
                                            }
                                        }),
                                      ),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      }
    );
  }
}
