import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:provider/provider.dart';

class AddAssignment extends StatefulWidget {
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime _value = DateTime.now();
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _saveToCF(String code){
    Firestore.instance.collection('Classrooms/$code/Assignments').document(titleController.text).setData({
      'Title': titleController.text,
      'Description': descriptionController.text == '' ? 'Not provided' : descriptionController.text,
      'Created at': DateTime.now(),
      'Deadline': _dateFormat.format(_value),
    });
  }

  Future<void> _initialie(String code){
    Firestore.instance.collection('Classrooms/$code/Students').snapshots().forEach((snapshot) {
      snapshot.documents.forEach((doc) {
        Firestore.instance.collection('Classrooms/$code/Assignments/${titleController.text}/Completion Status')
        .document(doc['roll number']).setData({
          'isDone': false
        });
      });
    });
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
        return SafeArea(
          child: Container(
            height: 500,
            color: Color(0xFF757575),
            child: Container(
              decoration: bottomSheetDecoration,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text('Add assignment',style: TextStyle(color: mainColor,fontSize: 22,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    CodeFields('title', TextInputType.text, titleController),
                    SizedBox(height: 15),
                    CodeFields('Description(optional)', TextInputType.text, descriptionController),
                    SizedBox(height: 15),
                    Container(
                    child: FlatButton.icon(
                      label: Text("SELECT DATE OF SUBMISSION",style: TextStyle(color: mainColor),),
                      icon: Icon(
                        Icons.date_range,
                        color: mainColor,
                      ),
                      onPressed: () => _selectDate(),
                      ),
                    ),
                    Container(
                      child: Text(
                        _dateFormat.format(_value),
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 20,),
                    button('Add', 18,
                      () async {
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
                          await _saveToCF(data.currentClassCode);
                          await _initialie(data.currentClassCode);
                          Navigator.pop(context);
                        }
                      })
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