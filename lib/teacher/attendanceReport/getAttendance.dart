import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:sajiloschool/teacher/attendance/studentattendance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'dart:async';
import 'package:sajiloschool/teacher/generic/textStyle.dart';
import 'field/services/grade.dart';
import 'field/services/classget.dart';

import 'field/services/getYear.dart';
import 'field/services/stream.dart';
import 'field/services/monthget.dart';
import 'pages/recordShow.dart';

class GetAttendance extends StatefulWidget {
  @override
  _GetAttendanceState createState() => _GetAttendanceState();
}

class _GetAttendanceState extends State<GetAttendance> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  // ismonthly
  bool isMonthly = true;
  // Grade
  int changedGradeId;
  String changedNowGrade;
  int selectedGradeId = 0;
  String selectedGrade = '';
  // Stream
  int changedNowStreamId;
  String changedNowStream;
  int selectedStreamId = 0;
  String selectedStream = '';
  // Class
  int changedNowClassId;
  String changedNowClass;
  int selectedClassId = 0;
  String selectedClass = '';
  // Month
  int changedNowMonthId;
  String changedNowMonth;
  int selectedMonthId = 0;
  String selectedMonth = '';


  int schoolId;
  // Date
  String fromDate =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now().add(Duration(days: -15)))}');
  String toDate =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now())}');
  // End
  @override
  void initState() {
    getDate();
    super.initState();
  }

  void getDate()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    schoolId = prefs.getInt('schoolId');
  }
  submit()async {
    // for per student get
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMonthlyPer', isMonthly);
    prefs.setInt('monthIdPer', selectedMonthId);
    prefs.setString('monthName', selectedMonth);
    prefs.setString('fromDatePer', fromDate);
    prefs.setString('fromDatePer', toDate);
    if (isMonthly == false) {
      if (selectedMonthId == null) {
        _showSnackBar(context,'Please, Select The Month!');
      }
    }
    if (selectedClassId == 0 ) {
      _showSnackBar(context,'Please, Select The Field!');
    }
    else {
      showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return Wait();
          });
      var yearId = prefs.getInt('educationalYearIdHwAR');
      String url;
      try {
        if(isMonthly == true) {
          url = '${Urls.BASE_API_URL}/login/GetStudentMonthlyAttendance?'
              'schoolId=$schoolId&EducationYearId=$yearId&GradeId=$selectedGradeId&StreamId=$selectedStreamId&'
              'ClassId=$selectedClassId&'
              'month=$selectedMonthId&fromDate=0&toDate=0&isMonthly=true';
        }else {
          url = '${Urls.BASE_API_URL}/login/GetStudentMonthlyAttendance?'
              'schoolId=$schoolId&EducationYearId=$yearId&GradeId=$selectedGradeId&StreamId=$selectedStreamId&'
              'ClassId=$selectedClassId&'
              'month=0&fromDate=$fromDate&toDate=$toDate&isMonthly=false';
        }   
        print(url);
        final response =
        await http.get(url);
        Navigator.of(context).pop();
        if (response.statusCode == 200) {
          //todo totalAttendance count
          prefs.setString('attendanceRecord',response.body);
//          prefs.setString('attendanceRecordEncode',jsonEncode(response.body));
            var responseJson = jsonDecode(response.body);
          int count = responseJson.length;
          prefs.setInt('totalStudent', count);
          if(count>0) {
            prefs.setString('getStudentForAttendance',response.body);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecordShow()),
              );
          }
          else {
            showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (BuildContext context) {
                  return Error(txt: 'Data Not Found',subTxt: 'Please, Try Again',);
                }
            );
          }
        } else {
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return Error(txt: 'Make a Sure!',subTxt: 'Please, Try Again',);
              }
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return Error(txt: 'Something Wrong!',subTxt: 'Please, Contact to the developer',);
            }
        );
      }
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
//      backgroundColor: Colors.blue[800],

      body:  Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: purpleGradient
          ),
          child: Align( alignment: Alignment.center,
            child: ListView(shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[

                      TitleText(txt:'Attendance Report'),
                      FadeAnimation(
                        0.2, Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
//                          Expanded(child: LabelText(labelTitle:'Is Monthly'),flex: 3,),
                          Expanded(child: Align(alignment: Alignment.bottomRight,child: Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 10),
                            child: Text('Is Monthly',style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.6,
                                fontSize: 15,
                                shadows: [
                                  Shadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                  )
                                ]
                            ),),
                          )),flex: 3,),
                            Expanded(child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                      margin: EdgeInsets.only(left: 7,),
                                      width: 70,
                                      child: Switch(
                                        value: isMonthly,
                                        onChanged: (value) {
                                          setState(() {
                                            isMonthly = value;
                                          });
                                        },
                                        activeTrackColor: Colors.white38,
                                        activeColor: Colors.white,

                                    ),
                                ),
                                Expanded(child: Text(''))
                              ],
                            ),flex: 5,),
                          ],
                        ),
                      ),
                      SizedBox(height: 0,),
                      FadeAnimation(0.3, GetYear()),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.3, Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child: LabelText(labelTitle:'Grade'),flex: 3,),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child:  selectedGrade == '' ?
                                TextFormField(
                                  readOnly: true,
                                  onTap: (){_showGradeDialog();},
                                  decoration: InputDecoration(hintText: "Grade",hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white60
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),
                                  ),
                                ):
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  readOnly: true,
                                  onTap: (){_showGradeDialog();},
                                  textAlign: TextAlign.left,
                                  initialValue: selectedGrade,
                                  decoration: InputDecoration(hintText: "$selectedGrade",hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),

                                  ),
                                ),
                              )
                              ,flex: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.4, Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child: LabelText(labelTitle: 'Stream',),flex: 3,),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child:  selectedStream == '' ?
                                TextFormField(
                                  readOnly: true,
                                  onTap: (){_showStreamDialog();},
                                  decoration: InputDecoration(hintText: "Stream",hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white60
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),
                                  ),
                                ):
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  readOnly: true,
                                  onTap: (){_showStreamDialog();},
                                  textAlign: TextAlign.left,
                                  initialValue: selectedStream,
                                  decoration: InputDecoration(hintText: "$selectedStream",hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),

                                  ),
                                ),
                              )
                              ,flex: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.5, Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(child: LabelText(labelTitle: 'Class',),flex: 3,),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child:  selectedClass == '' ?
                                  TextFormField(
                                    readOnly: true,
                                    onTap: (){_showClassDialog();},
                                    decoration: InputDecoration(hintText: "Class",hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.white60
                                    ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                      ),
                                    ),
                                  ):
                                  TextFormField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4.0,
                                          color: Colors.black12,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    readOnly: true,
                                    onTap: (){_showClassDialog();},
                                    textAlign: TextAlign.left,
                                    initialValue: selectedClass,
                                    decoration: InputDecoration(hintText: '$selectedClass',hintStyle: TextStyle(
                                        fontSize: 15, color: Colors.white
                                    ),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                      ),

                                    ),
                                  ),
                                )
                                ,flex: 5,
                              )
                            ]
                        ),
                      ),
                      SizedBox(height: 20,),

                      isMonthly ? FadeAnimation(
                        0.6, Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(child: LabelText(labelTitle: 'Select Month',),flex: 3,),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child:  selectedMonth == '' ?
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  readOnly: true,
                                  onTap: (){_showMonthDialog();},
//                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(hintText: "Month",hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white60
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),

                                  ),
                                ):
                                TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  readOnly: true,
                                  onTap: (){_showMonthDialog();},
                                  textAlign: TextAlign.left,
                                  initialValue: selectedMonth,
                                  decoration: InputDecoration(hintText: '$selectedMonth',hintStyle: TextStyle(
                                      fontSize: 15, color: Colors.white
                                  ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white60,width: 1.5)
                                    ),

                                  ),
                                ),
                              )
                              ,flex: 5,
                            )
                          ]
                      ),
                      ): FadeAnimation(
                        0.5, Column(
                          children: <Widget>[
                            _fromDate(context,'From Date','fromDate'),
                            _toDate(context,'To Date','toDate'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      FadeAnimation(
                        0.6, Row(
                          children: <Widget>[
                            Expanded(child: Text(''),flex: 1,),
                            Expanded(child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 20,top: 40),
                              child: Material(
                                color: Color(0x00000000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.75),width: 1.5
                                  ),
                                ),
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(22,8,7.5,11),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text('Get Attendance',style: TextStyle(
                                        color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,
                                        letterSpacing: 0.8,shadows:[
                                        Shadow(
                                          blurRadius: 4.0,
                                          color: Colors.black26,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                      ],
                                      ),),
                                    ),
                                  ),
                                  splashColor: Colors.orange,
                                  onTap: (){
                                    submit();
                                  },
                                ),
                              ),
                            ),flex: 2,),
                            Expanded(child: Text(''),flex: 1,),

                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                FadeAnimation(
                  0.6, Center(
                  child: Center(
                    child: FlatButton(onPressed: () {
                      Navigator.of(context).pop();},
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 5,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.all(
                                Radius.circular(4)
                            )
                        ),

                      ),
                      splashColor: Color(0x0000000),
                    ),
                  ),
                ),
                ),
