import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:bitwitsapp/Utilities/UIStyles.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:bitwitsapp/Utilities/info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Details extends StatefulWidget {
  static final String id = "details";

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map reversed = Info.getBranch().map((k, v) => MapEntry(v, k));

  String branch;
  bool _isEditableName = false;
  // bool _isEditableRoll = false;
  TextEditingController nameCon = TextEditingController();
  // TextEditingController rollCon = TextEditingController();

  Future<void> _editName(String email,String uid,String code) async {
    await Firestore.instance.collection('Status').document(email).updateData({'Name': nameCon.text});
    await Firestore.instance.collection('Classrooms/$code/Students')
          .document(uid).updateData({'name': nameCon.text});
    await Firestore.instance.collection('History').document(email)
          .setData({'Name change on ${DateTime.now()}': nameCon.text},merge: true);
  }

  // Future<void> _editRollNumber(String email,String uid,String code) async {
  //   await Firestore.instance.collection('Status').document(email).updateData({'Roll number': rollCon.text});
  //   await Firestore.instance.collection('Classrooms/$code/Students')
  //         .document(uid).updateData({'roll number': rollCon.text});
  //   await Firestore.instance.collection('History').document(email)
  //         .setData({'Roll number change on ${Timestamp.now()}': rollCon.text},merge: true);
  // }

  void setFalse(){
    // _isEditableRoll = false;
    _isEditableName = false;
  }

  @override
  Widget build(BuildContext context) {
    var mobile = MediaQuery.of(context);
    return Consumer<Data>(
      builder: (context,studentData,child){
        return Scaffold(
          appBar: AppBar(
            leading: _isEditableName ? 
              IconButton(icon: Icon(Icons.cancel,),onPressed: () => setState(() => setFalse())) :
              IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ 
                _isEditableName = false;
                Navigator.pop(context);
              }),
            title: Text('Details'),
            backgroundColor: mainColor,
            actions: [
              if(_isEditableName)  IconButton(icon: Icon(Icons.done,),onPressed: () async{ 
                if(nameCon.text == '') print('error');
                  else{
                    studentData.updateName(nameCon.text);
                    await _editName(studentData.currentEmail, studentData.uid, studentData.currentClassCode);
                  }
                  // if(_isEditableRoll){
                  //   if(rollCon.text == '') print('error');
                  //   else{
                  //     studentData.updateRoll(rollCon.text);
                  //     await Firestore.instance.collection('Status').document(studentData.currentEmail).updateData({'Roll number': rollCon.text});
                  //     await Firestore.instance.collection('Classrooms/${studentData.currentClassCode}/Students')
                  //         .document(studentData.uid).updateData({'roll number': rollCon.text});
                  //   }
                  // }
                  setState(() => _isEditableName = false);
               })],
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Container(
                width: mobile.size.width*0.9,
                height: mobile.size.height*0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 7,
                      offset: Offset(0.0,1.0),
                      color: Colors.grey[300],
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24,right: 24),
                  child: ListView(
                    children: [
                      SizedBox(height: 20),
                      Center(child: Image.asset('images/vjti.png',height: 100)),
                      SizedBox(height: mobile.size.height*0.1),

                      Row(children: [
                        Text('Name:',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                        SizedBox(width: 10),
                        !_isEditableName ?
                        Flexible(child: Row(children: [
                            Text(studentData.name,style: TextStyle(fontSize: 16),softWrap: false,overflow: TextOverflow.fade,),
                            IconButton(key: ValueKey('Edit name'),icon: Icon(Icons.edit), onPressed:() => setState(() => _isEditableName = true)),
                          ],))
                        : Container(
                            width: 100,
                            child: TextField(
                              maxLength: null,
                              autofocus: true,
                              controller: nameCon,
                              decoration: InputDecoration(hintText: 'Edit name',border: InputBorder.none),
                          )),
                      ],),

                      // Row(children: [
                      //   Text('Roll number:',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      //   SizedBox(width: 10),
                      //   !_isEditableRoll ?
                      //   Flexible(child: Row(children: [
                      //       Text(studentData.rollNumber,style: TextStyle(fontSize: 16),softWrap: false,overflow: TextOverflow.fade,),
                      //       IconButton(icon: Icon(Icons.edit), onPressed:() => setState(() => _isEditableRoll = true)),
                      //     ],))
                      //   : Container(
                      //       width: 100,
                      //       child: TextField(
                      //         maxLength: null,
                      //         autofocus: true,
                      //         controller: rollCon,
                      //         decoration: InputDecoration(hintText: 'Edit roll number'),
                      //     )),
                      // ],),
                      DetailRow(field: 'Roll number',value: studentData.rollNumber),
                      SizedBox(height: 15),
                      DetailRow(field: 'Year',value: studentData.currentClassCode.substring(5,6)),
                      SizedBox(height: 15), 
                      DetailRow(field: 'Batch',
                        value: studentData.currentClassCode.substring(0,1) == 'b' ?
                          studentData.currentClassCode.substring(1,2) : 'Not available'
                      ),
                      SizedBox(height: 15),
                      DetailRow(field: 'Branch',
                        value: studentData.currentClassCode.substring(5,6) == '1' ? studentData.branch
                                : reversed[studentData.currentClassCode.substring(0,2)]
                      ),
                      SizedBox(height: 15),
                      DetailRow(field: 'Email',value: studentData.currentEmail,),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailRow extends StatelessWidget {
  final String field;
  final String value;

  DetailRow({this.field,this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$field:',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
        SizedBox(width: 10,),
        Flexible(child: Text(value,style: TextStyle(fontSize: 16),softWrap: false,overflow: TextOverflow.fade,)),
      ],
    );
  }
}