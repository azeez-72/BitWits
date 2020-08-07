import 'package:flutter/material.dart';
import 'package:bitwitsapp/Utilities/constants.dart';

class AssignmentTile extends StatelessWidget {

  final bool dateChanged;
  final bool completed;
  //studentDocs[index]['Completions'][data.rollNumber]
  final double sheetHeight;
  //height: mobile.size.height * 0.75
  final String deadline;
  //studentDocs[index]['Deadline']
  final String link;
  //studentDocs[index]['G-drive link']
  final Function linkonTap;
  // launch(studentDocs[index]['G-drive link'])
  final String description;
  //studentDocs[index]['Description']

  AssignmentTile({this.sheetHeight,this.dateChanged,this.completed,this.deadline,this.link,this.description,this.linkonTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: mobile.size.height * 0.75,
      height: sheetHeight,
      width: double.infinity,
      child: Scrollbar(
        child: ListView(children: [
          ListTile(
            trailing: completed ? Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 28,
                  )
                : Icon(
                    Icons.error_outline,
                    color: DateTime.parse(deadline)
                            .difference(DateTime.now())
                            .inDays < 2
                        ? Colors.red
                        : Colors.grey,
                    size: 28,
                  ),
            title: Text(
              'Description',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: mainColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () =>
                    Navigator.pop(context)),
          ),
          if (link != '')
            SizedBox(height: 16),
          if (link != '')
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: ButtonTheme(
                minWidth: 100,
                height: 40,
                child: OutlineButton(
                  borderSide: BorderSide(color: mainColor),
                  child: Text(
                    'Open File',
                    style: TextStyle(
                        color: mainColor,
                        fontSize: 18),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                  onPressed: linkonTap
                ),
              ),
            ),
          if(dateChanged) SizedBox(height: 10),
          if (dateChanged)
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16),
              child: Text('Submission date changed to $deadline',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontStyle: FontStyle.italic,fontSize: 16)),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                    wordSpacing: 1,
                    height: 1.2),
              ),
            ),
          )
        ]),
      ),
    );
  }
}