//                      FadeAnimation(
//                        0.6, Row(
//                          children: <Widget>[
//                            Expanded(child: Text(''),flex: 1,),
//                            Expanded(child: Container(
//                              width: double.infinity,
//                              padding: EdgeInsets.only(left: 20,top: 30),
//                              child: Material(
//                                color: Color(0x00000000),
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(10.0),
//                                  side: BorderSide(
//                                      color: Colors.white.withOpacity(0.75),width: 1.5
//                                  ),
//                                ),
//                                child: InkWell(
//                                  child: Padding(
//                                    padding: const EdgeInsets.fromLTRB(22,8,7.5,11),
//                                    child: Row(
//                                      mainAxisAlignment: MainAxisAlignment.center,
//                                      children: <Widget>[
//                                        Icon(Icons.arrow_back,size: 20, color: Colors.white,),
//                                        SizedBox(width: 5,),
//                                        Text('Back',style: TextStyle(
//                                          color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,
//                                          letterSpacing: 0.8,shadows:[
//                                          Shadow(
//                                            blurRadius: 4.0,
//                                            color: Colors.black26,
//                                            offset: Offset(2.0, 2.0),
//                                          ),
//                                        ],
//                                        ),),
//                                      ],
//                                    ),
//                                  ),
//                                  splashColor: Colors.orange,
//                                  onTap: (){
//                                    Navigator.pop(context);
//                                  },
//                                ),
//                              ),
//                            ),flex: 2,),
//                            Expanded(child: Text(''),flex: 1,),
//
//                          ],
//                        ),
//                      ),

