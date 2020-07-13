import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../options.dart';

class Resources_res extends StatefulWidget {
  static final String id = 'resources';

  @override
  _Resource_listState createState() => _Resource_listState();
  
}

class _Resource_listState extends State<Resources_res> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){ 
                Navigator.pop(context);
              }),
            title: Text('Resources'),
            backgroundColor: mainColor,
      ),
        body: SafeArea(
            child: Column(
            children: <Widget>[
              OptionListTile(
                  icon: Icon(Icons.assignment,color: mainColor,size: 32,),
                  title: 'Previous Years Papers',
                  subtitle: 'Question Papers',
                  onTap: () => {_launchURL("https://drive.google.com/open?id=0Bx7IrwIRxV6xOHNqR3Rlc1EwR2M")},
                ),
                OptionListTile(
                  icon: Icon(Icons.book,color: mainColor,size: 32,),
                  title: 'Reference Books',
                  subtitle: 'Collection of reference books',
                  onTap: () => {_launchURL("https://drive.google.com/open?id=0Bx7IrwIRxV6xOHNqR3Rlc1EwR2M")},
                ),
              ],
          ),
        ),
      );
    }
}