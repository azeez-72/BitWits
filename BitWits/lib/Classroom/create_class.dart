import 'dart:math';
import 'package:bitwitsapp/Classroom/CodeDisplay.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bitwitsapp/Utilities/info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';

class CreateClass extends StatefulWidget {
  static final String id = "create_class";

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  bool showSpinner = false;
  final codecon = TextEditingController();
  final rollcon = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  String year, branch, code, batch, name;
  final DBRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    registeredCurrentUser();
  }

  Future<void> updateStatus() async {
    await Firestore.instance
        .collection("Status")
        .document(currentUser.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        name = snapshot.data["Name"];
      });
    });
    await Firestore.instance
        .collection("Status")
        .document(currentUser.email)
        .updateData({"Current class code": code});
  }

  void registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
    print(currentUser.email);
  }

  Future<void> saveToCF() async {
    Firestore.instance
        .collection("Classrooms")
        .document(code)
        .collection("Students")
        .document(currentUser.uid)
        .setData({"name": name, "roll number": rollcon.text});
  }

  Future<void> saveToDB() async {
    if (year == "1") {
      await DBRef.child("Students")
          .child("Year $year")
          .child("Batch $batch")
          .child(rollcon.text)
          .set({"name": name, "email": currentUser.email, "branch": branch});
      await DBRef.child("Classroom")
          .child("Year $year")
          .child("Batch $batch")
          .set({"CR Roll number": rollcon.text, "Class code": code});
    } else {
      await DBRef.child("Students")
          .child("Year $year")
          .child(branch)
          .child(rollcon.text)
          .set({
        "name": name,
        "email": currentUser.email,
      });
      await DBRef.child("Classroom")
          .child("Year $year")
          .child(branch)
          .set({"CR Roll number": rollcon.text, "Class code": code});
    }
  }

  createBatchDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: BranchText(
              title: "batch",
            ),
            content: FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: textInputDecoration("Batch"),
                  isEmpty: branch == '', //
                  child: DropDown(
                    value: batch,
                    list: Info.batches.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        batch = newValue;
                        state.didChange(newValue);
                      });
                    },
                  ),
                );
              },
            ),
            actions: <Widget>[
              Cancel(),
              OK(onPressed: () async {
                //process
                code =
                    "b$batch${Random().nextInt(999).toString()}$year${rollcon.text.substring(rollcon.text.length - 2)}";
                await updateStatus();
                ;
                await saveToDB();
                await saveToCF();

                Navigator.pushReplacementNamed(context, CodeDisplay.id);
              })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Enter the following to create a class',
                        style: TextStyle(
                          fontSize: 25,
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(height: 40),
                    CodeFields('Roll Number', TextInputType.number, rollcon),
                    SizedBox(
                      height: 15,
                    ),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: textInputDecoration("Year"),
                          isEmpty: year == '', //
                          child: DropDown(
                            value: year,
                            list: Info.years.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                year = newValue;
                                state.didChange(newValue);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: textInputDecoration("Branch"),
                          isEmpty: branch == '', //
                          child: DropDown(
                            value: branch,
                            list: Info.branches.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                branch = newValue;
                                state.didChange(newValue);
                              });
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    button("Create", 18, () async {
                      if (rollcon.text == null ||
                          year == null ||
                          branch == null)
                        Flushbar(
                          messageText: Text(
                            "Fill in the details",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          icon: errorIcon,
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        )..show(context);
                      else {
                        if (year == "1") createBatchDialog(context);
                        if (year != "1") {
                          code =
                              "${Info.getBranch()[branch]}${Random().nextInt(999).toString()}$year${rollcon.text.substring(rollcon.text.length - 2)}";
                          setState(() {
                            showSpinner = true;
                          });
                          await updateStatus();
                          await saveToDB();
                          await saveToCF();

                          Navigator.pushReplacementNamed(
                              context, CodeDisplay.id);
                        }
                      }
                    }),
                    SizedBox(height: 10),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

//1B6CA8
