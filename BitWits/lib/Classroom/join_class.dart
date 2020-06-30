import 'package:bitwitsapp/Intermediate.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/info.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  int y;
  String enteredCode,branch, name;
  bool showSpinner = false,isValid = false;

  @override
  void initState() {
    super.initState();

    registeredCurrentUser();
  }

  void registeredCurrentUser() async {
    final regUser = await _auth.currentUser();
    currentUser = regUser;
  }

  _validateCode(String code) async {
    await Firestore.instance.collection('Classrooms').getDocuments()
    .then((snapshot){
      var docs = snapshot.documents;
      for(var doc in docs) {
        print(doc.documentID);
        if(code == doc.documentID){
          setState(() => isValid = true);
          break;
        }
      }
    });
  }

  _getYear(){
    try {
      setState(() {
        y = int.parse(enteredCode.substring(5, 6));
      });
    } catch (e) {
      Flushbar(
        messageText: Text(
          'Invalid code',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        icon: errorIcon,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      )..show(context);
    }
  }

  // Future<void> _checkStatus(String code) async {
  //   await Firestore.instance.collection('Classrooms').document(code).get()
  //         .then((doc){
  //           setState(() => status = doc.data['block']);
  //         });
  // }

  Future<void> _updateStatus() async {
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
        .updateData({
          "Current class code": enteredCode,
          "roll number": rollcon.text
        });
    if(y == 1) await Firestore.instance
                  .collection('Status')
                  .document(currentUser.email)
                  .setData({'Branch': branch,},merge: true);

      await Firestore.instance.collection('Classrooms/$enteredCode/Assignments').getDocuments()
      .then((snapshot){
          snapshot.documents.forEach((doc) async {
            await Firestore.instance.collection('Classrooms/$enteredCode/Assignment Status')
            .document(doc.documentID).setData({rollcon.text: false},merge: true);
          });
        }
      );
  }

Future<void> _saveToCF() async {
    await Firestore.instance
        .collection("Classrooms/$enteredCode/Students")
        .document(currentUser.uid)
        .setData({"name": name, "roll number": rollcon.text,"email": currentUser.email,'CR': false});
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
                            FocusScope.of(context).unfocus();
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
                  OK(
                    onPressed: () async {
                    //process
                    setState(() => showSpinner = true);
                    await _validateCode(enteredCode);
                    if(isValid) {
                      try{
                        await _updateStatus();
                        await _saveToCF();
                        await Firestore.instance.collection('History').document(currentUser.email)
                        .setData({'class joined on ${DateTime.now()} with roll number and branch': '${codecon.text} , ${rollcon.text} and $branch'},merge: true);
                        Navigator.pushReplacementNamed(context, Intermediate.id);
                      }catch(e){
                        setState(() => showSpinner = false);
                        Flushbar(
                          icon: errorIcon,
                          backgroundColor: Colors.red,
                          messageText: 
                            Text(
                              'An error occured...Pls try agian later!',
                               style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          duration: Duration(seconds: 2),
                        )..show(context);
                      }
                    }
                    else{
                      setState(() => showSpinner = false);
                      Flushbar(
                          messageText: Text(
                            "Invalid code",
                            style:
                              TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          icon: errorIcon,
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                      )..show(context);
                    }
                        // else {
                        //   setState(() => showSpinner = false);
                        //   Flushbar(
                        //   messageText: Text(
                        //     "Class is blocked!",
                        //     style:
                        //       TextStyle(fontSize: 15, color: Colors.white),
                        //   ),
                        //   icon: Icon(Icons.block,color: Colors.white,),
                        //   duration: Duration(seconds: 2),
                        //   backgroundColor: Colors.red,
                        //   )..show(context);}
                        }
                  )
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
                        _getYear();
                        if (y == 1) createBranchDialog(context);
                        else {
                          setState(() => showSpinner = true);
                          await _validateCode(enteredCode);
                          if(isValid) {
                            try{
                              FocusScope.of(context).unfocus();
                              await _updateStatus();
                              await _saveToCF();
                              await Firestore.instance.collection('History').document(currentUser.email)
                              .setData({'class joined on ${DateTime.now()} with roll number and branch': '${codecon.text} , ${rollcon.text} and $branch'},merge: true);
                              Navigator.pushNamed(context, Intermediate.id);
                            }catch(e){
                              setState(() => showSpinner = false);
                              Flushbar(
                                icon: errorIcon,
                                backgroundColor: Colors.red,
                                messageText: 
                                  Text(
                                    'An error occured...Pls try agian later!',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                duration: Duration(seconds: 2),
                              )..show(context);
                            }
                          }
                          else{
                            setState(() => showSpinner = false);
                            Flushbar(
                                messageText: Text(
                                  "Invalid code",
                                  style:
                                    TextStyle(fontSize: 15, color: Colors.white),
                                ),
                                icon: errorIcon,
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                            )..show(context);
                          }
                        }
                      }
                    },
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
