import 'package:bitwitsapp/Main_Screen/more_options/menu_items/Books/books_tab.dart';
import 'package:bitwitsapp/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';

List<String> subjects = [];

class AddBSR extends StatefulWidget {
  static final String id = 'add_bsr';

  @override
  _AddBSRState createState() => _AddBSRState();
}

class _AddBSRState extends State<AddBSR> {
  TextEditingController _descController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String _phoneNo,_currentYear = '...',_previousYear = '...',year;
  final _storeRef = FirebaseStorage.instance.ref().child('booksImages');
  final _auth = FirebaseAuth.instance;
  bool _y1 = true,_y2 = false,showSpinner = false;
  int imageLimit = 3,yr = 1;
  List<String> _books = [];

  _getPhoneNo() async {
    await _auth.currentUser().then((user) => setState(() => _phoneNo = user.phoneNumber));
    await _getSellerYear();
  }

  _getSellerYear() async {
    await Firestore.instance.collection('BooksSellIDs').document(_phoneNo).get()
      .then((value) => setState(() {
        _currentYear = value.data['Year'];
        year = _currentYear;
        yr = int.parse(year);
        yr--;
      })
    );

    switch (_currentYear) {
      case '1':
        _currentYear = 'FY';
        _previousYear ='NA';
        break;
      case '2':
        _currentYear = 'SY';
        _previousYear = 'FY';
        break;
      case '3':
        _currentYear = 'TY';
        _previousYear = 'SY';
        break;
      case '4':
        _currentYear = 'Final';
        _previousYear = 'TY';
        break;
      default:
        _currentYear = 'loading';
        _previousYear = 'loading';
    }
  }

  _getRules() async {
    await Firestore.instance.collection('Books').document('Limits')
      .get().then((value){
        setState((){
          imageLimit = value.data['img limit'];
        });
      });
  }

  _getSubjects() async {
    await Firestore.instance.collection('Books').document('Year$yr subjects').get()
      .then((value){
        value.data.forEach((key, value) {
          setState(() => subjects.add(key));
        });
      });
  }

  addBookToList(String subject,String bookName) => setState(() => _books.add('$subject - $bookName'));

  @override
  void initState(){
    super.initState();
    _getPhoneNo();
    _getRules();
    _getSubjects();
  }

  List<File> _imageFiles = [];
  List<String> _imageURLs = [];

