import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'service/notificationBoardService.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'notificationDownload.dart';
import 'noticeDownload.dart';
class NotificationBoard extends StatefulWidget {
  @override
  _NotificationBoardState createState() => _NotificationBoardState();
}

class _NotificationBoardState extends State<NotificationBoard> {
  @override
  void initState() {
    this.getNotice();
  }
  getNotice() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
          child:FutureBuilder<List<NotificationData>>(
              future: fetchNotification(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError);
                if(snapshot.hasData) {
                  return snapshot.data.length > 0 ?
                  ListView.builder(
                      itemCount: (snapshot.data == null && snapshot.data.length==0) ? 0 : snapshot.data.length,
                      itemBuilder: (context, index) {
//                        return _create1(context, '${index+1}',snapshot.data[index].publishDateNepali,snapshot.data[index].description,'${snapshot.data[index].caption}');
                        return _create(context,'${index+1}',
                            '${snapshot.data[index].id}',
                            '${snapshot.data[index].contentTypeId}',
                            '${snapshot.data[index].caption}',
                            '${snapshot.data[index].description}',
//                            '${snapshot.data[index].isPublish}',
                            '${snapshot.data[index].publishDateNepali}'
                        );
                      }
                  ) :
                  Align(
                      alignment: Alignment.center,
                      child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                        letterSpacing: 0.4,),)
                  );
                } else {
                  return Loader();
                }
              }),

      ),
    );
  }

  Column _create(BuildContext context, String sn,String id, String contentTypeId,
     String caption, String description, String publishDateNepali) {
    return Column(
      children: <Widget>[
        FadeAnimation(
          0.5, InkWell( onTap: ()async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('noticeId', id);
//            notificationDetail();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Download(
              caption: caption,
                description: description,
              publishDate : publishDateNepali
            )),
          );

          },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(

                width: double.infinity,
                child: Card(
                  elevation: 4,
                  color: Color(0x000000),
                  child: Container(
                    decoration: BoxDecoration(
//                      gradient: lightGradient,
                        color: Color(0xfffbf9e7),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,10,10,10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                             Container(
                              child: Text('$sn.  ',
                                style: TextStyle(fontSize: 15,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black.withOpacity(0.05),
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ]
                                ),),
                            ),
                          Expanded( flex: 13,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(caption , //publishDateNepali,
                                  style: TextStyle(fontSize: 15,
                                    letterSpacing: 0.2,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 3.0,
                                          color: Colors.black.withOpacity(0.05),
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ]
                                  ),),
                                Align( alignment: Alignment.bottomRight,
                                  child: Text(publishDateNepali , //,
                                    style: TextStyle(fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 3.0,
                                            color: Colors.black.withOpacity(0.05),
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ]
                                    ),),
                                ),
                              ],
                            ),
                          ),

                        ],
                      )
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

    ],
    );
  }
// downloadFile() async {
//    Dio dio = Dio();
//    print("Download dfd");
//    try {
//      var dir = await getApplicationDocumentsDirectory();
//
//      await dio.download(imgUrl, "${dir.path}/myimage.jpg",
//          onProgress: (rec, total) {
//            print("Rec: $rec , Total: $total");
//            setState(() {
//              downloading = true;
//              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
//            });
//          });
//    } catch (e) {
//      print(e);
//    }
//
//    setState(() {
//      downloading = false;
//      progressString = "Completed";
//    });
//    print("Download completed");
//  }

//  Future<NotificationDataDetail> futureAlbum;
  notificationDetail(){

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return NotificationDownload();
        }
    );
  }
}