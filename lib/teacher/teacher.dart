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
  void initState() {
    // TODO: implement initState
    getCurrentYear();
    super.initState();
  }
  String url;
  String yearName;
  int i;
  int yearId;
  int indexYear;
  getCurrentYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var schoolId = prefs.getInt('schoolId');
    if(schoolId == 0) {
      prefs.setBool('teacherStatus',false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
     url = "${Urls.BASE_API_URL}/login/GetEducationalYear?schoolid=$schoolId";
    final response=await http.get(url);
    print('Home Page Educational Year * Teacher -> $url');
    if (response.statusCode == 200) {
      // todo: shared preference saved
      for(i=0;i<response.body.length;i++) {
        if(jsonDecode(response.body)[i]['isCurrent'] == true){
          yearId = jsonDecode(response.body)[i]['EducationalYearID'];
          yearName = jsonDecode(response.body)[i]['sYearName'];
          indexYear =i;
          //todo : attenendanceEducationalYearId
          break;
        }
      }
      //Homework
      prefs.setInt('indexYearHw',i);
      prefs.setInt('educationalYearIdHw', yearId);
      prefs.setString('educationalYearNameHw', yearName);
      // end of Homework
      //Homework
      prefs.setInt('indexYearHwR',i);
      prefs.setInt('educationalYearIdHwR', yearId);
      prefs.setString('educationalYearNameHwR', yearName);
      // end of Homework

      //Attendance
      prefs.setInt('indexYearHwA',i);
      prefs.setInt('educationalYearIdHwA', yearId);
      prefs.setString('educationalYearNameHwA', yearName);
      // end of Attendance

      //Attendance report
      prefs.setInt('indexYearHwAR',i);
      prefs.setInt('educationalYearIdHwAR', yearId);
      prefs.setString('educationalYearNameHwAR', yearName);
      // end of Attendance Report
      //todo : attendanceEducationalYearData
      prefs.setString('getEducationalYearData',response.body);
      // todo: GetEducationalYear save
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Teacher()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop:onWillPop,
        child: Stack(
          children: <Widget>[

            Container(
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
              decoration: new BoxDecoration(
                color: Colors.yellow.withOpacity(0.1),
//                gradient: purpleGradient,
//          image: new DecorationImage(
//              fit: BoxFit.cover,
//              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0), BlendMode.dstATop),
//              image: ExactAssetImage('assets/banner.jpg')
//          ),
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
                color: Colors.orange[500]), ),
          ),flex: 3,),
          tab == 'one' ?
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.account_balance_wallet,color: Colors.orange[700],),
            ),flex: 2
              ,) :
            Expanded(child: Align(
              alignment: Alignment.center,
              child: Icon(Icons.graphic_eq,color: Colors.orange[700]),
            ),flex: 2
            ,),
        ],
      ),width: double.infinity,
        height: 100,), decoration: BoxDecoration(
        color: Color(0xfffdf9f7), //
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
