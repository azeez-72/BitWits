import 'package:bitwitsapp/Main_Screen/Dashboard_screen.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/info.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinClass extends StatefulWidget {
  static String id = "join_class";

  @override
  _JoinClassState createState() => _JoinClassState();
}

class _JoinClassState extends State<JoinClass> {
  final codecon = TextEditingController();
  final rollcon = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  int n, y;
  String b, enteredCode, error = '', branch, name;
  bool showSpinner = false;
  final DBRef = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    registeredCurrentUser();
  }

  void registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
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
        .updateData({"Current class code": enteredCode});
  }

  createBranchDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: BranchText(
              title: "branch",
            ),
            content: FormField<String>(
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
            actions: <Widget>[
              Cancel(),
              OK(onPressed: () async {
                //process
                await updateStatus();
                await saveToDB();
                await saveToCF();

                Navigator.pushReplacementNamed(context, BottomNavigation.id);
              })
            ],
          );
        });
  }

  Future<void> saveToCF() async {
    Firestore.instance
        .collection("Classrooms")
        .document(enteredCode)
        .collection("Students")
        .document(currentUser.uid)
        .setData({"name": name, "roll number": rollcon.text});
  }

  Future<void> saveToDB() async {
    if (y == 1)
      await DBRef.child("Students")
          .child("Year $y")
          .child("Batch $n")
          .child(rollcon.text)
          .set({"name": name, "email": currentUser.email, "branch": branch});
    else
      await DBRef.child("Students")
          .child("Year $y")
          .child(branch)
          .child(rollcon.text)
          .set({
        "name": name,
        "email": currentUser.email,
      });
  }

  Future<void> checkCode(String code) async {
    setState(() {
      showSpinner = true;
    });
    try {
      y = int.parse(enteredCode.substring(5, 6));
    } catch (e) {
      error = "Invalid code";
    }
    if (y == 1)
      try {
        n = int.parse(enteredCode.substring(1, 2));
      } catch (e) {
        error = "Invalid code";
      }
    else
      b = enteredCode.substring(0, 2);
    if (enteredCode == await getCodeFromDB()) {
      setState(() {
        showSpinner = false;
        error = '';
      });
    } else {
      setState(() {
        showSpinner = false;
      });
      error = "Invalid code";
      if (error == "Invalid code")
        Flushbar(
          messageText: Text(
            error,
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          icon: errorIcon,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        )..show(context);
    }
  }

  Future<String> getCodeFromDB() async {
    String value;
    Map reversed = Info.getBranch().map((k, v) => MapEntry(v, k));
    branch = reversed[b];
    value = y == 1
        ? await DBRef.child("Classroom")
            .child("Year 1")
            .child("Batch $n/Class code")
            .once()
            .then((DataSnapshot snapshot) => snapshot.value)
        : await DBRef.child("Classroom")
            .child("Year $y")
            .child("$branch/Class code")
            .once()
            .then((DataSnapshot snapshot) => snapshot.value);
    return value;
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
                    Text('Enter the following to join a class',
                        style: TextStyle(
                          fontSize: 25,
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(height: 40),
                    CodeFields('Roll number', TextInputType.number, rollcon),
                    SizedBox(
                      height: 15,
                    ),
                    CodeFields('Code', TextInputType.text, codecon),
                    SizedBox(height: 20),
                    button(
                      'Join',
                      18,
                      () async {
                        if (rollcon.text.isEmpty || codecon.text.isEmpty)
                          Flushbar(
                            messageText: Text(
                              "Fill in the details",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            icon: errorIcon,
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          )..show(context);
                        else {
                          enteredCode = codecon.text;
                          await checkCode(enteredCode);
                          if (y == 1 && error == '')
                            createBranchDialog(context);
                          if (error == '') {
                            if (y != 1) {
                              await updateStatus();
                              await saveToDB();
                              await saveToCF();

                              Navigator.pushReplacementNamed(
                                  context, BottomNavigation.id);
                            }
                          }
                        }
                      },
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
