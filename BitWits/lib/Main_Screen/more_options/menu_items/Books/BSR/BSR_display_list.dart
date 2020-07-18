import 'package:bitwitsapp/Classroom/Data.dart';
import 'package:bitwitsapp/Utilities/constants.dart';
import 'package:bitwitsapp/Utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class BSRdisplay extends StatefulWidget {
  @override
  _BSRdisplayState createState() => _BSRdisplayState();
}

class _BSRdisplayState extends State<BSRdisplay> {

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context,data,child){
        return Scrollbar(
          child: StreamBuilder(
            stream: Firestore.instance.collection('BooksSellRequests')
              .orderBy('Price')
              .where('Visible to ${data.getYearAbbreviation()}',isEqualTo: true).snapshots(),
            builder: (context,dataSnapShot){
              if(dataSnapShot.connectionState == ConnectionState.waiting) return LoadingScreen();
              final reqDocs = dataSnapShot.data.documents;
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                separatorBuilder: (context,index) => SizedBox(height: 10),
                itemCount: reqDocs.length,
                itemBuilder: (context,index) => Container(
                  decoration: booksListDecoration,
                  child: ListTile(
                    onTap: (){
                      print(reqDocs[index]['image links'].length);
                    },
                    isThreeLine: true,
                    title: Row(
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text('7'),
                        SizedBox(width: 3),
                        SvgPicture.asset('svgs/stack_of_books.svg',width: 15,color: mainColor),
                        SizedBox(width: 10),
                        Flexible(
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(text: 'Kumbhojkar-I,Kumbhojkar-II,Jain and Jain,Chemistry and physcs',
                            style: TextStyle(color: Colors.black,fontSize: 16)
                            ),
                          )
                        ),
                      ],
                    ),
                    subtitle:  Container(
                      height: 80,
                      width: double.infinity,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context,iindex) => SizedBox(width: 2),
                        itemCount: reqDocs[index]['image links'].length,
                        itemBuilder: (context,iindex){
                          return Container(
                            width: 80,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'images/loading.png',
                              image: reqDocs[index]['image links'][iindex],
                              fit: BoxFit.cover,
                            )
                          );
                        },
                      ),
                    ),
                    trailing: Text('₹${reqDocs[index]['Price'].toString()}',style: TextStyle(color: Colors.grey[850],fontSize: 20))
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}