  _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source,imageQuality: 10); //play with quality
    setState(() => _imageFiles.add(File(pickedFile.path)));
  }

  Future<void> _uploadRequest() async {
    if(_imageFiles.length != 0 ){
      final int _sellId = DateTime.now().millisecondsSinceEpoch;
      for(int i=0 ; i<_imageFiles.length ; i++){
        try{
          await _storeRef.child(_phoneNo).child(_sellId.toString()).child('image${i+1}.png')
                .putFile(_imageFiles[i]).onComplete;
          var url = await _storeRef.child(_phoneNo).child(_sellId.toString()).child('image${i+1}.png').getDownloadURL();
          setState(() => _imageURLs.add(url.toString()));                      
        } catch(e){print(e);}
      }
      await Firestore.instance.collection('BooksSellRequests').document(_sellId.toString())
            .setData({
              'image links': _imageURLs,
              'Description': _descController.text,
              'Seller id': _phoneNo,
              if (_previousYear != 'NA') 'Visible to $_previousYear': _y1,
              'Visible to $_currentYear': _y2,
              'Price': int.parse(_priceController.text)
             });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('Add a request',style: TextStyle(color: Colors.white),),
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              AddBookButton(
                onPressed: () => showDialog(context: context,builder: (context) => AddBookDialog(
                  onAdded: addBookToList,
                )),
              ),
              if(_books.length > 0)
              ListView.separated(
                itemCount: _books.length,
                separatorBuilder: (context,index) => SizedBox(height: 3),
                itemBuilder: (context,index) =>
                  ListTile(
                    title: Flexible(child: Text(_books[index],overflow: TextOverflow.ellipsis)),
                    trailing: IconButton(icon: Icon(Icons.delete,color: Colors.red),
                      onPressed: () => setState(() => _books.removeAt(index))), 
                  )
              ),
              SizedBox(height: 20),
              Container(
                height: 100,
                //here edited width from double.infinity to none
                child: ListView.separated(
                  separatorBuilder: (context,index) => SizedBox(width: 5),
                  itemCount: _imageFiles.length + 1,
                  itemBuilder: (context,index) {
                    return index == 0 ? ButtonTheme(
                      minWidth: 100,
                      height: 100,
                      child: FlatButton(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            const Icon(Icons.add_a_photo,color: Colors.grey),
                            const Text('Tap to add an image',style: TextStyle(color: Colors.grey,fontSize: 10))
                          ]
                        ),
                        onPressed: () async {
                          if(_imageFiles.length > (imageLimit - 1)){    //set limit
                            Flushbar(
                              backgroundColor: Colors.red,
                              messageText: Text('Max limit reached($imageLimit images)',style: TextStyle(color: Colors.white),),
                              duration: Duration(seconds: 2),
                            )..show(context);
                            return;
                          }
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
                          child: SlideToRemove(
                            imageFile: _imageFiles[index - 1],
                            onRemoved: (direction) => setState(() => _imageFiles.remove(_imageFiles[index - 1])),
                          ),
                        )
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              if(_imageFiles.length != 0) SizedBox(height: 4),
              if(_imageFiles.length != 0) const Text('(Images may take time to appear)',style: TextStyle(color: Colors.blueGrey,fontSize: 12)),
              SizedBox(height: 20),
              CodeFields('Description(optional)', TextInputType.multiline, _descController),
              SizedBox(height: 15),
              Row(
                children: [
                  Text('Visiblity :',style: TextStyle(color: mainColor,fontSize: 18)),
                  _previousYear != 'NA' ? 
                    Checkbox(
                      activeColor: mainColor,
                      value: _y1,
                      onChanged: (value) => setState(() => _y1 = value)
                    ) : null,
                    _previousYear != 'NA' ? Text(_previousYear) : null,
                    _previousYear != 'NA' ? SizedBox(width: 20) : null,
                  Checkbox(
                    activeColor: mainColor,
                    value: _y2,
                    onChanged: (value) => setState(() => _y2 = value)
                  ),
                  Text('SY')
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Flexible(flex: 1,child: PriceField(priceController: _priceController)),
                  SizedBox(width: 10,),
                  Flexible(
                    flex: 1,
                    child: const Text('(We recommend an optimal pricing to allot your book(s) a higher preference in our list).',
                      style: TextStyle(color: Colors.blueGrey,fontSize: 12,height: 1.3),
                    ),
                  )
                ]
              ),
              SizedBox(height: 10),
              button('ADD REQUEST', 18, () async {
                if(_priceController.text == ''){
                  Flushbar(
                    icon: errorIcon,
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    messageText: const Text('Price cannot be empty',style: TextStyle(color: Colors.white)),
                  )..show(context);
                  return;
                }
                if(_y1 || _y2) {
                  setState(() => showSpinner = true);
                  await _uploadRequest();
                  Navigator.popAndPushNamed(context, BooksTab.id);
                }
                else Flushbar(
                  icon: errorIcon,
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.red,
                  messageText: const Text('Visibility cannot be empty',style: TextStyle(color: Colors.white)),
                )..show(context);
              }),
            ],
          )
        ),
      ),
    );
  }
}


            // Row(
            //   children: [
            //     Text('Category :',style: TextStyle(color: mainColor,fontSize: 18)),
            //     Radio(
            //       activeColor: mainColor,
            //       // title: Text('Semester'),
            //       value: 1,
            //       groupValue: _categoryGroupValue,
            //       onChanged: (value) => setState(() => _categoryGroupValue = value)
            //     ),
            //     Text('Semester'),
            //     SizedBox(width: 20),
            //     Radio(
            //       activeColor: mainColor,
            //       // title: Text('General'),
            //       value: 2,
            //       groupValue: _categoryGroupValue,
            //       onChanged: (value) => setState(() => _categoryGroupValue = value)
            //     ),
            //     Text('General'),
            //   ],
            // ),
            // SizedBox(height: 10),