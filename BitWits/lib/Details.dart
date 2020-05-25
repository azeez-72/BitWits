import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textFields.dart';
import 'main.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Details extends StatefulWidget {
  static final String id = 'details';

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  String rollnumber;
  String froll;
  String branch;
  int year;
  int batch;
  static int toggleIndex = 1;
  static int batchMax = 6;

  var _branches = [
    "Computer",
    "IT",
    "EXTC",
    "Electronics",
    "Electrical",
    "Mechanical",
    "Civil",
    "Production",
    "Textile",
  ];

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
                  hintText: 'Select Batch',
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

            }, child: Text('OK'),
          )
        ],
      );
    }) : null;
  }

  static var branchSelectedValue;
  static var batchSelectedValue;
  static String yearSelectedValue;
  TextEditingController rollCon;

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
                          TextFields("Roll Number", TextInputType.number, null,rollCon,
                              (value) {
                            rollnumber = value;
                          }),
                          SizedBox(
                            height: 16,
                          ),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    labelText: 'Branch',
                                    errorStyle: TextStyle(
                                        color: Colors.redAccent, fontSize: 16.0),
                                    hintText: 'Select Branch',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                isEmpty: branchSelectedValue == '',
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
                                    items: _branches.map((String value) {
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
                                          hintText: 'Select Year',
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
                                        //Emphasis
                                          if(rollnumber == null || branchSelectedValue == null || yearSelectedValue == null)
                                          Scaffold.of(context).showSnackBar(
                                             SnackBar(
                                               content: errorMessage('Please fill in the details'),
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
                                        //Emphasis
                                        setState(() {
                                          if(rollnumber == null || branchSelectedValue == null || yearSelectedValue == null)
                                          Scaffold.of(context).showSnackBar(
                                             SnackBar(
                                               content: errorMessage('Please fill in the details'),
                                              duration: Duration(milliseconds: 2000),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          createAlertDialog(context);
                                        });                                          
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


