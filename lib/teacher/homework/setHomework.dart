import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'dart:async';
import 'field/service/grade.dart';
import 'field/service/classget.dart';
import 'newservice/getYear.dart';
import 'field/service/stream.dart';
import 'field/service/subject.dart';
import '../teacher.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SetHomework extends StatefulWidget {
  @override
  _SetHomeworkState createState() => _SetHomeworkState();
}

class _SetHomeworkState extends State<SetHomework> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  TextEditingController homeworkController = TextEditingController();
  // auto
  final sizedBoxHeight = 10.0;
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
 // subject
  int changedNowSubjectId;
  String changedNowSubject;
  int selectedSubjectId =0;
  String selectedSubject='';
  // Class
  int changedNowClassId;
  String changedNowClass;
  int selectedClassId=0;
  String selectedClass='';
  // Homework
  int schoolId;
  // IsActive
  bool isActive= true;
  // Date
  String date =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now())}');
  // End
  // is Active
  bool isMonthly = true;
  @override
  void initState() {
//    getDate();
    super.initState();
  }

  void getDate()async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

  }


  _submit(BuildContext context)async {

    if (selectedClassId == 0) {
      _showSnackBar(context,'Please, Select The Field!');
    }
    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return Wait();
          });

      int yearId = prefs.getInt('educationalYearIdHw');
      schoolId = prefs.getInt('schoolId');
      String hw = homeworkController.text;
        var url = '${Urls.BASE_API_URL}/login/SaveHomework?'
            'schoolId=$schoolId&educationyearId=$yearId&gradeId=$selectedGradeId&classId=$selectedClassId&subjectId=$selectedSubjectId&date'
            '=$date&isActive=$isActive&homework=$hw';

        print(url);
        final response =
        await http.get(url);
        if (response.statusCode == 200) {
          Navigator.of(context).pop();//todo totalAttendance count
          print(json.decode(response.body)['Success']);
          final isUser = json.decode(response.body)['Success'];
            if(isUser == true) {
//              showDialog<void>(
//                  context: context,
//                  barrierDismissible: true, // user must tap button!
//                  builder: (BuildContext context) {
//                    return Success(txt: 'Create Successfully',);
//                  }
//              );
              Fluttertoast.showToast(
                  msg: "HomeWork Create Successfully!",
                  backgroundColor: Colors.black54,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.white);
              Timer(Duration(milliseconds: 300), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Teacher()), //StudentAttendance
                );
              });
            }
            else {
//              Navigator.of(context).pop();
              showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return Error(txt: 'Make a Sure!',subTxt: 'Please, Try Again',);
                  }
              );
            }
          }
          else {
          Navigator.of(context).pop();
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return Error(txt: 'Error!',subTxt: 'Please, Try Again',);
              }
          );
        }

    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      body:  Container(
          decoration: BoxDecoration(
              gradient: purpleGradient
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
//              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(child: LabelText(labelTitle:''),flex: 3,),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('HomeWork',style: TextStyle(fontSize: 20,color: Colors.white,letterSpacing: 0.4,
                      shadows:[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black12,
                        ),
                      ]
                      ),),
                    ),flex: 5,)
                  ],
                ),
                SizedBox(height: 20,),
                FadeAnimation(0.2, GetYear()),
                SizedBox(height: sizedBoxHeight,),
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
//                  textAlign: TextAlign.center,
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
                SizedBox(height: sizedBoxHeight,),
                FadeAnimation(
                  0.3, Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: LabelText(labelTitle: 'Stream',),flex: 3,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:  selectedStream == '' ?
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
//                  textAlign: TextAlign.center,
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
                SizedBox(height: sizedBoxHeight,),
                FadeAnimation(
                  0.4, Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: LabelText(labelTitle: 'Class',),flex: 3,),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child:  selectedClass == '' ?
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
//                  textAlign: TextAlign.center,
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
                            decoration: InputDecoration(hintText: selectedClass,hintStyle: TextStyle(
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
                SizedBox(height: sizedBoxHeight,),
                FadeAnimation(0.4,
//                    _test(context,'Homework','hw','Homework Task','')
                    Row(
                      children: <Widget>[
                        Expanded(child: Align(alignment: Alignment.centerRight,child: Padding(
                          padding: const EdgeInsets.only(right: 20, left: 10),
                          child: Text('Homework',style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.6,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black12,
                                  blurRadius: 4.0,

                                )
                              ]
                          ),),
                        )),flex: 3,),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(right: 20),

//                            child: TextFormField(
//                              decoration: new InputDecoration(labelText: "Homework Task",labelStyle: TextStyle(
//                                  color: Colors.white60
//                              )),
//                              maxLines: 2,
//                              style: TextStyle(
//                                  color: Colors.white.withOpacity(0.8)
//                              ),
//                              controller: homeworkController,
//                              validator: (value){
//                                if(value.isEmpty) {
//                                  return "* Inser the Homework";
//                                }
//                                else {
//                                  return null;
//                                }
//                              },
//                            ),
                          child: TextFormField(
                            decoration: InputDecoration(hintText: "Homework Task",hintStyle: TextStyle(
                                fontSize: 16, color: Colors.white60
                            ),errorStyle: TextStyle(
                              color: Colors.orange[600],
                              wordSpacing: 2.0,
                              letterSpacing: 0.4,
                            ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60,width: 1.5),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                  blurRadius: 4.0,
                                  color: Colors.black12,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            controller: homeworkController,
                            validator: (value){
                              if(value.isEmpty) {
                                return '* Insert the Homework Task';
                              }
                              else {
                                return null;
                              }
                            },
//                            minLines: 2, maxLength: 3,

                          ),

                        ),flex: 4,), //        Expanded(child: Text(''),flex: 1,)
                      ],
                    )
                ),
                SizedBox(height: sizedBoxHeight,),
                FadeAnimation(
                  0.5, Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: LabelText(labelTitle: 'Subject',),flex: 3,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:  selectedSubject == '' ?
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
                          onTap: (){_showSubjectDialog();},
//                  textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "Subject",hintStyle: TextStyle(
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
                          onTap: (){_showSubjectDialog();},
                          textAlign: TextAlign.left,
                          initialValue: selectedSubject,
                          decoration: InputDecoration(hintText: "$selectedSubject",hintStyle: TextStyle(
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
                SizedBox(height: sizedBoxHeight,),
                FadeAnimation(0.5, _hwDate(context,'Date','date')),
                SizedBox(height: 20,),
                FadeAnimation(0.6, _status(context,'IsActive')),
                FadeAnimation(
                  0.6, Row(
                  children: <Widget>[
                    Expanded(child: Text(''),flex: 1,),
                    Expanded(child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20,top: 20),
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
                              child: Text('Save Homework',style: TextStyle(
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
                            if (formKey.currentState.validate()) {
                              _submit(context);
                            }

                          },
                        ),
                      ),
                    ),flex: 2,),
                    Expanded(child: Text(''),flex: 1,),

                  ],
                ),
                ),
                SizedBox(height: 15,),
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

              ],
            ),
          ),
        ),


    );
  }

  Row _hwDate(BuildContext context,String title, String value) {
    return Row(
      children: <Widget>[
        Expanded(child: LabelText(labelTitle: 'Date',),flex: 3,),
        Expanded(child: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25,),
                Text(date,style: TextStyle(fontStyle: FontStyle.italic,
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
              date=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
            });
          },
        ),flex: 5,),

      ],
    );
  }
  Row _status(BuildContext context,String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
//                          Expanded(child: LabelText(labelTitle:'Is Monthly'),flex: 3,),
        Expanded(child: Align(alignment: Alignment.bottomRight,child: Padding(
          padding: const EdgeInsets.only(left: 10,bottom: 10),
          child: Text('Is Active',style: TextStyle(
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
        Expanded(child:  Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      child: Switch(
                        value: isMonthly,
                        onChanged: (value) async{
                          final SharedPreferences prefs= await SharedPreferences.getInstance();
                          prefs.setBool('hwIsactive', value);
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
                ), flex: 2,),
              Expanded(child: Text(''),flex: 4,)
            ],
          ),
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
              child: Container(//height: 260,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,10,20,0),
                      child: FutureBuilder<List<Grade>>(
                        future: Fetch(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) ;
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ? Center(
                              child: ListView.builder(
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
                                              SharedPreferences prefs = await SharedPreferences
                                                  .getInstance();
                                              prefs.setInt('tempChangedGradeId',
                                                  changedGradeId);
                                              prefs.setInt(
                                                  'gradeId', changedGradeId);
                                              if (selectedGradeId !=
                                                  changedGradeId) {
                                                selectedStreamId = 0;
                                                selectedStream = '';
                                                selectedSubjectId = 0;
                                                selectedSubject = '';
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
                                              SharedPreferences prefs = await SharedPreferences
                                                  .getInstance();
                                              prefs.setInt('tempChangedGradeId',
                                                  changedGradeId);
                                              prefs.setInt(
                                                  'gradeId', changedGradeId);
                                              if (selectedGradeId !=
                                                  changedGradeId) {
                                                selectedStreamId = 0;
                                                selectedStream = '';
                                                selectedSubjectId = 0;
                                                selectedSubject = '';
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
            ),

            elevation: 4,
          );} );

  }
  double heightStream = 200.0;
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
                                    return index == indexStream ? FadeAnimation(
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
                                          prefs.setInt('streamId',changedGradeId);
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
                                          prefs.setInt('streamId',changedGradeId);
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
  int indexSubject;
  _showSubjectDialog() {
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
                      child: FutureBuilder<List<GetSubject>>(
                        future: FetchSubject(http.Client()),
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
                                    return index == indexSubject ? FadeAnimation(
                                      0.2, Container(
                                      color: Colors.orange[400],
                                      child: InkWell(
                                        onTap: () {
                                          changedNowSubject =
                                              snapshot.data[index].subjectName;
                                          changedNowSubjectId =
                                              snapshot.data[index].subjectId;
                                          setState(() {
                                            selectedSubject = changedNowSubject;
                                          });
                                          selectedSubjectId = changedNowSubjectId;
                                          indexSubject = index;
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
                                                    .subjectName,
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
                                        onTap: () {
                                          changedNowSubject =
                                              snapshot.data[index].subjectName;
                                          changedNowSubjectId =
                                              snapshot.data[index].subjectId;
                                          setState(() {
                                            selectedSubject = changedNowSubject;
                                          });
                                          selectedSubjectId = changedNowSubjectId;
                                          indexSubject = index;
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
                                                      .subjectName)),
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


                          } else { return Loader();
                          }
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
                child: Container( color: Color(0x000000),
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
                                    return index == indexGrade ? FadeAnimation(
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


                          } else { return Loader();
                          }
                        }
                      )
                  ),
                ),
              ),

              elevation: 4,
            );
          });
    }
  }
  _showSnackBar(BuildContext context,title) {
    final snackBar = SnackBar(content: Text(title),
      backgroundColor: Colors.black38,
      duration: Duration(milliseconds: 800),);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
  Row _test (BuildContext context, String title, String value, String hint,String preFixValue) {
    return Row(
      children: <Widget>[
        Expanded(child: Align(alignment: Alignment.centerRight,child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 10),
          child: Text('$title',style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.6,
              fontSize: 16,
              shadows: [
                Shadow(
                  color: Colors.black12,
                  blurRadius: 4.0,

                )
              ]
          ),),
        )),flex: 3,),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Center(
            child: TextFormField(
              decoration: new InputDecoration(labelText: "$hint",labelStyle: TextStyle(
                  color: Colors.white60
              )),
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8)
              ),
              controller: homeworkController,
              validator: (value){
                print('this is value of hw-> $value');
                if(value.isEmpty) {
                  return "* Inser the Homework";
                }
                else {
                  return null;
                }
              },
            ),
          ),
        ),flex: 4,), //        Expanded(child: Text(''),flex: 1,)
      ],
    );
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