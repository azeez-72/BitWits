import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BSRdisplay extends StatefulWidget {
  @override
  _BSRdisplayState createState() => _BSRdisplayState();
}

class _BSRdisplayState extends State<BSRdisplay> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          separatorBuilder: (context,index) => SizedBox(height: 10),
          itemCount: 20,
          itemBuilder: (context,index) => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(0, 1.0), //(x,y)
                  blurRadius: 2.0,
                ),],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: ListTile(
              isThreeLine: true,
              title: Row(
                children: [
                  //content
                  Text('7'),
                  SizedBox(width: 3),
                  SvgPicture.asset('svgs/stack_of_books.svg',width: 15,color: mainColor),
                  SizedBox(width: 10),
                  Container(
                    child: Text('Kumbhojkar-I')
                  ),
                ],
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: TextStyle(

                  )
                ), 
              ),
              trailing: Text('₹500',style: TextStyle(color: Colors.grey[850],fontSize: 20))
            ),
          ),
        ),
      );
  }
}