import 'package:flutter/material.dart';
import 'package:sajiloschool/auth/grade/studentGrade.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student/student.dart';
import 'utils/fadeAnimation.dart';
import 'teacher/teacher.dart';
import 'auth/Test.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connectivity/connectivity.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sajilo School',
        theme: ThemeData(
//          primarySwatch: Colors.blueGrey,
        primaryColor: Color(0xFF117aac), //0xFF28588e
          accentColor: Color(0xFF35739f),
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0)),
        ),
        home:LoginStatus()
    );
  }
}


class LoginStatus extends StatefulWidget {
  @override
  _LoginStatusState createState() => _LoginStatusState();
}

class _LoginStatusState extends State<LoginStatus> {
  int indexYear;
  String url;
  String yearName;
  int yearId;
  int schoolId;
  int i;
  bool connected = false;
//
//  @override
//  void initState() {
////    this.checkStatus();
//
//    super.initState();
//  }
  checkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final teacherLogin = prefs.getBool('teacherStatus');
    final studentLogin = prefs.getBool('studentStatus');
    schoolId = prefs.getInt('schoolId');
    url = "${Urls.BASE_API_URL}/login/GetEducationalYear?schoolid=$schoolId";
    if(teacherLogin == true) {
      print('Teacher Login ----');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // todo: shared preference saved
        for (i = 0; i < response.body.length; i++) {
          if (jsonDecode(response.body)[i]['isCurrent'] == true) {
            yearId = jsonDecode(response.body)[i]['EducationalYearID'];
            yearName = jsonDecode(response.body)[i]['sYearName'];
            indexYear = i;
            //todo : attenendanceEducationalYearId
            break;
          }
        }
        //Homework
        prefs.setInt('indexYearHw', i);
        prefs.setInt('educationalYearIdHw', yearId);
        prefs.setString('educationalYearNameHw', yearName);
        // end of Homework
        //Homework
        prefs.setInt('indexYearHwR', i);
        prefs.setInt('educationalYearIdHwR', yearId);
        prefs.setString('educationalYearNameHwR', yearName);
        // end of Homework

        //Attendance
        prefs.setInt('indexYearHwA', i);
        prefs.setInt('educationalYearIdHwA', yearId);
        prefs.setString('educationalYearNameHwA', yearName);
        // end of Attendance

        //Attendance report
        prefs.setInt('indexYearHwAR', i);
        prefs.setInt('educationalYearIdHwAR', yearId);
        prefs.setString('educationalYearNameHwAR', yearName);
        // end of Attendance Report
        //Teacher
        prefs.setInt('indexYearCalenderT', i);
        prefs.setInt('educationalYearIdCalenderT', yearId);
        prefs.setString('educationalYearNameCalenderT', yearName);
        // end of Teacher
        //todo : attendanceEducationalYearData
        prefs.setString('getEducationalYearData', response.body);
        // todo: GetEducationalYear save
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Teacher()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }
    else if (studentLogin == true) {
      final response = await http.get(url);
      print('Home Page Educational Year * screen/home -> $url');
      if (response.statusCode == 200) {
        // todo: shared preference saved
        for (i = 0; i < response.body.length; i++) {
          if (jsonDecode(response.body)[i]['isCurrent'] == true) {
            yearId = jsonDecode(response.body)[i]['EducationalYearID'];
            yearName = jsonDecode(response.body)[i]['sYearName'];
            indexYear = i;
            //todo : attenendanceEducationalYearId
            break;
          }
        }
        //exam
        prefs.setInt('indexYearExam', i);
        prefs.setInt('educationalYearIdExam', yearId);
        prefs.setString('educationalYearNameExam', yearName);
        // end of exam

        //Fees
        prefs.setInt('indexYearFees', i);
        prefs.setInt('educationalYearIdFees', yearId);
        prefs.setString('educationalYearNameFees', yearName);
        // end of Fees

        //Attendance
        prefs.setInt('indexYearAttendance', i);
        prefs.setInt('educationalYearIdAttendance', yearId);
        prefs.setString('educationalYearNameAttendance', yearName);
        // end of Attendance

        //Attendance
        prefs.setInt('indexYearAttendance', i);
        prefs.setInt('educationalYearIdAttendance', yearId);
        prefs.setString('educationalYearNameAttendance', yearName);
        // end of Attendance

        //Calender
        prefs.setInt('indexYearCalender', i);
        prefs.setInt('educationalYearIdCalender', yearId);
        prefs.setString('educationalYearNameCalender', yearName);
        // end of Calender
        //todo : attendanceEducationalYearData
        prefs.setString('getEducationalYearData', response.body);
        // todo: GetEducationalYear save
//      alreadyLoadYear = true;
//      getMonthData(schoolId);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Student()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }

    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
//    print('widget First $connected');
//    if(connected) {
//      print('widget connected First');
//      print('this is connected $connected');
//      checkStatus();
//    }
//    else {
//      print('false');
//    }
    return Scaffold(
      body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,

              Widget child,
              ) {
            connected = connectivity != ConnectivityResult.none;
            if(connected) {
              checkStatus();
            }
            return Stack(
              children: <Widget>[
//                InkWell(
//                  onTap: () {
//                    checkStatus();
//                  },
//                  child:
                  new Container(
                    decoration: BoxDecoration(
                        gradient: purpleGradient
                    ),
                    child: Center(
                      child: Container(child: FadeAnimation(1.0,

                         Image.asset('assets/logo/logo.png',
                          fit: BoxFit.cover,),
                      ),
                        height: 85,
                      ),
                    ),
//                  ),
                ),
                connected? new Container(height: 1,) : new NoNetwork()
              ],
            );
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: purpleGradient
            ),
            child: Center(
              child: Container(child: FadeAnimation(1.0,

                 Image.asset('assets/logo/logo.png',
                  fit: BoxFit.cover,),
              ),
                height: 80,
              ),
            ),
          )
      ),
    );
  }
}


