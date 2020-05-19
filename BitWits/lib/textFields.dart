import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFields extends StatelessWidget {

  final String labelTag;
  final Function onChange;
  final bool hide;
  final TextInputType textInputType;
  final Icon icon;

  TextFields(this.labelTag,this.hide, this.textInputType,this.icon,this.onChange);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: TextField(
          obscureText: hide,
          keyboardType: textInputType,
          onChanged: onChange,
          decoration: InputDecoration(
            prefixIcon: icon,
            labelText: labelTag,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Colors.blue[400],
                width: 1.5),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(3),),
            ),
          ),
        )
    );
  }
}


// ignore: camel_case_types
class button extends StatelessWidget {

  final String buttonText;
  final Function onPress;

  button(this.buttonText,this.onPress);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Color(0xFF0B3A70),
        padding: EdgeInsets.only(top: 5,bottom: 5),
        onPressed: onPress,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}