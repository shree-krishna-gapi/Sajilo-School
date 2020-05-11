import 'package:flutter/material.dart';
import '../../utils/pallate.dart';
import 'package:sajiloschool/student/sidebar/sideBar.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/fadeAnimation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../utils/api.dart';
import 'page/selectFromDate.dart';
import 'page/parentAttendanceservice.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/global/educationalYear.dart';
import 'package:sajiloschool/global/selectMonth.dart';
import 'package:sajiloschool/student/notification/notificationBoard.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}
class _AttendanceState extends State<Attendance> {
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
          onWillPop : onWillPop,
          child: Stack(
            children: <Widget>[
              BodySection(),
              Positioned(child: InkWell(onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationBoard()), //StudentAttendance
                );
              }
                  ,child: Icon(Icons.notifications,size: 22,color: Colors.orange[700],)),
                top: 40, right: 20,
              ),
              SideBar(),
            ],
          ),
        ),



    );
  }
}

class BodySection extends StatefulWidget {
  @override
  _BodySectionState createState() => _BodySectionState();
}

class _BodySectionState extends State<BodySection> {
  bool isMonthly = false;
  bool isSearch = true;
  void initState(){
    setMonth();
    super.initState();
  }
  void setMonth()async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setBool('parentAttendanceIsMonthly', isMonthly);
//    prefs.setInt('monthId', 0);

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 70,),
        FadeAnimation(1.0, Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: <Widget>[
              isMonthly? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  EducationalYear(),
                  SelectMonth()
                ],
              ):
              SelectFromDate(),
              SizedBox(height: 4,),
              Row(

                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Is Monthly',style: TextStyle(fontWeight: FontWeight.w600),),
                  Switch(
                    value: isMonthly,
                    onChanged: (value) {
                      setState(() {
                        isMonthly = value;
                      });
                      setMonth();
                    },
                    inactiveTrackColor: Color(0xFF137cad).withOpacity(0.5),
//                    inactiveThumbColor: Colors.red,
                    activeTrackColor: Colors.blue[700].withOpacity(0.5),
                    activeColor: Color(0xFF28588e),
                  ),
                  SizedBox(width: 20,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.orange,
                    ),
                    padding: EdgeInsets.fromLTRB(11,7,11,7),
                    child: InkWell(onTap: () {
                      setState(() {
                        isSearch =! isSearch;
                      });
                      setMonth();
                    },
                      child: Text('Search Attendance',style: TextStyle(color: Colors.white, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black12,
                          offset: Offset(2.0, 2.0),
                        ),
                      ]),),

                    ),
                  )
                ],
              ),
              SizedBox(height: 0,),
            ],
          ),
        )),

        Container(child:
        FadeAnimation(0.3, MainRow()),
          decoration: BoxDecoration(
              gradient: purpleGradient
          ),),
        isSearch ? Expanded(
          child: Container(
            child:FutureBuilder<List<StudentAttendanceData1>>(
                future: FetchParentAttendance1(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) ;
                  if(snapshot.hasData) {
                    return snapshot.data.length > 0 ?
                    ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (context, index) {
//                              return Text('${snapshot.data[index].monthName}');
                          return FadeAnimation(
                            0.2, Column(
                            children: <Widget>[
                              snapshot.data[index].isWorkingDay ? Container(

                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(child: ChildTxt(title: '${index+1}'), width: 28,),
                                      Expanded(child: ChildTxt(title: '${snapshot.data[index].dateOfYearNepali}'), flex: 1,),
                                      Expanded(child: ChildTxt(title: '${snapshot.data[index].dayName}'), flex: 1,),
                                      Expanded(child: snapshot.data[index].isPresent ? ChildTxt(title: 'Present'):
                                      ChildTxt1(title:'Absent'),
                                        flex: 1,),
                                    ],
                                  ),
                                ),
                              ):
                              Container(
                                color: Colors.orange[400],
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(child: ChildTxtWhite(title: '${index+1}'), width: 28,),
                                      Expanded(child: ChildTxtWhite(title: '${snapshot.data[index].dateOfYearNepali}'), flex: 1,),
                                      Expanded(child: ChildTxtWhite(title: '${snapshot.data[index].dayName}'), flex: 1,),
                                      Expanded(child: ChildTxtWhite(title: 'Holiday'),
                                        flex: 1,),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: Colors.black12,),
                            ],
                          ),
                          );
                        }
                    ) : FadeAnimation(
                      0.4, Align(
                        alignment: Alignment.center,
                        child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                          letterSpacing: 0.4,),)
                    ),
                    );
                  }
                  else {
                    return Loader();
                  }
                }) , //ChildRow()


            decoration: BoxDecoration(
//              color: Color(0xfffbf9e7).withOpacity(0.5)
              color: Color(0xfffdf9f7),
            ),
          ),
        ):Expanded(
          child: Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child:FutureBuilder<List<StudentAttendanceData>>(
                future: FetchParentAttendance(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) ;
                  if(snapshot.hasData) {
                    return snapshot.data.length > 0 ?
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (context, index) {
//                              return Text('${snapshot.data[index].monthName}');
                          return FadeAnimation(
                            0.2, Column(
                            children: <Widget>[
                              snapshot.data[index].isWorkingDay ? Container(

                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(child: ChildTxt(title: '${index+1}'), width: 28,),
                                      Expanded(child: ChildTxt(title: '${snapshot.data[index].dateOfYearNepali}'), flex: 1,),
                                      Expanded(child: ChildTxt(title: '${snapshot.data[index].dayName}'), flex: 1,),
                                      Expanded(child: snapshot.data[index].isPresent ? ChildTxt(title: 'Present'):
                                      ChildTxt1(title:'Absent'),
                                        flex: 1,),
                                    ],
                                  ),
                                ),
                              ):
                              Container(
                                color: Colors.orange[400],
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,8,15,8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(child: ChildTxtWhite(title: '${index+1}'), width: 28,),
                                      Expanded(child: ChildTxtWhite(title: '${snapshot.data[index].dateOfYearNepali}'), flex: 1,),
                                      Expanded(child: ChildTxtWhite(title: '${snapshot.data[index].dayName}'), flex: 1,),
                                      Expanded(child: ChildTxtWhite(title: 'Holiday'),
                                        flex: 1,),
                                    ],
                                  ),
                                ),
                              ),
                              Container(height: 1, color: Colors.black12,),
                            ],
                          ),
                          );
                        }
                    ) : FadeAnimation(
                      0.4, Align(
                        alignment: Alignment.center,
                        child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                          letterSpacing: 0.4,),)
                    ),
                    );
                  }
                  else {
                    return Loader();
                  }
                }) , //ChildRow()


            decoration: BoxDecoration(
//                color: Color(0xfffbf9e7).withOpacity(0.5)
              color: Color(0xfffdf9f7),
            ),
          ),
        ),



      ],
    );
  }
}
class MainRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,12,15,12),
      child: Row(
        children: <Widget>[
          Container(child: ModalTitle(txt:'Sn'),width: 28,),
          Expanded(child: ModalTitle(txt:'Date'),flex: 1,),
          Expanded(child: ModalTitle(txt:'Day'),flex: 1,),
          Expanded(child: ModalTitle(txt:'Status'),flex: 1,),

        ],
      ),
    );
  }
}

class ChildTxt extends StatelessWidget {
  ChildTxt({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      letterSpacing: 0.4,));
  }
}
class ChildTxtWhite extends StatelessWidget {
  ChildTxtWhite({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      letterSpacing: 0.4,color: Colors.white));
  }
}
class ChildTxt1 extends StatelessWidget {
  ChildTxt1({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      letterSpacing: 0.4,color: Colors.red[300]));
  }
}
class Txt extends StatelessWidget {
  Txt({this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(fontSize: 15,color: Colors.white,
        letterSpacing: 0.4, shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black12,
            offset: Offset(2.0, 2.0),
          ),
        ]));
  }
}


