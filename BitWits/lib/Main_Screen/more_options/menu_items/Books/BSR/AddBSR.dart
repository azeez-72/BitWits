import 'dart:math';

import 'package:bitwitsapp/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBSR extends StatefulWidget {
  static final String id = 'add_bsr';

  @override
  _AddBSRState createState() => _AddBSRState();
}

class _AddBSRState extends State<AddBSR> {
  TextEditingController _descController = TextEditingController();
  String _phoneNo;
  final _storeRef = FirebaseStorage.instance.ref().child('booksImages');
  final _auth = FirebaseAuth.instance;

  _getPhoneNo() async {
    await _auth.currentUser().then((user) {
      setState(() => _phoneNo = user.phoneNumber);
    });
  }

  @override
  void initState(){
    _getPhoneNo();
    super.initState();
  }

  List<File> _imageFiles = [];

  _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source,imageQuality: 10);
    setState(() => _imageFiles.add(File(pickedFile.path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Add a request',style: TextStyle(color: Colors.white),),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100,
              child: ListView.separated(
                separatorBuilder: (context,index) => SizedBox(width: 5),
                itemCount: _imageFiles.length + 1,
                itemBuilder: (context,index) {
                  return index == 0 ? ButtonTheme(
                    minWidth: 100,
                    height: 100,
                    child: FlatButton(
                      color: Colors.grey[200],
                      child: Icon(Icons.add_a_photo,color: Colors.grey),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        showDialog(context: context,builder: (context) => ImageChooseDialog(
                          camera: () async {
                            Navigator.pop(context);
                            await _pickImage(ImageSource.camera);
                          },                  
                          gallery: () async {
                            Navigator.pop(context);
                            await _pickImage(ImageSource.gallery);
                          },
                        ));
                      },
                    ),
                  ) : Container(
                      width: 100,
                      child: GestureDetector(
                        onTap: () => showDialog(context: context,builder: (context) =>
                          AlertDialog(
                            content: Image(image: FileImage(_imageFiles[index - 1])),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  setState(() => _imageFiles.remove(_imageFiles[index - 1]));
                                  Navigator.pop(context);
                                }, child: Text('REMOVE',style: TextStyle(color: Colors.red[800]))
                              ),
                              FlatButton(onPressed: () => Navigator.pop(context), child: Text('OK',style: TextStyle(color: mainColor)))
                            ],
                          )
                        ),
                        child: Dismissible(
                          key: ValueKey(_imageFiles[index - 1]),
                          direction: DismissDirection.vertical,
                          onDismissed: (direction) => setState(() => _imageFiles.remove(_imageFiles[index - 1])),
                          child: Image(
                            image: FileImage(_imageFiles[index - 1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(height: 20),
            CodeFields('Description(optional)', TextInputType.text, _descController),
            SizedBox(height: 20),
            button('ADD REQUEST', 18,
              () {
                if(_imageFiles.length != 0 )
                for(int i=0 ; i<_imageFiles.length ; i++){
                  try{
                    _storeRef.child(_phoneNo).putFile(_imageFiles[i]); 
                  } catch(e){print(e);}
                } 
              }
            )
          ],
        )
      ),
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
      title: Text('Choose an option'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton.icon(
            onPressed: camera,
            icon: Icon(Icons.camera), label: Text('Camera'),
          ),
          SizedBox(height: 10),
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