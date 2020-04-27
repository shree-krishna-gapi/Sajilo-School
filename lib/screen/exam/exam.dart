import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sajiloschool/screen/exam/annualExam/annualExam.dart';
import 'package:sajiloschool/screen/exam/marksheet/terminalMarksheet.dart';
import 'package:sajiloschool/screen/notification/notificationBoard.dart';
import '../../utils/sideBar.dart';
import '../../utils/pallate.dart';
import 'pages/modal.dart';
import 'package:http/http.dart' as http;
import 'service/academicPeriod.dart';
import '../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/fadeAnimation.dart';
import 'package:sajiloschool/global/service/offlineYear.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:school/test.dart';

import 'package:fluttertoast/fluttertoast.dart';
class Exam extends StatefulWidget {

  @override
  _ExamState createState() => _ExamState();
}
class _ExamState extends State<Exam> {
  DateTime backPressTime;
  bool loader;
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backPressTime == null ||
        currentTime.difference(backPressTime) > Duration(seconds: 3);
    if (backButton) {
      backPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Tap to Exit App",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop : onWillPop,
          child: Stack(
            children: <Widget>[
              BodySection(),
              Positioned(child: InkWell(onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationBoard()), //StudentAttendance NotificationBoard
                );
                }
                ,child: Icon(Icons.notifications,size: 22,color: Colors.orange[700],)),
                top: 40, right: 20,
              ),
              Positioned(child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(14)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 3.0, // has the effect of softening the shadow
                        spreadRadius: 2.0, // has the effect of extending the shadow
                        offset: Offset(
                          3.0, // horizontal, move right 10
                          3.0, // vertical, move down 10
                        ),
                      )
                    ],
                    color: Colors.orange[500].withOpacity(0.8)
                ),
                child: Container(  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(14)
                    ),
                    color: Colors.orange[500].withOpacity(0.8)
                ),
                    child: InkWell(splashColor: Colors.deepPurpleAccent,child: Padding(
                      padding: const EdgeInsets.fromLTRB(13,8,13,8),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.bookmark,color: Colors.white, size: 18,),
                          Text(' Annual Marks',style: TextStyle(
                            color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600,
                            shadows: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2.0, // has the effect of softening the shadow
                                spreadRadius: 1.0, // has the effect of extending the shadow
                                offset: Offset(
                                  2.0, // horizontal, move right 10
                                  2.0, // vertical, move down 10
                                ),
                              )
                            ]
                          ),),
                        ],
                      ),
                    ),onTap: (){

                    showDialog<void>(
                        context: context,// user must tap button!
                        builder: (BuildContext context) {return AnnualExam();});

                    },)),
              ),
              bottom: 15, right: 15,),
              SideBar(),
            ],

          ),
        )
      );
  }
}

