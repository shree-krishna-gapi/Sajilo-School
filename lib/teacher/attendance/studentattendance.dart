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
import 'package:fluttertoast/fluttertoast.dart';
class StudentAttendance extends StatefulWidget {
  StudentAttendance({this.selectedDate});
  final String selectedDate;

  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  bool selectAll = false;
  int o;

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(top: false,
        child: Stack(
          children: <Widget>[
            Positioned(child: Container(height: 24, color: Colors.blue[900],)),
            Column(
              children: <Widget>[
                Container(
                    height: 74,


                    padding: EdgeInsets.fromLTRB(15,27,15,0),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(4,4),
                              blurRadius: 4,
                          ),
                        ],
                      gradient: purpleGradient
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                child: Text('Select All', style: TextStyle(
                                    fontWeight: FontWeight.w600,color: Colors.white,fontSize: 15
                                ),),
                                alignment: Alignment.center,
                              ),
                              selectAll ? Checkbox(value: selectAll,
                                  activeColor: Colors.green,
                                  onChanged:(bool newValue) async{
                                    setState(() {
                                      selectAll = newValue;
                                    });
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    int tot =  prefs.getInt('totalAttendance');
                                    int i;
                                    for(i=0;i<tot;i++) {
                                      prefs.setBool('stdPresent$i',selectAll); //attendance$i
                                    }
                                  }):

                                Theme(
                                    data: ThemeData(unselectedWidgetColor: Colors.white),
                                    child: Checkbox(value: false, tristate: false, onChanged: (bool value)async {
                                      setState(() {
                                        selectAll = value;
                                      });
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      int tot =  prefs.getInt('totalAttendance');
                                      int i;
                                      for(i=0;i<tot;i++) {
                                        prefs.setBool('stdPresent$i',selectAll); //attendance$i
                                      }
                                    }))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Date:',style: TextStyle(
                                fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),), SizedBox(width: 5,),
                              Text(widget.selectedDate,style: TextStyle(fontStyle: FontStyle.italic,
                                fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
                            ],
                          ),


                        ],

                    ),
                  ),



                Expanded(child: Container(color: Colors.orange[700].withOpacity(0.02),
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
                                    0.2, Center(
                                      child: selectAll == false ? NormalAttendance(
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
                                          forcePresent: selectAll,
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
                )),
                FadeAnimation(
                  0.3, Container(height: 0.1,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 30.0, // has the effect of softening the shadow
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
            Positioned(child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(14)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3.0, // has the effect of softening the shadow
                      spreadRadius: 2.0, // has the effect of extending the shadow
                      offset: Offset(
                        3.0, // horizontal, move right 10
                        3.0, // vertical, move down 10
                      ),
                    )
                  ],
                  color: Colors.orange[500].withOpacity(0.8)
              ),
              child: Container(  decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(14)
                  ),
                  color: Colors.orange[500].withOpacity(0.8)
              ),
                  child: InkWell(splashColor: Colors.deepPurpleAccent,child: Padding(
                    padding: const EdgeInsets.fromLTRB(13,8,13,8),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.save,color: Colors.white, size: 18,),
                        Text('  Save Attendance',style: TextStyle(
                            color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600,
                            shadows: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2.0, // has the effect of softening the shadow
                                spreadRadius: 1.0, // has the effect of extending the shadow
                                offset: Offset(
                                  2.0, // horizontal, move right 10
                                  2.0, // vertical, move down 10
                                ),
                              )
                            ]
                        ),),
                      ],
                    ),
                  ),onTap: (){
                    submitAttendance();
                  },)),
            ),
              bottom: 40, right: 15,),
          ],
        ),
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
          Fluttertoast.showToast(
              msg: "Attendance Create Successfully!",
              backgroundColor: Colors.black54,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              textColor: Colors.white);
//          Timer(Duration(milliseconds: 500), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Teacher()), //StudentAttendance
            );
//          });
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


