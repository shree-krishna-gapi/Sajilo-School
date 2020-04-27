import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'service.dart';
class Routine extends StatefulWidget {
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  double fm = 0.0;
  double totalFm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x000000),
      body: InkWell( onTap: (){Navigator.of(context).pop();},
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
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(child: RoutinHead(head:'SN'),flex: 1,),
                              Expanded(child: RoutinHead(head:'Date'),flex: 3,),
                              Expanded(child: RoutinHead(head:'  Subject'),flex: 4),

                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  Container( height: 300,
                    child: FutureBuilder<List<AcademicMarksheetData>>(
                        future: FetchGetPeriodExamMarks(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);

                          return snapshot.hasData ?
                          ListView.builder(
                              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(child: Text('   ${index+1}'),flex: 1,),
                                      Expanded(child: Text('${snapshot.data[index].examDateNepali}'),flex: 3,),
                                      Expanded(child: Text('  ${snapshot.data[index].subjectName}'),flex: 4,),


                                    ],
                                  ),
                                );
                              }):Loader(); }),
                  ),



                ],
              ),

            ),


          ),
        ),
      ),
    );
  }
  test(int i,int n,double z) {
    fm = fm+n;
    if(i==z) {
      Timer(Duration(milliseconds: 500), (){
        setState(() {
          totalFm = fm;
        });
      });
    }


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
