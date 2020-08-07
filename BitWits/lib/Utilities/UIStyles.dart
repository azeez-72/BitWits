import 'dart:io';
import '../Main_Screen/more_options/menu_items/Books/BSR/AddBSR.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
          initialValue: labelTag == 'Phone Number' ? '+91' : '',
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
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            labelText: labelTag,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200], width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[400], width: 1.5),
            ),
            border: const OutlineInputBorder(
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
      style: const TextStyle(fontSize: 17),
      maxLines: labelTag == 'Description(optional)' ? null : 1,
      autofocus: labelTag == 'Description(optional)' ? false : true,
      controller: ctr,
      keyboardType: textInputType,
      textInputAction: labelTag == "Roll number"
          ? TextInputAction.next
          : TextInputAction.done,
      onEditingComplete: labelTag == "Roll number"
          ? () => FocusScope.of(context).nextFocus()
          : () => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        errorBorder: const OutlineInputBorder(
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
        border: const OutlineInputBorder(
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


class ImageSlides extends StatelessWidget {
  final List<dynamic> images;

  ImageSlides({this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Carousel(
        autoplay: false,
        dotColor: Colors.white,
        dotBgColor: Colors.grey[300].withOpacity(0.5),
        indicatorBgPadding: 10.0,
        dotSize: 6.0,
        dotIncreasedColor: mainColor,
        images: images
      ),
    );
  }
}


class AddBookDialog extends StatefulWidget {
  final void Function(String subject,String bookName) onAdded;

  AddBookDialog({this.onAdded});

  @override
  _AddBookDialogState createState() => _AddBookDialogState();
}


//dialog
class _AddBookDialogState extends State<AddBookDialog> {

  final _formKey = GlobalKey<FormState>();
  String subjectChosen;
  String _bookName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a book',style: const TextStyle(color: mainColor),),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormField<String>(
              autovalidate: true,
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: textInputDecoration("Subject"),
                  isEmpty: subjectChosen == '', //
                  child: DropDown(
                  value: subjectChosen,
                    list: subjects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      subjectChosen = newValue;
                      state.didChange(newValue);
                    });
                  },
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            TextFields(
              'Name of the book',
              TextInputType.text,
              Icon(Icons.book),
              (String value){
                if(value.isEmpty) return 'Enter the name of the book';
                return null;
              },
              (String value) => _bookName = value
            )
          ],
        ),
      ),
      actions: [
        FlatButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL',style: const TextStyle(color: Colors.grey))),
        FlatButton(onPressed: (){
          if(_formKey.currentState.validate()) _formKey.currentState.save();
          widget.onAdded(subjectChosen,_bookName);
          Navigator.pop(context);
        }, child: const Text('ADD',style: const TextStyle(color: mainColor,fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class AddBookButton extends StatelessWidget {
  final Function onPressed;

  AddBookButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(50)
      ),
      alignment: Alignment.center,
      child: FlatButton.icon(
        onPressed: onPressed,
        icon: SvgPicture.asset('svgs/stack_of_books.svg',width: 24,color: mainColor),
        label: const Text('ADD BOOKS',style: const TextStyle(
          color: mainColor,
          fontSize: 20
        ))
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
            style: const TextStyle(color: Colors.white, fontSize: 18),
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
      child: const Text(
        'OK',
        style: const TextStyle(color: Colors.blue),
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
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: Text(
          errorText,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    ]);
  }
}

class PinField extends StatelessWidget {
  final Function onChanged;

  PinField({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      autoFocus: true,
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        fieldWidth: 30,
        fieldHeight: 50,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      // errorAnimationController: errorController,
      // controller: _otpController,
      onCompleted: (v) {
        print("Completed");
      },
      onChanged: onChanged,
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}

class ImageChooseDialog extends StatelessWidget {
  final Function gallery;
  final Function camera;

  ImageChooseDialog({this.gallery,this.camera});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose an option'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton.icon(
            onPressed: camera,
            icon: Icon(Icons.camera), label: Text('Camera'),
          ),
          const SizedBox(height: 10),
          FlatButton.icon(
            onPressed: gallery,
            icon: Icon(Icons.image),
            label: Text('Gallery'),
          )
        ],
      ),
    );
  }
}

class SlideToRemove extends StatelessWidget {
  final File imageFile;
  // _imageFiles[index - 1]
  final Function onRemoved;
  // (direction) => setState(() => _imageFiles.remove(_imageFiles[index - 1]))

  SlideToRemove({this.imageFile,this.onRemoved});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(imageFile),
      direction: DismissDirection.vertical,
      onDismissed: onRemoved,
      child: Image(
        image: FileImage(imageFile),
        fit: BoxFit.cover,
      ),
    );
  }
}

class PriceField extends StatelessWidget {
  final TextEditingController priceController;

  PriceField({this.priceController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 4,
      controller: priceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Column(mainAxisAlignment: MainAxisAlignment.center,children: [const Text('₹',style: TextStyle(fontSize: 18),)]),
        labelText: 'Price',
        labelStyle: const TextStyle(fontSize: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[400], width: 1.5),
        ),
      ),
    );
  }
}