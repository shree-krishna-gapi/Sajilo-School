import 'package:flutter/material.dart';
import 'package:sajiloschool/auth/grade/studentGrade.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/home.dart';
import 'utils/fadeAnimation.dart';
import 'teacher/teacher.dart';
import 'auth/Test.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
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
//        com.mininginfosys.sajiloschool
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
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
  void initState(){
    setState(() {
      existUser();
    });
    super.initState();
  }
  Future existUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentLogin = prefs.getBool('userStatus');
    final teacherLogin = prefs.getBool('teacherStatus');
    if(studentLogin == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()), //StudentAttendance Home
      );
    }
    else if(teacherLogin == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Teacher()),
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()), //JsonApiDropdown
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: purpleGradient
        ),
        child: Center(
          child: Container(child: FadeAnimation(1.0, InkWell(
            onTap: () {
              existUser();
            },
            child: Image.asset('assets/logo/logo.png',
              fit: BoxFit.cover,),
          )),
            height: 100,
          ),
        ),
      ),
    );
  }
}