//                    ],
//                  ),
              ],
            ),
          ),

        ),
      ),

    );
  }

  Row _fromDate(BuildContext context,String title, String value) {
    return Row(
      children: <Widget>[
        Expanded(child: LabelText(labelTitle: title,),flex: 3,),
        Expanded(child: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30,),
                Text(fromDate,style: TextStyle(fontStyle: FontStyle.italic,
                    fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
                Container(color: Colors.black38,
                  margin: EdgeInsets.only(top: 10),
                  height: 1.4,)
              ],
            ),
          ),
          onTap: () async{
            NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
              context: context,
              initialDate: NepaliDateTime.now(),  //NepaliDateTime.now(),
              firstDate: NepaliDateTime(2000),
              lastDate: NepaliDateTime(2090),
              language: Language.english,
              initialDatePickerMode: DatePickerMode.day,
            );
            setState(() {
              fromDate=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
            });
          },
        ),flex: 5,),

      ],
    );
  }
  Row _toDate(BuildContext context,String title, String value) {
    return Row(
      children: <Widget>[
        Expanded(child: LabelText(labelTitle: title,),flex: 3,),
        Expanded(child: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30,),
                Text(toDate,style: TextStyle(fontStyle: FontStyle.italic,
                    fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white),),
                Container(color: Colors.black38,
                  margin: EdgeInsets.only(top: 10),
                  height: 1.4,)
              ],
            ),
          ),
          onTap: () async{
            NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
              context: context,
              initialDate: NepaliDateTime.now(),  //NepaliDateTime.now(),
              firstDate: NepaliDateTime(2000),
              lastDate: NepaliDateTime(2090),
              language: Language.english,
              initialDatePickerMode: DatePickerMode.day,
            );
            setState(() {
              toDate=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
            });
          },
        ),flex: 5,),

      ],
    );
  }
  int indexGrade;
  Future<void> _showGradeDialog() {

    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbf9e7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            content: Container(
              child: Container(
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,10,20,0),
                      child: FutureBuilder<List<Grade>>(
                        future: Fetch(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) ;
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return
                                    index == indexGrade ? FadeAnimation(
                                      0.2, Container(
                                      color: Colors.orange[400],
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowGrade =
                                              snapshot.data[index].gradeNameEng;
                                          changedGradeId =
                                              snapshot.data[index].gradeId;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setInt('tempChangedGradeId',changedGradeId);
                                          if(selectedGradeId != changedGradeId) {
                                            selectedStreamId = 0;
                                            selectedStream = '';
                                            selectedClassId = 0;
                                            selectedClass = '';
                                          }
                                          setState(() {
                                            selectedGrade = changedNowGrade;
                                          });
                                          selectedGradeId = changedGradeId;
                                          indexGrade = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                snapshot.data[index]
                                                    .gradeNameEng,
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    ) :
                                    FadeAnimation(
                                      0.2, Container(
                                        child: InkWell(
                                          onTap: () async {
                                            changedNowGrade =
                                                snapshot.data[index].gradeNameEng;
                                            changedGradeId =
                                                snapshot.data[index].gradeId;
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setInt('tempChangedGradeId',changedGradeId);
                                            if(selectedGradeId != changedGradeId) {
                                              selectedStreamId = 0;
                                              selectedStream = '';
                                              selectedClassId = 0;
                                              selectedClass = '';
                                            }
                                            setState(() {
                                              selectedGrade = changedNowGrade;
                                            });
                                            selectedGradeId = changedGradeId;
                                            indexGrade = index;
                                            Duration(milliseconds: 100);
                                            Navigator.of(context).pop();
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.5),
                                                child: Center(child: Text(
                                                    snapshot.data[index]
                                                        .gradeNameEng)),
//                                    color: Colors.black12,
                                              ),
                                              Container(
                                                height: 1,
                                                color: Colors.black.withOpacity(
                                                    0.05),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                }
                            )
                                :
                            Empty                          (
                            );


                          } else { return Loader(); }
                        },
                      )
                  ),
                ),
              ),
            ),

            elevation: 4,
          );} );

  }
  int indexStream;
  _showStreamDialog() {
    if(selectedGradeId == 0) {
      _showSnackBar(context,'Please, Select The Grade.');
    }
    else {
      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xfffbf9e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: FutureBuilder<List<GetStream>>(
                        future: FetchStream(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {

                            return snapshot.data.length > 0 ? Center(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return index == indexGrade ? FadeAnimation(
                                      0.2, Container(
                                      color: Colors.orange[400],
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowStream =
                                              snapshot.data[index].streamName;
                                          changedNowStreamId =
                                              snapshot.data[index].streamId;
                                          SharedPreferences prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.setInt('tempChangedClassId', changedGradeId);
                                          if (selectedGradeId != changedGradeId) {
                                            selectedStreamId = 0;
                                            selectedStream = '';
                                            selectedClassId = 0;
                                            selectedClass = '';
                                          }
                                          setState(() {
                                            selectedStream = changedNowStream;
                                          });
                                          selectedStreamId = changedNowStreamId;
                                          indexStream = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                snapshot.data[index]
                                                    .streamName,
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    ) :
                                    FadeAnimation(
                                      0.2, Container(
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowStream =
                                              snapshot.data[index].streamName;
                                          changedNowStreamId =
                                              snapshot.data[index].streamId;
                                          SharedPreferences prefs = await SharedPreferences
                                              .getInstance();
                                          prefs.setInt('tempChangedClassId', changedGradeId);
                                          if (selectedGradeId != changedGradeId) {
                                            selectedStreamId = 0;
                                            selectedStream = '';
                                            selectedClassId = 0;
                                            selectedClass = '';
                                          }
                                          setState(() {
                                            selectedStream = changedNowStream;
                                          });
                                          selectedStreamId = changedNowStreamId;
                                          indexStream = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                  snapshot.data[index]
                                                      .streamName)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    );
                                  }
                              ),
                            )
                                :
                            Empty                          (
                            );


                          } else { return Loader(); }
                        },
                      )
                  ),
                ),
              ),

              elevation: 4,
            );
          });
    }
  }
  int indexClass;
  _showClassDialog() {
    if(selectedStreamId == 0) {
      _showSnackBar(context,'Please, Select The Stream.');
    }
    else {
      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xfffbf9e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                child: Container(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: FutureBuilder<List<GetClass>>(
                        future: FetchClass(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ? Center(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return index == indexClass ? FadeAnimation(
                                      0.2, Container(
                                      color: Colors.orange[400],
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowClass =
                                              snapshot.data[index].className;
                                          changedNowClassId =
                                              snapshot.data[index].classId;
                                          setState(() {
                                            selectedClass = changedNowClass;

                                          });
                                          selectedClassId = changedNowClassId;
                                          indexClass = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();

                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                snapshot.data[index]
                                                    .className,
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    ) :
                                    FadeAnimation(
                                      0.2, Container(
                                      child: InkWell(
                                        onTap: () async {
                                          changedNowClass =
                                              snapshot.data[index].className;
                                          changedNowClassId =
                                              snapshot.data[index].classId;
                                          setState(() {
                                            selectedClass = changedNowClass;

                                          });
                                          selectedClassId = changedNowClassId;
                                          indexClass = index;
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                  snapshot.data[index]
                                                      .className)),
//                                    color: Colors.black12,
                                            ),
                                            Container(
                                              height: 1,
                                              color: Colors.black.withOpacity(
                                                  0.05),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    );
                                  }
                              ),
                            )
                                :
                            Empty                          (
                            );


                          } else { return Loader(); }
                        },
                      )
                  ),
                ),
              ),

              elevation: 4,
            );
          });
    }
  }
  int indexMonth;
  _showMonthDialog() {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbf9e7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            content: Container(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: FutureBuilder<List<GetMonth>>(
                      future: FetchMonth(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError);
//                        return snapshot.hasData ?

//                        CupertinoPicker(
//                          itemExtent: 60.0,
//                          backgroundColor: Color(0x00000000),
//                          onSelectedItemChanged: (index) {
//                            changedNowMonth = snapshot.data[index].monthName;
//                            changedNowMonthId = snapshot.data[index].monthId;
//                          },
//                          children: new List<Widget>.generate(
//                              snapshot.data.length, (index) {
//                            changedNowMonth = snapshot.data[0].monthName;
//                            changedNowMonthId = snapshot.data[0].monthId;
//                            return Align(
//                              alignment: Alignment.center,
//                              child: Text(snapshot.data[index].monthName,
//                                style: TextStyle(
//                                    fontSize: 17,
//                                    fontWeight: FontWeight.w600,
//                                    letterSpacing: 0.8
//                                ),),
//                            );
//                          }),
//                        ) : Center(child: Loader());
                        if(snapshot.hasData) {
                          return snapshot.data.length > 0 ? Center(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index)
                                {
                                  return index == indexMonth ? FadeAnimation(
                                    0.2, Container(
                                    color: Colors.orange[400],
                                    child: InkWell(
                                      onTap: () async {
                                        changedNowMonth = snapshot.data[index].monthName;
                                        changedNowMonthId = snapshot.data[index].monthId;
                                        setState(() {
                                          selectedMonth = changedNowMonth;
                                        });
                                        selectedMonthId = changedNowMonthId;
                                        indexMonth = index;
                                        Duration(milliseconds: 100);
                                        Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.5),
                                            child: Center(child: Text(
                                              snapshot.data[index]
                                                  .monthName,
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),)),
//                                    color: Colors.black12,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.black.withOpacity(
                                                0.05),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  ) :
                                  FadeAnimation(
                                    0.2, Container(
                                    child: InkWell(
                                      onTap: () async {
                                        changedNowMonth = snapshot.data[index].monthName;
                                        changedNowMonthId = snapshot.data[index].monthId;
                                        setState(() {
                                          selectedMonth = changedNowMonth;
                                        });
                                        selectedMonthId = changedNowMonthId;
                                        indexMonth = index;
                                        Duration(milliseconds: 100);
                                        Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.5),
                                            child: Center(child: Text(
                                                snapshot.data[index]
                                                    .monthName)),
//                                    color: Colors.black12,
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.black.withOpacity(
                                                0.05),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  );
                                }
                            ),
                          )
                              :
                          Empty                          (
                          );


                        } else { return Loader(); }
                      },

                    )
                ),
              ),
            ),

            elevation: 4,
          );
        });
  }
  _showSnackBar(BuildContext context,title) {
    final snackBar = SnackBar(content: Text(title),
      backgroundColor: Colors.black38,
      duration: Duration(milliseconds: 800),);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}







class LabelText extends StatelessWidget {
  LabelText({this.labelTitle});
  final String labelTitle;
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerRight,child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(labelTitle,style: TextStyle(
          color: Colors.white,
          letterSpacing: 0.6,
          fontSize: 15,
          shadows: [
            Shadow(
              color: Colors.black12,
              blurRadius: 4.0,
            )
          ]
      ),),
    ));
  }
}