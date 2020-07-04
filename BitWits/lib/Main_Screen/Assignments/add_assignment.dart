import 'dart:collection';
import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddAssignment extends StatefulWidget {
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

//https://drive.google.com/file/d/12kNsgVaVtN667omrBaZXdpGcn24yJUrP/view?usp=sharing

class _AddAssignmentState extends State<AddAssignment> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  DateTime _value = DateTime.now();
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  bool showSpinner = false;
  String title;
  // ignore: non_constant_identifier_names
  HashMap<String,bool> Completions = HashMap<String,bool>();

  Future<void> _saveToCF(String code) async {

    setState(() => title = titleController.text);

    await Firestore.instance.collection('Classrooms/$code/Assignments').document(titleController.text).setData({
      'Title': titleController.text.trim(),
      'Description': descriptionController.text == '' ? 'Not provided' : descriptionController.text,
      'G-drive link': linkController.text.trim(),
      'Created at': DateTime.now(),
      'Deadline': _dateFormat.format(_value),
    });
  }

  Future<void> _getRollNumbers(String code) async {
    try{
      await Firestore.instance.collection('Classrooms/$code/Students').getDocuments()
      .then((snap) {
        snap.documents.forEach((document) {
          print(document.data['roll number']);
          setState(() => Completions[document.data['roll number']] = false);
        });
      });
    }catch(e){print(e);}
  }

  Future<void> _initialize(String code) async {
    try{
      await Firestore.instance.collection('Classrooms/$code/Assignments').document(title)
      .setData({'Completions' : Completions},merge: true);
    } catch(e){print(e);}
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2025));
    if (picked != null) setState(() => _value = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context,data,child){
        return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Container(
              height: 500,
              color: Color(0xFF757575),
              child: Container(
                decoration: bottomSheetDecoration,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16,left: 16,top: 8,bottom: 24),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          trailing: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                          title: Text('Add assignment',style: TextStyle(color: mainColor,fontSize: 22,fontWeight: FontWeight.bold),)),
                        SizedBox(height: 5,),
                        CodeFields('title', TextInputType.text, titleController),
                        SizedBox(height: 15),
                        CodeFields('Description(optional)', TextInputType.text, descriptionController),
                        SizedBox(height: 15),
                        CodeFields('G-drive link for assignment(optional)',TextInputType.text,linkController),
                        Container(
                        child: FlatButton.icon(
                          label: Text("SELECT DATE OF SUBMISSION",style: TextStyle(color: mainColor),),
                          icon: Icon(
                            Icons.date_range,
                            color: mainColor,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                             _selectDate();
                          },
                          ),
                        ),
                        Container(
                          child: Text(
                            _dateFormat.format(_value).toString().split('-').reversed.join('-'),
                            style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 20,),
                        button('Add', 18,
                          () async {
                            FocusScope.of(context).unfocus();
                            if(titleController.text == '')
                            Flushbar(
                              messageText: Text(
                                "Pls enter the title",
                              style:
                                TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              icon: errorIcon,
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            )..show(context);
                            else {
                              setState(() => showSpinner = true);
                              try{
                                await _saveToCF(data.currentClassCode);
                                await _getRollNumbers(data.currentClassCode);
                                if(title != null) await _initialize(data.currentClassCode);
                                setState(() => showSpinner = false);
                                Navigator.pop(context);
                              } catch(e){
                                print(e);
                                  Flushbar(
                                    messageText: Text(
                                      "'An error occured...Pls try again later!",
                                    style:
                                      TextStyle(fontSize: 15, color: Colors.white),
                                    ),
                                    icon: errorIcon,
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                )..show(context);
                              }
                            }
                          })
                        ],
                      ),
                    ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
