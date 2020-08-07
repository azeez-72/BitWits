import 'package:bitwitsapp/exports.dart';
import 'package:bitwitsapp/Intermediate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:bitwitsapp/Headings/RegsiterHeading.dart';

class SignUp extends StatefulWidget { 
  static final String id = 'sign_up';
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  //shifted rollno from private class to let New_Class access it
  String _email,_password,name,error = " ";
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  FirebaseUser loggedInUser;
  bool showSpinner = false;

  Future<void> updateStatus(String email,String name,String cc) async {
    await Firestore.instance.collection("Status").document(email).setData({
      "Name": name.substring(0,1).toUpperCase() + name.substring(1),
      "Current class code": cc,
      "roll number": 'NA'
    });
    await Firestore.instance.collection('History').document(email).setData({'Name': name.substring(0,1).toUpperCase() + name.substring(1)},merge: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    resizeToAvoidBottomInset: false,
    resizeToAvoidBottomPadding: false,
    body: ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
        width: double.infinity,
        //background decoration
        decoration: BGDecoration,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              appName(
                fontSize: 20,
                color: Colors.white,
              ),
              RegisterHeading(),
              const SizedBox(height: 7),
              Expanded(
                child: Container(
                  //main page decoration
                  decoration: textCardDecoration,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFields("Name",TextInputType.text,
                              Icon(Icons.person),(String value){
                                //validate
                                if(value.isEmpty) {
                                  return 'Enter your name';
                                }
                                return null;
                              }, (String value) {
                                //note
                                name = value;
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFields("Email",TextInputType.emailAddress,
                                Icon(Icons.email),
                                (String value){
                                  if(value.isEmpty) return 'Enter your email';
                                  return null;
                                }, (String value) => _email = value
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFields("Password",TextInputType.text,
                                Icon(Icons.lock_outline),(String value){
                                  //validate
                                  if(value.isEmpty) return 'Enter your password';
                                  return null;
                                }, (String value) => _password = value
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Builder(
                          builder: (context) =>
                          button('Register',18, () async {
                            if(_formKey.currentState.validate()) _formKey.currentState.save();
                            try {
                              setState(() => showSpinner = true);
                              final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                  email: _email.trim(), password: _password);
                              if(newUser != null) {
                                try{
                                  await updateStatus(_email.trim(), name, "New");
                                  setState(() => showSpinner = false);
                                  Navigator.popAndPushNamed(context, Intermediate.id);
                                } catch(e){
                                  setState(() => showSpinner = false);
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: errorMessage('An error occured...Pls try again later!'),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 3),
                                    )
                                  );
                                }
                                }
                              } catch (e) {
                                setState(() => showSpinner = false);
                                error = getError(e);
                                print(error);
                                //emphasis
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: errorMessage(error),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3,),
                                    ),
                                  );
                            }
                          }),
                        ),
                        const SizedBox(height: 24,),
                        Divider(
                          color: Colors.grey[400],
                          thickness: 1,
                          height: 20,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, SignIn.id);
                                },
                                child: Text(
                                  'Already a user?',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SignIn.id);
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 17,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

//0B3A70
//||