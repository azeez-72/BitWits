import 'dart:collection';
import 'dart:math';
import 'package:bitwitsapp/Details_Class/user_details.dart';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Reg&Log/New_Class.dart';
import 'package:bitwitsapp/Reg&Log/SignUp.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:bitwitsapp/main.dart';
import 'package:bitwitsapp/Details_Class/user_college_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Details extends StatefulWidget {
  static final String id = 'details';

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser registeredUser;
  final _formKey = GlobalKey<FormState>();
  College_Details college_details = College_Details();
  User_Details user_details;
  final DBRef = FirebaseDatabase.instance.reference();

 /* @override
  void initState() {
    super.initState();
    
    registeredCurrentUser();
  }

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
  String branch;
  static int toggleIndex = 1;

  var _branches = [
    "Computer",
    "Information Tecnology",
    "EXTC",
    "Electronics",
    "Electrical",
    "Mechanical",
    "Civil",
    "Production",
    "Textile",
  ];

  Map<String,String> sform = HashMap();
  
  void assign(){

    sform[_branches[0]] = "cs";
    sform[_branches[1]] = "it";
    sform[_branches[2]] = "tc";
    sform[_branches[3]] = "es";
    sform[_branches[4]] = "el";
    sform[_branches[5]] = "me";
    sform[_branches[6]] = "cv";
    sform[_branches[7]] = "pr";
    sform[_branches[8]] = "tx";
 }

  var _batches = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
  ];

  var _years = [
    "1",
    "2",
    "3",
    "4",
  ];

  bool codeValidate(String enteredCode){
    bool codeValid;
    //retrieve code from DB
    //if entered code is equal to retrieved code then codeValid is true else false
    return codeValid;
  }

  String getCode(String b,String r){
    assign();
    String i;
    if(yearSelectedValue == "1") i = "b$b";
    else i = sform[branchSelectedValue];
    String m = Random().nextInt(9999).toString();
    String l = r.substring(r.length - 2);

    return "$i$m$l";
  }

  createAlertDialog(BuildContext context){
    return (yearSelectedValue == "1" && (rollnumber != null || branchSelectedValue != null)) ? showDialog(context: context,builder: (context){
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
              decoration: InputDecoration(
                  labelText: 'Batch',
                  errorStyle: TextStyle(
                      color: Colors.redAccent, fontSize: 16.0),
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(5.0))),
              isEmpty: batchSelectedValue == '',
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: batchSelectedValue,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      batchSelectedValue = newValue;
                      state.didChange(newValue);
                    });
                  },
                  items: _batches.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
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
                college_details.batch = batchSelectedValue;
                try {
                  DBRef.child("Students").child("Year $yearSelectedValue").child(college_details.roll).set({
                    "name": SignUpState.fname,
                    "email": SignUpState.femail,
                    "branch": college_details.branch,
                    "batch": college_details.batch
                  });
                  String batch = college_details.batch;
                  DBRef.child("Classroom").child("Year $yearSelectedValue").child("Batch $batch").set({
                    "CR Roll number": college_details.roll,
                    "Class code": getCode(college_details.batch, college_details.roll)
                  });
                  Navigator.push(context,MaterialPageRoute(builder: (context) => New_Class(college_details)));
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
    }) : null;
  }

  static String branchSelectedValue;
  static String batchSelectedValue;
  static String yearSelectedValue;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Builder(
        builder: (context) =>
         Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color(0xFF0B3A70),
              Color(0xFF00498D),
              Color(0xFF0052A2),
            ]),
          ),
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          bottomRight: Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: TextFields("Roll Number", TextInputType.number, null,(String value){
                              if(value.isEmpty){
                                return "Enter roll number";
                              }
                              return null;
                            },
                            (String value) {
                              college_details.roll = value;
                            }),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: 'Branch', //
                                    errorStyle: TextStyle(
                                        color: Colors.redAccent, fontSize: 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                isEmpty: branchSelectedValue == '', //
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: branchSelectedValue,
                                    isDense: true,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        branchSelectedValue = newValue;
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: _branches.map((String value) { //
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
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
                                      decoration: InputDecoration(
                                          labelText: 'Year',
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent, fontSize: 16.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0))),
                                      isEmpty: yearSelectedValue == '',
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: yearSelectedValue,
                                          isDense: true,
                                          onChanged: (String newValue) {
                                            setState(() {
                                              yearSelectedValue = newValue;
                                              state.didChange(newValue);
                                            });
                                          },
                                          items: _years.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(children: <Widget>[
                                  Text(
                                    'Are you a CR?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15, bottom: 0),
                                    child: ToggleSwitch(
                                        minWidth: 50.0,
                                        cornerRadius: 5,
                                        initialLabelIndex: toggleIndex,
                                        activeBgColor: mainColor,
                                        activeTextColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveTextColor: Colors.white,
                                        labels: ['YES', 'NO'],
                                        onToggle: (index) {
                                          setState(() {
                                            toggleIndex = index;
                                          });
                                        }),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]),
                              ),
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
                                        button('Join classroom', 16, () {
                                          if(_formKey.currentState.validate()){
                                            _formKey.currentState.save();
                                            college_details.year = yearSelectedValue;
                                            college_details.branch = branchSelectedValue;
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
                                        createAlertDialog(context);
                                      }),
                                    ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Builder(
                                      builder: (context) =>
                                        button('Create classroom', 16, () {
                                          if(_formKey.currentState.validate()){
                                            _formKey.currentState.save();
                                            college_details.year = yearSelectedValue;
                                            college_details.branch = branchSelectedValue;
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
                                            DBRef.child("Students").child("Year $yearSelectedValue").child(college_details.roll).set({
                                              "name": SignUpState.fname,
                                              "email": SignUpState.femail,
                                              "branch": college_details.branch,
                                            });
                                            DBRef.child("Classroom").child("Year $yearSelectedValue").child(branchSelectedValue).set({
                                              "CR Roll number": college_details.roll,
                                              "Class code": getCode(null, college_details.roll)
                                          });
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
}


