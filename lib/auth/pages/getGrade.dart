import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sajiloschool/auth/page/services.dart';
import 'dart:async';
import 'package:sajiloschool/utils/pallate.dart';
class GetGrade extends StatefulWidget {
  final int schoolId;
  GetGrade({this.schoolId}) : super();

  @override
  GetGradeState createState() => GetGradeState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class GetGradeState extends State<GetGrade> {
  final _debouncer = Debouncer(milliseconds: 100);
  List<Grade1> grades = List();
  List<Grade1> filteredUsers = List();
  bool loader=true;
  @override
  void initState() {
    super.initState();
    Services.getGrades(widget.schoolId).then((gradesFromServer) {
      loader = false;
      setState(() {
        grades = gradesFromServer;
        filteredUsers = grades;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: purpleGradient
          ),
          child: Column(
            children: <Widget>[
              Container(height: 40,
                color: Color(0xfffbfbef),
                child: Row(
                  children: <Widget>[
                    Expanded(child: InkWell(child: Icon(Icons.arrow_back),onTap: (){
                      Navigator.of(context).pop();
                    },),flex: 1,),
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: 'Student Name Search By Letter',
                      ),
                      onChanged: (string) {
                        _debouncer.run(() {
                          setState(() {
                            filteredUsers = grades
                                .where((u) => (u.name
                                .toLowerCase()
                                .contains(string.toLowerCase()) ||
                                u.name.toLowerCase().contains(string.toLowerCase())))
                                .toList();
                          });
                        });
                      },
                    ),flex: 8,),
                  ],
                ),
              ),
              Expanded(child: loader ? WaitLoader() : ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return filteredUsers.length > 0 ?
                  FadeAnimation(
                    0.1, Card(color: Color(0xfffbfbef),
                    elevation: 2,
                    child: InkWell(
                      onTap: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setInt('gradeId',filteredUsers[index].id);
                        Navigator.pop(context,[filteredUsers[index].id,filteredUsers[index].name]);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              filteredUsers[index].name,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ) : Empty();
                },
              )  )
            ],
          ),
        ),
      ),
    );
  }
}

