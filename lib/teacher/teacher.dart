import 'package:flutter/material.dart';
import '../utils/api.dart';
import '../utils/pallate.dart';
import 'attendance/getstudents.dart';
import 'attendanceReport/getAttendance.dart';
import 'homework/setHomework.dart';
import 'package:sajiloschool/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'homeworkReport/GetHomeworkReport.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sidebar/sideBar.dart';
import 'dart:io';
class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  bool gridView = true;
  DateTime backPressTime;
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    //Statement 1 Or statement2
    bool backButton = backPressTime == null ||
        currentTime.difference(backPressTime) > Duration(seconds: 1);
    if (backButton) {
      backPressTime = currentTime;
      Fluttertoast.showToast(
          msg: "Double Tap to Exit App",
          backgroundColor: Colors.black54,
          textColor: Colors.white);
      return false;
    }
    exit(0);
  }
  @override
  void initState() {
//    this.gridViewFunction();
    super.initState();
  }
  gridViewFunction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentGridView = prefs.getBool('isGridView');
    setState(() {
      gridView = currentGridView;
    });
  }
  final tabList = [
    {'title':'Homework',},{'title':'Homework Report',},{'title':'Attendance',},{'title':'Attendance Report',}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: WillPopScope(
          onWillPop:onWillPop,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  color: Color(0xfffbfff7).withOpacity(0.5),
                ),

                child: Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.only(right:30),
                        height: 36,
                        color:Color(0xFF28588e),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('Filter View   ',style: TextStyle(color: Colors.white),),
                            gridView ? InkWell(child: Icon(Icons.view_module, size: 28,color: Colors.white,),
                              onTap: ()async {
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  gridView =! gridView;
                                });
                                prefs.setBool('isGridView',gridView);
                              },
                            ):
                            InkWell(child: Icon(Icons.view_stream,size: 28,color: Colors.white,),
                              onTap: ()async {
                                final SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  gridView =! gridView;
                                });
                                prefs.setBool('isGridView',gridView);
                              },)
                          ],
                        ),
                      ),
                      gridView? Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15,),
                              Row(
                                children: <Widget>[
                                  Expanded(child: InkWell( onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SetHomework()), //StudentAttendance
                                    );
                                  },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0, // has the effect of softening the shadow
                                              spreadRadius: 1.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                1.0, // horizontal, move right 10
                                                1.0, // vertical, move down 10
                                              ),
                                            ),]),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 35,),
                                          Icon(Icons.message,color: Color(0xFF28588e),size: 30,),
                                          SizedBox(height: 15,),
                                          title(context,'${tabList[0]['title']}',),
                                          SizedBox(height: 30,),
                                        ],
                                      ),
                                    ),
                                  )),
                                  SizedBox(width: 15,),
                                  Expanded(child: InkWell(onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GetHomeworkReport()), //StudentAttendance
                                    );
                                  },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0, // has the effect of softening the shadow
                                              spreadRadius: 1.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                1.0, // horizontal, move right 10
                                                1.0, // vertical, move down 10
                                              ),
                                            ),]),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 35,),
                                          Icon(Icons.account_balance_wallet,color: Color(0xFF28588e),size: 30,),
                                          SizedBox(height: 15,),
                                          title(context,'${tabList[1]['title']}',),
                                          SizedBox(height: 30,),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: <Widget>[
                                  Expanded(child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => GetStudents()), //StudentAttendance
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0, // has the effect of softening the shadow
                                              spreadRadius: 1.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                1.0, // horizontal, move right 10
                                                1.0, // vertical, move down 10
                                              ),
                                            ),]),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 35,),
                                          Icon(Icons.account_balance,color: Color(0xFF28588e),size: 30,),
                                          SizedBox(height: 15,),
                                          title(context,'${tabList[2]['title']}',),
                                          SizedBox(height: 30,),
                                        ],
                                      ),
                                    ),
                                  )),
                                  SizedBox(width: 15,),
                                  Expanded(child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => GetAttendance()), //StudentAttendance
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0, // has the effect of softening the shadow
                                              spreadRadius: 1.0, // has the effect of extending the shadow
                                              offset: Offset(
                                                1.0, // horizontal, move right 10
                                                1.0, // vertical, move down 10
                                              ),
                                            ),]),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 35,),
                                          Icon(Icons.graphic_eq,color: Color(0xFF28588e),size: 30,),
                                          SizedBox(height: 15,),
                                          title(context,'${tabList[3]['title']}',),
                                          SizedBox(height: 30,),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 50,),
                            ],
                          )
                      ) : Container(
                        padding: EdgeInsets.fromLTRB(30,0,30,0),
                        child: Column(
                          children: <Widget>[

                            InkWell(onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SetHomework()), //StudentAttendance
                              );
                            },
                              child: TapDesign(txt:'Homework',tab:'one'),
                            ),
                            InkWell(onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GetHomeworkReport()), //StudentAttendance
                              );
                            },
                              child: TapDesign(txt:'Homework Report',tab:'two'),
                            ),
                            InkWell(onTap: (){

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GetStudents()), //StudentAttendance
                              );
                            },
                              child: TapDesign(txt:'Attendance',tab:'three'),
                            ),
                            InkWell(onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GetAttendance()), //StudentAttendance
                              );
                            },
                              child: TapDesign(txt:'Attendance Report',tab:'four'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              ),
              SideBar(),
            ],
          ),
        )
    );
  }
  Text title(BuildContext context,txt) {
    return Text('$txt',style: TextStyle(fontSize: 17,color: Color(0xFF28588e)),);
  }
}



class TapDesign extends StatelessWidget {
  TapDesign({this.txt,this.tab});
  final String txt;
  final String tab;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      child: Container(
        child:
        Container(child: Row(
          children: <Widget>[
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Text('$txt',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(0.08),
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                  color: Colors.blue[900]), ),
            ),flex: 3,),
            tab == 'one' ?
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.account_balance_wallet,color: Colors.blue[900],),
            ),flex: 2
              ,) :
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.graphic_eq,color: Colors.blue[900]),
            ),flex: 2
              ,),
          ],
        ),width: double.infinity,
          height: 100,), decoration: BoxDecoration(
        //  0xfffdf9f7
//          gradient: purpleGradient,
        color: Colors.white,
        borderRadius: BorderRadius.all(
            Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              1.0, // horizontal, move right 10
              1.0, // vertical, move down 10
            ),
          )
        ],
      ),),
    );
  }
}