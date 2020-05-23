import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textFields.dart';
<<<<<<< HEAD
import 'package:toggle_switch/toggle_switch.dart';
=======
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529

class Details extends StatefulWidget {
  static final String id = 'details';

  @override
<<<<<<< HEAD
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {

  int rollnumber;
  String branch;
  int year;
  int batch;
  static int toggleIndex = 1;

=======
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
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
<<<<<<< HEAD
                child: Text(
                        "Enter College Details",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        letterSpacing: 1,
                      ),
                    ),
=======
                child: Column(
                  children: <Widget>[
                    Text(
                      "Enter Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
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
<<<<<<< HEAD
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        TextFields("Roll Number", TextInputType.number,
                            null, (value) {
                              rollnumber = value;
                            }),
                        SizedBox(
                          height: 16,
                        ),
                        TextFields("Branch", TextInputType.text,
                            null, (value) {
                              branch = value;
                            }),
=======
                    padding: EdgeInsets.only(top: 80, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        TextFields("Roll Number", false, TextInputType.number,
                            Icon(Icons.add), (value) {}),
                        SizedBox(
                          height: 16,
                        ),
                        TextFields("Branch", false, TextInputType.text,
                            Icon(Icons.add), (value) {}),
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFields(
<<<<<<< HEAD
                                  "Year",
                                  TextInputType.number,
                                  null,
                                  (value) {
                                    year = value;
                                  }),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                  children:<Widget> [
                                    Text(
                                    'Are you a CR?',
                                    style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 15,bottom: 0),
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
                                    SizedBox(height: 10,),
                                  ]
                              ),
=======
                                  "year",
                                  false,
                                  TextInputType.text,
                                  Icon(Icons.add),
                                  (value) {}),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFields(
                                  "Batch",
                                  false,
                                  TextInputType.text,
                                  Icon(Icons.add),
                                  (value) {}),
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
                            ),
                          ],
                        ),
                        SizedBox(
<<<<<<< HEAD
                          height: 24,
=======
                          height: 16,
                        ),
                        button('CR', () {}),
                        SizedBox(
                          height: 20,
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
<<<<<<< HEAD
                              Expanded(child: button('Join classroom',16, () {})),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: button('Create classroom',16, () {})),
                            ]),
=======
                              Expanded(child: button('Join', () {})),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: button('Create', () {})),
                            ]),
                        SizedBox(
                          height: 24,
                        ),
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
<<<<<<< HEAD

=======
>>>>>>> 2fe39b3e16c7f78263a053891ac46899aca9c529
