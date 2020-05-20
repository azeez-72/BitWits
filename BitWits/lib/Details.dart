import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textFields.dart';

class Details extends StatefulWidget {
  static final String id = 'details';

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
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
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFields(
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
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        button('CR', () {}),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(child: button('Join', () {})),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: button('Create', () {})),
                            ]),
                        SizedBox(
                          height: 24,
                        ),
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
