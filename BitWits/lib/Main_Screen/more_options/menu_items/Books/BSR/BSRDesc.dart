import 'package:bitwitsapp/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:contacts_service/contacts_service.dart';

class BSRinfo extends StatefulWidget {
  final String sellerId;
  final List imageURLs;
  final String desc;

  BSRinfo({this.sellerId,this.imageURLs,this.desc});

  @override
  _BSRinfoState createState() => _BSRinfoState();
}

class _BSRinfoState extends State<BSRinfo> {
  var collectionRef = Firestore.instance.collection('BooksSellIDs');
  String name = '',branch = '';

  Future<void> getNameBranch() async {
    await collectionRef.document(widget.sellerId).get().then((value){
      setState((){
        name = value.data['Name'];
        branch = value.data['Branch'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNameBranch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(bottom: 10),
          children: [
            ImageSlides(images: widget.imageURLs),
            SizedBox(height: 10),
            ListTile(
              trailing: IconButton(icon: Icon(Icons.phone,color: mainColor), onPressed: () => launch('tel://${widget.sellerId}')),
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
              subtitle: Text(
                name == '' || branch == '' ? 'Loading...' : '$name,$branch',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
              title: SelectableText(
                widget.sellerId,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                  text: widget.desc,
                  style: TextStyle(
                    color: Colors.grey[800],
                    wordSpacing: 1,
                    height: 1.2
                  )
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              child: FlatButton.icon(
                icon: const Icon(Icons.thumb_down,color: Colors.red),
                label: const Text('REPORT',style: TextStyle(color: Colors.red)),
                onPressed: (){
                  //add report
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}