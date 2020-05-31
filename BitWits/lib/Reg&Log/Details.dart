import 'dart:math';
import 'package:bitwitsapp/Home_Screen/Assignments.dart';
import 'package:bitwitsapp/Reg&Log/New_Class.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/textFields.dart';
import 'package:bitwitsapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:bitwitsapp/StudentData.dart';
import 'package:bitwitsapp/info.dart';

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

  Future<void> writeQuery() async {
    //write your  queries
    await ClassRef.child("Year 1/Batch $a/Class code").once().then((DataSnapshot snapshot){
      print(snapshot.value);
      setState(() {
        data = snapshot.value;
        });
      }).catchError((error){
      print(error);
    }); 
  }

  bool codeValidate(String value){
    writeQuery();
    bool check;
    if(value.isEmpty || value == null) check = false;
    if(value.isNotEmpty && value != null){
      if(a>=1 && a<=6 && value.substring(0,1) == 'b') {
        if(value == data) check = true;
        else check = false;
      }
      else check = false;
    }
    return check;
  }

  String getCode(String b,String r){
    Info.assign();
    String i;
    if(yearSelectedValue == "1") i = "b$b";
    else i = Info.sform[branchSelectedValue];
    String m = Random().nextInt(9999).toString();
    String l = r.substring(r.length - 2);

    return "$i$m$l";
  }
  /*
  final ClassRef = FirebaseDatabase.instance.reference().child("Classroom");
  static String data;
  
  Future<void> writeQuery() async {
    //write your  queries
    await ClassRef.child("Year ${college_details.year}/Batch ${studentsData.data[currentUser.email]["Batch"]}/Class code").once().then((DataSnapshot snapshot){
      print(snapshot.value);
      data = snapshot.value;
      print(data);
      }).catchError((error){
      print(error);
    }); 
  } */

  static String code;

  String enteredCode;
  String error = ' ';
  TextEditingController code_controller;

 validateAlertDialog(BuildContext context){
    return showDialog(context: context,builder: (context) {
      return Consumer<StudentData>(
        builder: (context,studentsData,child){
          return AlertDialog(
          title: Text(
            'Enter class code',
            style: TextStyle(
              color: mainColor,
              fontSize: 22,
            ),
          ),
          content: Container(
            child: Form(
              child: CodeFields('Code',TextInputType.text,code_controller)
            ),
          ),
          actions: <Widget>[
            Text(error,style: TextStyle(color: Colors.red,fontSize: 14),),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              }, child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.grey),
                ),
            ),
            FlatButton(
              onPressed: () {
                a = int.parse(code_controller.text.substring(1,2));
                print(a);
                if(codeValidate(code_controller.text)) {
                  //feed entry to DB
                  DBRef.child("Students").child("Year 1").child(studentsData.data[currentUser.email]["Batch"]).set({
                      "name": studentsData.data[currentUser.email]["Name"],
                      "email": currentUser.email,
                      "branch": studentsData.data[currentUser.email]["Branch"],
                      "batch": studentsData.data[currentUser.email]["Batch"],
                    });
                    Navigator.pushNamed(context, Assignments.id);               
                }
                else error = "Invalid code!";
              },child: Text(
                'JOIN',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
        }
      );
    });
  } 

  createAlertDialog(BuildContext context){
    return (yearSelectedValue == "1" && branchSelectedValue != null) ? showDialog(context: context,builder: (context){
      return Consumer(
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
                    items: Info.batches.map((String value) {
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
                  //save data to DB of CR FY's
                  studentsData.addData(currentUser.email,"Batch",batchSelectedValue); //save batch
                  try {
                    DBRef.child("Students").child("Year ${studentsData[currentUser.email]["Year"]}").child(studentsData.data[currentUser.email]["Batch"]).set({
                      "name": studentsData.data[currentUser.email]["Name"],
                      "email": currentUser.email,
                      "branch": studentsData.data[currentUser.email]["Branch"],
                      "batch": studentsData.data[currentUser.email]["Batch"]
                    });
                    DBRef.child("Classroom").child("Year ${studentsData[currentUser.email]["Year"]}").child("Batch ${studentsData[currentUser.email]["Batch"]}").set({
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
                                studentsData.addData(currentUser.email, "Roll Number", value);
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
                                      items: Info.branches.map((String value) { //
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
                                            items: Info.years.map((String value) {
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
                                          validateAlertDialog(context);
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






//validation
/*(String value) async {
            //validation
            if(value.isEmpty){  
              return "Enter code";
            }
            if(value.isNotEmpty){
              //FY
              int a = int.parse(value.substring(1,2));
              if(a>=1 && a<=6 && value.substring(0,1) == 'b') {
                if(value == await DBRef.child("Classroom").child("Year 1").child("Batch $a/Class code").once().then((DataSnapshot snapshot) => snapshot.value)){
                  //success
                  //navigate
                  Navigator.push(context,MaterialPageRoute(builder: (context) => New_Class(college_details)));
                }
                else return "Invalid code";
              }
              //SY,TY,final
              else if(value.isNotEmpty){
                //TODO: complex code for seniors
              }
              else return "Invalid code!";
            }
            return null;
            }*/