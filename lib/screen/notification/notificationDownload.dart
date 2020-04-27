import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/notificationDetailService.dart';
import 'package:sajiloschool/utils/api.dart';
//import 'dart:io' as io;
//import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:open_file/open_file.dart';
class NotificationDownload extends StatefulWidget {
  @override
  _NotificationDownloadState createState() => _NotificationDownloadState();
}

class _NotificationDownloadState extends State<NotificationDownload> {
  Future<NotificationDataDetail> futureAlbum;
  bool downloadProcess = false;
  bool downloadComplete = false;
  String progressString = 'Loading...';
  var progressValue = 0.0;
  var dir;
//  String fileOpenPath;
  String fileSaveLocation = '/storage/emulated/0/sajiloSchool';


 void downloadFile(urlPath) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId = prefs.getInt('schoolId');
    String url = '${Urls.BASE_API_URL}/login/getfile?schoolid=$schoolId&filepath=$urlPath';
    var dio = new Dio();
    dir = await getExternalStorageDirectory();
    print('this is $dir');
    var tt = url.split('/');
    var count=tt.length;
    var string = tt[count-1];
    var filename= string.split('_');
    var fileCount= filename.length;
    var finalFileName= filename[fileCount-1];
    print('$url');
    setState(() {
      downloadProcess = true;
    });
//    Timer(Duration(milliseconds: 300), ()async
//    {
      await dio.download(url, '$fileSaveLocation/$finalFileName',
          onReceiveProgress: (rec , total) {
            setState(() {
              progressValue = (rec / total);
              progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
            });
            if((rec / total) * 100 == 100) {
              Timer(Duration(milliseconds: 400), () {
                setState(() {
                  downloadProcess = false;
                  downloadComplete = true;
                });
              });
            }
//    });
//         openFile();


    });
  }
  openFile() async {
    await OpenFile.open(fileSaveLocation);
  }

  @override
  Widget build(BuildContext context) {
    futureAlbum = fetchAlbum();
    return AlertDialog(
        backgroundColor: Color(0xfffbf9e7),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        content: Container(
          height: 320,
          padding: EdgeInsets.all(10),
          child: FutureBuilder<NotificationDataDetail>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Expanded(child: Column(
                        children: <Widget>[
                          SizedBox(height: 4,),
                          Text(snapshot.data.caption,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.black12,
                              offset: Offset(1.0, 1.0),
                            ),
                          ]),),
                          Divider(),
                          Text(snapshot.data.description,style: TextStyle(fontSize: 14),),
                          SizedBox(height: 15,),
                        ],
                      )),
                      downloadProcess ? Container(
                          height: 40,
//                          color: Colors.green,
                          child: Column(
                            children: <Widget>[
                              LinearProgressIndicator(
                                  value: progressValue,
                                  backgroundColor: Colors.black26,
                                ),
                              SizedBox(height: 4,),
                              Text('Download $progressString',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic
                              ),)

                            ],
                          )): Text(''),
                      downloadComplete ? Container(
                        height: 38,
                        child: snapshot.data.fileLocation != null ? Material(
                          color: Color(0x000000),
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
//                              downloadFile(snapshot.data.fileLocation);
                              openFile();
                            },
                            child: Padding(padding: EdgeInsets.fromLTRB(14,0,14,0),
                              child:  Align( alignment: Alignment.center,
                                child: Text('Open Completed File',style: TextStyle(color: Colors.white,fontSize: 14,shadows: [
                                  Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.black26,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ]

                                ),),
                              ),),
                          ),
                        ) : Text(''),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)
                          ),
                          color: Colors.green.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(1.0,3.0),
                            )
                          ],
                        ),):Container(
                        height: 38,
                        child: snapshot.data.fileLocation != null ? Material(
                          color: Color(0x000000),
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              downloadFile(snapshot.data.fileLocation);
                            },
                            child: Padding(padding: EdgeInsets.fromLTRB(14,0,14,0),
                              child:  Align( alignment: Alignment.center,
                                child: Text('Download File',style: TextStyle(color: Colors.white,fontSize: 14,shadows: [
                                  Shadow(
                                    blurRadius: 4.0,
                                    color: Colors.black26,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ]

                                ),),
                              ),),
                          ),
                        ) : Text(''),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10)
                          ),
                          color: Colors.orange.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(1.0,3.0),
                            )
                          ],
                        ),),
                      SizedBox(height: 10,),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return Loader();

              }),
        )
    );
  }
}

