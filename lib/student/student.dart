import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:sajiloschool/student/attendance/attendance.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'exam/exam.dart';
import '../utils/pallate.dart';
import 'fees/fees.dart';
import 'homework/homework.dart';
import 'attendance/attendance.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:sajiloschool/auth/login.dart';


class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  int _currentIndex = 0;
  PageController _pageController;
  String url;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final double itemHeight = double.infinity;
  final double itemWidth = double.infinity/2;


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
              FadeAnimation(0.3,Exam()),
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
