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
          onWillPop:onWillPop,
        child: Container(
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
                InkWell(onTap: (){
                 signOut();
                },
                  child: TapDesign(txt:'Sign Out',tab:'five'),
                ),
              ],
            ),
          ),
          decoration: new BoxDecoration(
//        color: const Color(0xff7c94b6),
            gradient: purpleGradient,
//          image: new DecorationImage(
//              fit: BoxFit.cover,
//              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0), BlendMode.dstATop),
//              image: ExactAssetImage('assets/banner.jpg')
//          ),
          ),
        ),
      )
    );
  }
  signOut() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Wait();
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userStatus',false);
    prefs.setBool('teacherStatus',false);
    Timer(Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
    });
    Timer(Duration(milliseconds: 400), () {
      Navigator.of(context).pop();
      showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return Success(txt: 'Sign Out',);
          }
      );
    });
    Timer(Duration(milliseconds: 700), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });

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
      child: Container(child:
      Container(child: Row(
        children: <Widget>[
          Expanded(child: Align(
            alignment: Alignment.center,
            child: Text(txt,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Colors.black.withOpacity(0.08),
                    offset: Offset(1.0, 1.0),
                  ),
                ],
                color: Colors.orange[500]), ),
          ),flex: 3,),
          tab == 'five' ?
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.settings_power,color: Colors.orange[700],),
            ),flex: 2
              ,) :
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.insert_chart,color: Colors.orange[700]),
            ),flex: 2
            ,),
        ],
      ),width: double.infinity,
        height: 80,), decoration: BoxDecoration(
        color: Color(0xfffdf9f7).withOpacity(0.9),
        borderRadius: BorderRadius.all(
            Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            offset: Offset(
              2.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),),
    );
  }
}
