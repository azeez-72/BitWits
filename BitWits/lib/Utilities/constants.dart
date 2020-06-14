import 'package:flutter/material.dart';

const Color mainColor = Color(0xFF2265B3);
String label;

const errorIcon = Icon(
  Icons.error,
  size: 28.0,
  color: Colors.white,
);

InputDecoration textInputDecoration(String label) {
  return InputDecoration(
    labelText: label, //
    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
}

const textCardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(70),
    bottomRight: Radius.circular(100),
  ),
);

const BGDecoration = BoxDecoration(
  gradient: LinearGradient(begin: Alignment.centerRight, colors: [
    Color(0xFF2265B3),
    Color(0xFF00498D),
    Color(0xFF0052A2),
  ]),
);

String getError(Exception e) {
  String exception = e.toString();
  int i1 = exception.indexOf(',');
  int i2 = exception.indexOf(', null');
  return exception.substring(i1 + 2, i2);
}

class ToggleCR extends StatelessWidget {
  final int toggleIndex;
  final Function onToggle;

  ToggleCR({this.toggleIndex, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            'Are you a CR?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
//        Padding(
//          padding: EdgeInsets.only(top: 15, bottom: 0),
//          child: ToggleSwitch(
//              minWidth: 50.0,
//              cornerRadius: 5,
//              initialLabelIndex: toggleIndex,
//              activeBgColor: mainColor,
//              activeTextColor: Colors.white,
//              inactiveBgColor: Colors.grey,
//              inactiveTextColor: Colors.white,
//              labels: ['YES', 'NO'],
//              onToggle: onToggle,
//              ),
//        ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class BranchText extends StatelessWidget {
  final String title;

  BranchText({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Select your $title',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: mainColor,
        fontSize: 16,
      ),
    );
  }
}

class Cancel extends StatelessWidget {
  const Cancel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'CANCEL',
        style: TextStyle(color: Colors.grey),
      ),
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

/*

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
  */
