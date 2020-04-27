import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sajiloschool/teacher/teacher.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'service/getAttendance.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/teacher/attendance/pages/forceAttendance.dart';
import 'package:sajiloschool/teacher/attendance/pages/normalAttendance.dart';
class StudentAttendance extends StatefulWidget {
  StudentAttendance({this.selectedDate});
  final String selectedDate;

  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  bool _snap = false;
  int o;

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          FadeAnimation(
            0.4, Container(
              height: 70,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.orange.withOpacity(0.04),
                        offset: Offset(4,4),
                        blurRadius: 4
                    ),

                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top:40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Attendance Date:',style: TextStyle(fontStyle: FontStyle.italic,
                          fontSize: 15,fontWeight: FontWeight.w500,),), SizedBox(width: 5,),
                        Text(widget.selectedDate,style: TextStyle(fontStyle: FontStyle.italic,
                          fontSize: 15,fontWeight: FontWeight.w500,),),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
          FadeAnimation(
            0.5, Container(
              height: 35,
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 15,),
                      Text('Select All ', style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),),
                      Container(
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Transform.scale( scale: 1,alignment: Alignment.centerLeft,
                              child: Switch(
                                inactiveThumbColor: Colors.blue[600].withOpacity(0.8),
                                inactiveTrackColor: Colors.blue[600].withOpacity(0.4),
                                onChanged: (bool val) async {
                                  setState(() {
                                    _snap = val;
                                  });
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  int tot =  prefs.getInt('totalAttendance');
                                  int i;
                                  for(i=0;i<tot;i++) {
                                    prefs.setBool('stdPresent$i',_snap); //attendance$i
                                  }
                                },
                                value: this._snap,)
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)
                        ),
                        color: Colors.orange[400],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(1.0,3.0),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,5.5,10,5.5),
                        child:InkWell(
                          child: Text('Set Attendance',style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
                          onTap: () {
                            submitAttendance();
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(child: FadeAnimation(
            0.5, Container(color: Colors.orange[700].withOpacity(0.02),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4,0,4,4),
                child: FutureBuilder<List<AttendanceGet>>(
                    future: fetchAttendance(http.Client()),
                    builder: (context,snapshot){
                      if (snapshot.hasError);
                      return snapshot.hasData ?
                      GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, //4
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8
                          ),
                          itemCount: snapshot.data == null ?0 : snapshot.data.length,
                          itemBuilder: (context, index) {
                            return snapshot.data.length > 0 ? FadeAnimation(
                              0.6, Center(
                                child: _snap == false ? NormalAttendance(
                                    indexing: index,
                                    attendanceId:snapshot.data[index].attendanceId,
                                    studentName:snapshot.data[index].studentName,
                                    studentId:snapshot.data[index].studentId,
                                    isPresent:snapshot.data[index].isPresent,
                                    rollId:snapshot.data[index].rollNo,
                                    total:snapshot.data.length
                                ):
                                    ForceAttendance(
                                    indexing: index,
                                    attendanceId:snapshot.data[index].attendanceId,
                                    forcePresent: _snap,
                                    studentName:snapshot.data[index].studentName,
                                    studentId:snapshot.data[index].studentId,
//                                    isPresent:snapshot.data[index].isPresent,
                                    rollId:snapshot.data[index].rollNo,
                                    total:snapshot.data.length
                                ),
                              ),
                            ):
                            Align(
                                alignment: Alignment.center,
                                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                                  letterSpacing: 0.4,),)
                            );
                          }
                      ): Loader();
                    }
                ),
              ),
            ),
          )),
          FadeAnimation(
            0.8, Container(height: 0.1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 60.0, // has the effect of softening the shadow
                    spreadRadius: 5.0, // has the effect of extending the shadow
                    offset: Offset(
                      8.0, // horizontal, move right 10
                      8.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
           ),
          )
        ],
      ),
    );
  }
  submitAttendance()async {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Wait();
        });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId =  prefs.getInt('schoolId');
    int totalStudent =  prefs.getInt('totalStudent');
    int i;
    var itemList = new List();
    for(i=0;i<totalStudent;i++) {
      var itemMap = new Map();
      itemMap['AttendanceId'] = prefs.getInt('attendanceId$i');
      itemMap['roll']=prefs.getInt('stdRoll$i');
      itemMap['StudentId']=prefs.getInt('stdId$i');
      itemMap['IsPresent']= prefs.getBool('stdPresent$i');

      itemList.add(itemMap);
    }
    Map<dynamic,dynamic>attendanceData = {
      "SchoolId":schoolId,
      "DateOfYearNepali":widget.selectedDate,
      "StudentAttenances" : itemList
    };
    var data = json.encode(attendanceData);
    var url = '${Urls.BASE_API_URL}/login/SaveStudentAttendance';
    print(data);
    // Timer();
//    print(http.post(url,headers: {"Content-Type": "application/json"}, body: data));
    Timer(Duration(milliseconds: 400), () async{
      var response = await http.post(Uri.encodeFull(url),headers: {"Content-Type": "application/json"},body: data);
      if(response.statusCode == 200) {
        Navigator.of(context).pop();
        if(jsonDecode(response.body)['Success']) {
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return Success(txt: 'Successfully',);
              }
          );
          Timer(Duration(milliseconds: 500), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Teacher()), //StudentAttendance
            );
          });
        }
        else {
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return Error(txt: 'sorry, Failled!',subTxt: 'Plese, Try Again',);
              }
          );
        }
      }
    });


  }
}


