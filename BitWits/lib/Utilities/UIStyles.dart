import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

class TextFields extends StatefulWidget {
  final String labelTag;
  final Function validator;
  final Function onSaved;
  final TextInputType textInputType;
  final Icon icon;
  final bool hidden = true;

  TextFields(this.labelTag, this.textInputType, this.icon, this.validator,
      this.onSaved);

  @override
  _TextFieldsState createState() => _TextFieldsState(this.labelTag,
      this.textInputType, this.icon, this.validator, this.onSaved);
}

class _TextFieldsState extends State<TextFields> {
  final String labelTag;
  final Function validator;
  final Function onSaved;
  final TextInputType textInputType;
  final Icon icon;
  bool hidden = true;

  _TextFieldsState(this.labelTag, this.textInputType, this.icon, this.validator,
      this.onSaved);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: TextFormField(
          validator: validator,
          onSaved: onSaved,
          obscureText: labelTag == "Password" ? hidden : false,
          autofocus: labelTag == "Code" ? true : false,
          textInputAction: labelTag == "Password"
              ? TextInputAction.done
              : TextInputAction.next,
          onEditingComplete: labelTag == "Password"
              ? () => FocusScope.of(context).unfocus()
              : () => FocusScope.of(context).nextFocus(),
          keyboardType: textInputType,
          decoration: InputDecoration(
            prefixIcon: icon,
            suffixIcon: labelTag == "Password"
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hidden = !hidden;
                      });
                    },
                    icon: hidden == true
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  )
                : null,
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            labelText: labelTag,
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[400], width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3),
              ),
            ),
          ),
        ));
  }
}

class CodeFields extends StatefulWidget {
  final String labelTag;
  final TextEditingController ctr;
  final TextInputType textInputType;

  CodeFields(this.labelTag, this.textInputType, this.ctr);

  @override
  _CodeFieldsState createState() =>
      _CodeFieldsState(this.labelTag, this.textInputType, this.ctr);
}

class _CodeFieldsState extends State<CodeFields> {
  final String labelTag;
  final TextEditingController ctr;
  final TextInputType textInputType;

  _CodeFieldsState(this.labelTag, this.textInputType, this.ctr);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextField(
      style: TextStyle(fontSize: 17),
      maxLines: labelTag == 'Description(optional)' ? null : 1,
      autofocus: true,
      controller: ctr,
      keyboardType: textInputType,
      textInputAction: labelTag == "Roll number"
          ? TextInputAction.next
          : TextInputAction.done,
      onEditingComplete: labelTag == "Roll number"
          ? () => FocusScope.of(context).nextFocus()
          : () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        labelText: labelTag,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[400], width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200], width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
        ),
      ),
    ));
  }
}

// ignore: camel_case_types
class button extends StatefulWidget {
  final String buttonText;
  final Function onPress;
  final double tsize;

  button(this.buttonText, this.tsize, this.onPress);

  @override
  _buttonState createState() =>
      _buttonState(this.buttonText, this.tsize, this.onPress);
}

// ignore: camel_case_types
class _buttonState extends State<button> {
  final String buttonText;
  final Function onPress;
  final double tsize;

  _buttonState(this.buttonText, this.tsize, this.onPress);

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
        padding: EdgeInsets.only(top: 5, bottom: 5),
        onPressed: onPress,
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

class DropDown extends StatelessWidget {
  final String value;
  final Function onChanged;
  final List list;

  DropDown({this.value, this.list, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        onChanged: onChanged,
        items: list,
      ),
    );
  }
}

class buttonExp extends StatelessWidget {
  final String label;
  final Function onPressed;

  buttonExp({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: mainColor),
        child: FlatButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class OK extends StatelessWidget {
  final Function onPressed;

  OK({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(
        'OK',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

// ignore: camel_case_types
class appName extends StatelessWidget {
  final double fontSize;
  final Color color;

  appName({this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Clarsi',
      style: TextStyle(
        fontFamily: 'Pacifico',
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

class errorMessage extends StatelessWidget {
  final String errorText;

  errorMessage(this.errorText);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(
        Icons.error,
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Text(
          errorText,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ]);
  }
}