class BodySection extends StatefulWidget {
  @override
  _BodySectionState createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> {
  // logo
  int changedNowYearId;
  int selectedYearId=0;
  String selectedYear='';
  String changedNowYear;
  // Year
  bool loading;
  @override
  void initState(){
    getCurrentYear();
    super.initState();
  }

  getCurrentYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedYear = prefs.getString('educationalYearName');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 70,),
          FadeAnimation(0.4, Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Year:',style: TextStyle(fontStyle: FontStyle.italic,
                      fontSize: 15,fontWeight: FontWeight.w600),),
                  SizedBox(width: 15,),
                  InkWell(
                    onTap: (){_showDialog();},
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                selectedYear == '' ?
                                Text('yyyy',style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.8,
                                    fontSize: 14.5,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black26
                                ),):
                                Text('$selectedYear',style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic
                                ),),
                                SizedBox(width: 5,),
                                Icon(Icons.arrow_downward,size: 16,),
                              ],
                            ),
                            SizedBox(height: 3,),
                            Container(
                              height: 2,
                              width: 60,
                              decoration: BoxDecoration(
                                  gradient: purpleGradient
                              ),
                            )
                          ],
                        )

                      ],
                    ),
                  ),
                ],
              )
          ),),
          SizedBox(height: 15,),
          loadAgain ? FadeAnimation(
            0.4, Container(height: 500,
            child: FutureBuilder<List<AcademicPeriodId>>(
                future: FetchAcademicPeriodId(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError);
                  if (snapshot.hasData) {
                    return snapshot.data.length > 0 ?
                    ListView.builder(
                        itemCount: snapshot.data == null ? 0 : snapshot.data
                            .length,
                        itemBuilder: (context, index) {
                          return ColumnList(title: snapshot.data[index]
                              .academicPeriodName,
                            fromDate: snapshot.data[index].fromDateNepali,
                            toDate: snapshot.data[index].toDateNepali,
                            academicPeriodId: snapshot.data[index]
                                .academicPeriodId,

                          );
                        }
                    ) : Empty();

                  } else { return Loader();}
                }
            ),
          ),
          ): FadeAnimation(
            0.1, Container(height: 500,
            child: FutureBuilder<List<AcademicPeriodId>>(
                future: FetchAcademicPeriodId(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError);
                  if (snapshot.hasData) {
                    return snapshot.data.length > 0 ?
                    ListView.builder(
                        itemCount: snapshot.data == null ? 0 : snapshot.data
                            .length,
                        itemBuilder: (context, index) {
                          return ColumnList(title: snapshot.data[index]
                              .academicPeriodName,
                            fromDate: snapshot.data[index].fromDateNepali,
                            toDate: snapshot.data[index].toDateNepali,
                            academicPeriodId: snapshot.data[index]
                                .academicPeriodId,

                          );
                        }
                    ) : Empty();

                  } else { return Loader();}
                }
            ),
          ),
          ),

        ],
      ),
    );
  }
  Future<void> _showDialog() async {

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbf9e7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            content: Container(

              child: Container( height: 180,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,20,20,10),
                    child: FutureBuilder<List<OfflineFeeYear>>(
                      future: FetchOffline(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) ;
                        return snapshot.hasData ?
                        CupertinoPicker(
                          itemExtent: 60.0,
                          backgroundColor: Color(0x00000000),
                          onSelectedItemChanged: (index)async {

                            changedNowYear = snapshot.data[index].sYearName;
                            changedNowYearId = snapshot.data[index].educationalYearID;
                          },
                          children: new List<Widget>.generate(snapshot.data.length, (index) {
                            changedNowYear = snapshot.data[0].sYearName;
                            changedNowYearId = snapshot.data[0].educationalYearID;
                            return Align(
                              alignment: Alignment.center,//
                              child: Text(snapshot.data[index].sYearName,
                                style: TextStyle(
                                    fontSize: 17,fontWeight: FontWeight.w600, letterSpacing: 0.8,color: Colors.black
                                ),),
                            );
                          }),
                        ):Loader();
                      },
                    )
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: ()async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  int old = prefs.getInt('educationalYearId');
                  if(old != changedNowYearId) {
                    loadAgain = true;
                  }
                  setState(() {
                    selectedYear = changedNowYear;
                    selectedYearId = changedNowYearId;
                  });
                  prefs.setInt('educationalYearId',changedNowYearId);
                  Duration(milliseconds: 500);
                  Navigator.of(context).pop();

                },
              ),
            ],
            elevation: 4,
          );}
    );

  }
  bool loadAgain = true;
}
class ColumnList extends StatefulWidget {
  ColumnList({this.title,this.fromDate,this.toDate,this.exams,this.academicPeriodId});
  final String title;
  final String fromDate;
  final String toDate;
  final String exams;
  final int academicPeriodId;
  @override
  _ColumnListState createState() => _ColumnListState();
}
class _ColumnListState extends State<ColumnList> {
  Modal modal = new Modal();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 106,
              width: double.infinity,
              child: Card(
                elevation: 4,
                color: Color(0x000000),
                child: Container(
                  decoration: BoxDecoration(
//                      gradient: lightGradient,
                      color: Color(0xfffdf9f7),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,10,10,10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.title,
                          style: TextStyle(fontWeight: FontWeight.w600,
                              color: Pallate.cardtxtcolor,fontSize: 14.5,
                              fontStyle: FontStyle.italic
                          ),),
                        SizedBox(height: 8,),
                        Column(


                          children: <Widget>[
                            Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Align(child: Text('Held From  ',style: TextStyle(
                                    color: Pallate.cardtxtcolor,fontSize: 13,fontWeight: FontWeight.w600
                                ),),alignment: Alignment.topRight,),
                                Align(child: Text(widget.fromDate,style: TextStyle(
                                  color: Pallate.cardtxtcolor,fontSize: 12,
                                ),),alignment: Alignment.topRight,),
                                Align(child: Text('    To  ',style: TextStyle(
                                    color: Pallate.cardtxtcolor,fontSize: 13,fontWeight: FontWeight.w600
                                ),),alignment: Alignment.topRight,),

                                Align(child: Text(widget.toDate,style: TextStyle(
                                    color: Pallate.cardtxtcolor,fontSize: 12
                                )),alignment: Alignment.topRight,),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Align(child: Container(decoration: BoxDecoration(

                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4)
                                    )
                                ), child: Container(
                                  decoration: BoxDecoration(
                                      gradient: lightGradient,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14)
                                      )
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)
                                        ),
                                        color: Colors.orange[500].withOpacity(0.8)
                                    ),
                                    child: InkWell(
                                      onTap: ()async{
                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setInt('academicPeriodId',widget.academicPeriodId);
                                        modal.mainBottomSheet(context,widget.title,widget.academicPeriodId,widget.exams);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(11.0, 7.5, 11.0, 7.5),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.remove_red_eye,size: 13,color: Colors.white,),SizedBox(width:5),
                                            Text('View Detail',style: TextStyle(color: Colors.white,
                                                fontSize: 12
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),alignment: Alignment.topRight,),
                                SizedBox(width: 14,),
                                Align(child: Container(decoration: BoxDecoration(
                                  gradient: lightGradient,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14)
                                  ),

                                ), child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(14),
                                    ), color:Colors.red[400].withOpacity(0.78),
                                  ),

                                  child: InkWell(
                                    onTap: ()async{
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setInt('academicPeriodId',widget.academicPeriodId);
                                      _showDialog();
                                    },
                                    child: Padding(

                                      padding: const EdgeInsets.fromLTRB(11.0, 7.5, 11.0, 7.5),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.remove_red_eye,size: 13,color: Colors.white,),SizedBox(width: 5,),

                                          Text('Marksheet',style: TextStyle(color: Colors.white,
                                              fontSize: 12),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),alignment: Alignment.topRight,),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return TerminalMarksheet();
      },
    );
  }

}

