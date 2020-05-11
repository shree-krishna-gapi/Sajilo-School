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
class Teacher extends StatefulWidget {
  @override
  _TeacherState createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
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
          onWillPop:onWillPop,
          child: Stack(
            children: <Widget>[

              Container(
                decoration: new BoxDecoration(
                  color: Color(0xfffbfff7).withOpacity(0.5),
                ),
                padding: EdgeInsets.all(30),
                child: Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                ),

              ),
              SideBar(),
            ],
          ),
        )
    );
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