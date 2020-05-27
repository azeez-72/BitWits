import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitwitsapp/Reg&Log/Details.dart';

const Color mainColor = Color(0xFF0B3A70);


class TextFields extends StatefulWidget {

  final String labelTag;
  final Function validator;
  final Function onSaved;
  final TextInputType textInputType;
  final Icon icon;
  final bool hidden = true;

  TextFields(this.labelTag,this.textInputType,this.icon,this.validator,this.onSaved);

  @override
  _TextFieldsState createState() => _TextFieldsState(this.labelTag,this.textInputType,this.icon,this.validator,this.onSaved);
}

class _TextFieldsState extends State<TextFields> {

  final String labelTag;
  final Function validator;
  final Function onSaved;
  final TextInputType textInputType;
  final Icon icon;
  bool hidden = true;

  _TextFieldsState(this.labelTag,this.textInputType,this.icon,this.validator,this.onSaved);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: TextFormField(
          validator: validator,
          onSaved: onSaved,
          obscureText: labelTag == "Password" ? hidden : false,
          keyboardType: textInputType,
          decoration: InputDecoration(
            prefixIcon: icon,
            suffixIcon: labelTag == "Password" ? IconButton(
              onPressed: () {
                setState(() {
                  hidden = !hidden;
                });
              },
              icon: hidden == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            ) : null,
            errorBorder: OutlineInputBorder(borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
            ),
            labelText: labelTag,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            disabledBorder: OutlineInputBorder(borderSide: BorderSide(
                color: Colors.grey[200],
                width: 1),
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
class button extends StatefulWidget {

  final String buttonText;
  final Function onPress;
  final double tsize;

  button(this.buttonText,this.tsize, this.onPress);

  @override
  _buttonState createState() => _buttonState(this.buttonText,this.tsize, this.onPress);
}

// ignore: camel_case_types
class _buttonState extends State<button> {

  final String buttonText;
  final Function onPress;
  final double tsize;

  _buttonState(this.buttonText,this.tsize, this.onPress);
//  final bool disableButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: mainColor,
        padding: EdgeInsets.only(top: 5,bottom: 5),
        onPressed: buttonText == "Create classroom" ? DetailsState.toggleIndex==1  ? null : onPress : onPress,
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            fontSize: tsize,
          ),
        ),
      ),
    );
  }
}
