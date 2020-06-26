import 'package:flutter/material.dart';

class OptionListTile extends StatelessWidget {
  final Widget icon;
  final String title,subtitle;
  final Function onTap;

  OptionListTile({this.icon,this.title,this.subtitle,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10,top: 5),
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            offset: Offset(0, 1.0), //(x,y)
            blurRadius: 2.0,
          ),],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: FlatButton(
        onPressed: onTap,
        child: ListTile(
          leading: icon,
          trailing: title == 'Contact us' ? null : Icon(Icons.arrow_forward_ios,size: 18,),
          title: Text(title,style: TextStyle(color: title == 'Books' ? Colors.grey : Colors.black87,fontWeight: FontWeight.w600),),
          subtitle: Text(subtitle,),
        ),
      ),
    );
  }
}