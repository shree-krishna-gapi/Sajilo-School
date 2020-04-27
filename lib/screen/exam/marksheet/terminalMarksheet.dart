import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'services.dart';
class TerminalMarksheet extends StatefulWidget {
  @override
  _TerminalMarksheetState createState() => _TerminalMarksheetState();
}

class _TerminalMarksheetState extends State<TerminalMarksheet> {

  Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: Color(0x000000),
      body: InkWell( onTap: () {
        Navigator.of(context).pop();
      },
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xfffbf9e7),
              ),
              height: 450,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)
                        ),
                        gradient: purpleGradient
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,11,10,4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(child: RoutinHead(head:'SN'),flex: 2,),
                              Expanded(child: RoutinHead(head:' Subject'),flex: 6),
                              Expanded(child: RoutinHead(head:'F. M.'),flex: 3,),
                              Expanded(child: RoutinHead(head:'P. M.'),flex: 3,),
                              Expanded(child: RoutinHead(head:'  O. M.'),flex: 3,),

                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  Container( height: 200,
                    child: FutureBuilder<List<AcademicMarksheetData>>(
                        future: FetchMarksheet(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);

                          return snapshot.hasData ?
                          ListView.builder(
                              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                              itemBuilder: (context, index) {
                                return FadeAnimation(
                                  0.2, Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(child: Text('   ${index+1}'),flex: 2,),
                                        Expanded(child: Text('   ${snapshot.data[index].subjectName}'),flex: 6,),
                                        Expanded(child: Text('${snapshot.data[index].fullMarks}'),flex: 3,),
                                        Expanded(child: Text('${snapshot.data[index].passMarks}'),flex: 3,),
                                        Expanded(child: Text('${snapshot.data[index].obtainedMarks}'),flex: 3,),

                                      ],
                                    ),
                                  ),
                                );
                              }):Loader(); }),
                  ),







                  FutureBuilder<Album>(
                  future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FadeAnimation(
                          1.2, Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text(''),flex: 2,),
                                  Expanded(child: Text('Total',style: TextStyle(fontWeight: FontWeight.w600),),flex: 6,),
                                  Expanded(child: Text('-'),flex: 3,),
                                  Expanded(child: Text('-'),flex: 3,),
                                  Expanded(child: Text('${snapshot.data.obtainedMarks}',
                                      style: TextStyle(fontWeight: FontWeight.w600)),flex: 3,),
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text(''),flex: 2,),
                                  Expanded(child: Text('Percentage',style: TextStyle(fontWeight: FontWeight.w600),),flex: 6,),

                                  Expanded(child: Text(''),flex: 3,),
                                  Expanded(child: Text('-'),flex: 3,),
                                  Expanded(child: Text('${snapshot.data.percentage}%',
                                      style: TextStyle(fontWeight: FontWeight.w600)),flex: 3,),
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                children: <Widget>[
                                  Expanded(child: Text(''),flex: 2,),
                                  Expanded(child: Text('GPA ',style: TextStyle(fontWeight: FontWeight.w600),),flex: 6,),
                                  Expanded(child: Text('${snapshot.data.gpa}',style: TextStyle(fontWeight: FontWeight.w600)),flex: 3,),
                                  Expanded(child: Text('Grade',style: TextStyle(fontWeight: FontWeight.w600)),flex: 3,),
                                  Expanded(child: Text('${snapshot.data.grades}',style: TextStyle(fontWeight: FontWeight.w600)),flex: 3,),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return Text('');
                    },

                  )


                ],
              ),

            ),


          ),
        ),
      ),
    );
  }

}


class RoutinTxtBody extends StatelessWidget {
  RoutinTxtBody({this.Btitle});
  String Btitle;
  @override
  Widget build(BuildContext context) {
    return Container(
//        color: Colors.orange[100].withOpacity(0.4),
        child: Padding(padding: EdgeInsets.fromLTRB(0,4,0,4),
            child: Text(Btitle,
              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
            )
        )
    );
  }
}
class RoutinBtnTitle extends StatelessWidget {
  final String head;
  RoutinBtnTitle({this.head});

  @override
  Widget build(BuildContext context) {
    return Container(
//        color: Colors.orange[100].withOpacity(0.4),
        child: Padding(padding: EdgeInsets.fromLTRB(0,4,0,4),
            child: Text(head,
              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
            )
        )
    );
  }
}
class RoutinHead extends StatelessWidget {
  final String head;
  RoutinHead({this.head});

  @override
  Widget build(BuildContext context) {
    return Text(head,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.4,
      ),);
  }
}
class RoutinText extends StatelessWidget {
  final String head;
  RoutinText({this.head});

  @override
  Widget build(BuildContext context) {
    return Text(head,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.4,
      ),);
  }
}

class RoutinTxt extends StatelessWidget {
  RoutinTxt({this.head});
  String head;
  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.orange[100].withOpacity(0.4),
        child: Padding(padding: EdgeInsets.fromLTRB(0,4,0,4),
            child: Text(head,
              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
            )
        )
    );
  }
}




class Hr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Align(alignment: Alignment.centerLeft, child:Container(color: Colors.black12, height: 24, width: 1,)),
    );
  }
}
