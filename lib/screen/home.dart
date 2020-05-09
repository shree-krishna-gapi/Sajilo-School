import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:sajiloschool/screen/attendance/attendance.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'exam/exam.dart';
import '../utils/pallate.dart';
import 'fees/fees.dart';
import 'homework/homework.dart';
import 'attendance/attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sajiloschool/auth/login.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController _pageController;
  String url;
  @override
  void initState() {
    super.initState();
    this.getCurrentYear();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final double itemHeight = double.infinity;
  final double itemWidth = double.infinity/2;
  int indexYear;
  getCurrentYear() async {
    print('hello moto');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var schoolId = prefs.getInt('schoolId');
    if(schoolId == 0) {
      prefs.setBool('userStatus',false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    url = "${Urls.BASE_API_URL}/login/GetEducationalYear?schoolid=$schoolId";
    final response=await http.get(url);
    print('Home Page Educational Year * screen/home -> $url');
    if (response.statusCode == 200) {
      int i;
      int yearId;
      String yearName;

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
      //exam
      prefs.setInt('indexYearExam',i);
      prefs.setInt('educationalYearIdExam', yearId);
      prefs.setString('educationalYearNameExam', yearName);
      // end of exam

      //Fees
      prefs.setInt('indexYearFees',i);
      prefs.setInt('educationalYearIdFees', yearId);
      prefs.setString('educationalYearNameFees', yearName);
      // end of Fees

      //Attendance
      prefs.setInt('indexYearAttendance',i);
      prefs.setInt('educationalYearIdAttendance', yearId);
      prefs.setString('educationalYearNameAttendance', yearName);
      // end of Attendance

      prefs.setString('educationalYearName', yearName);

      prefs.setInt('educationalYearId', yearId);



      prefs.setInt('educationalYearIdAttendance', yearId);
      //todo : attendanceEducationalYearData
      prefs.setString('getEducationalYearData',response.body);
      // todo: GetEducationalYear save
      getMonthData(schoolId);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }

  }
  String monthName;
  int monthId;
  getMonthData(int schoolId)async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final responseMonth = await  http.get("${Urls.BASE_API_URL}/login/GetNepaliMonths?schoolid=$schoolId");
//    print('${Urls.BASE_API_URL}/login/GetNepaliMonths?schoolid=$schoolId');
    if (responseMonth.statusCode == 200) {
      monthName = jsonDecode(responseMonth.body)[0]['MonthName'];
      monthId = jsonDecode(responseMonth.body)[0]['Month'];
//      print('********************************************');
//      print(jsonDecode(responseMonth.body)[0]['Month']);
//      print(jsonDecode(responseMonth.body)[0]['MonthName']);

      // Attendance
      prefs.setInt('indexMonthAttendance',0);
      prefs.setString('educationalMonthNameAttendance',monthName);
      prefs.setInt('educationalMonthIdAttendance',monthId);
      //end of Attendance


      prefs.setString('getMonthData', responseMonth.body);
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: purpleGradient,
        ),
        child: FadeAnimation(
          0.4, BottomNavyBar(
            selectedIndex: _currentIndex,
            showElevation: true, // use this to remove appBar's elevation
            onItemSelected: (index) => setState(() {
              _currentIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 800), curve: Curves.ease);
            }),
            backgroundColor: Color(0x0000000), //0xFF117aac
            items: [
              BottomNavyBarItem(
                  icon: Icon(Icons.show_chart),
                  title: Text('Exam'),
                  activeColor: TabColor.aColor,
                  inactiveColor: TabColor.inColor

              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.payment),
                  title: Text('Fees'),
                  activeColor: TabColor.aColor,
                  inactiveColor: TabColor.inColor
              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.chrome_reader_mode),
                  title: Text('Homework'),
                  activeColor: TabColor.aColor,
                  inactiveColor: TabColor.inColor
              ),
              BottomNavyBarItem(
                  icon: Icon(Icons.verified_user),
                  title: Text('Attendance'),
                  activeColor: TabColor.aColor,
                  inactiveColor: TabColor.inColor
              )
            ],

          ),
        ),
      ),
      body: FadeAnimation(
        0.3, SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              FadeAnimation(0.3, Exam()),
              Fees(),
              HomeWork(),
              Attendance()
            ],
          ),
        ),
      ),
    );
  }
}
class TabColor {
  static Color aColor = Colors.white;
  static Color inColor = Colors.white70;

}
