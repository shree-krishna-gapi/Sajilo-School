import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/fadeAnimation.dart';
import '../utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../student/student.dart';
import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'service/user.dart';
//import 'service/grade.dart';
//import 'service/student.dart';
import 'package:sajiloschool/teacher/teacher.dart';
import 'page/searchBody.dart';
//import 'grade/studentGrade.dart';
//import 'pages/getGrade.dart';
import 'service/grade.dart';
import 'package:sajiloschool/auth/login.dart';
import 'package:sajiloschool/main.dart';
class LoginBody extends StatefulWidget {
  final String title = "AutoComplete Demo";
  @override
  _LoginBodyState createState() => _LoginBodyState();
}
class _LoginBodyState extends State<LoginBody> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<School>> key = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  double paddingValue = 10.0;
  bool gettingGrade = false;

  @override
  void initState() {
    getSchool();
//    getGrades();
    super.initState();
  }
  static List<School> schoolData = new List<School>();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController teacherNumber = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  // school
  int selectedSchoolId;
//  bool loader = true;
  String tt;
  bool loading = true;
  // Grade
  int selectedGradeId = 0;
  String selectedGrade = '';
  int changedNowId;
  String changedNowGrade;
//  int stateB=0;
  // Student
  int selectedStudentId = 0;
  String selectedStudentName = '';
  String studentName = '';
  int studentId;
  // School
  // Grade
  bool loadGrade = false;

  getSchool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('schoolId',0);
    prefs.setInt('gradeId',0);
    try {
      final response =
      await http.get('${Urls.BASE_API_URL}/login/getschools');
      if (response.body != null) {
        setState(() {
          schoolData = loadUsers(response.body);
          loading = false;
        });
      } else {
        showSnack("Error getting school.");
      }
    } catch (e) {
      showSnack("Error getting school. $e");
    }
  }

  static List<School> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<School>((json) => School.fromJson(json)).toList();
  }
  int schoolId = 0;
  bool loginStatus = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(30),
            topRight: Radius.circular(30)
        ),
        gradient: purpleGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(1.0,-3.0),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Container(
          color: Colors.black12.withOpacity(0.01),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: loginStatus?
            FadeAnimation(
              0.2, ListView(
              children: <Widget>[
                FadeAnimation(
                  0.3, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: loading
                              ? Loader()
                              : searchTextField = AutoCompleteTextField<School>(
                            key: key,
                            clearOnSubmit: false,
                            suggestions: schoolData,
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
                            decoration: InputDecoration(
                                hintText: "Search School",
                                hintStyle: TextStyle(fontSize: 16, color: Colors.white),focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70,width: 1.5)
                            )
                            ),
                            itemFilter: (item, query) {
                              return item.name
                                  .toLowerCase()
                                  .startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b) {
                              return a.name.compareTo(b.name);
                            },
                            itemSubmitted: (item)async {
                              // todo: autoCompleteField
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int oldSchoolId = prefs.getInt('schoolId');

                              if(oldSchoolId != item.id) {
                                prefs.setInt('gradeId',0);
                                prefs.setInt('studentId',0);
                                selectedStudentId = 0;
                                setState(() {
                                  selectedGrade = '';
                                  selectedStudentName = '';
                                });
                                loadGrade = false;
                              }
                              selectedSchoolId = item.id;
                              schoolId=item.id;                          prefs.setInt('schoolId',selectedSchoolId);
                              print('${item.logoImage}');
                              prefs.setString('logoImage',item.logoImage);
                              setState(() {
                                searchTextField.textField.controller.text = item.name;
                              });
                            },
                            itemBuilder: (context, item) {
                              return row(item);
                            },
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Container(
                      ),flex: 2,)
                    ],
                  ),
                  height: 65,
                ),
                ),
                SizedBox(
                    height: 10
                ),
                FadeAnimation(
                    0.4, Container(height: 65,child: Row(
                  children: <Widget>[
                    Expanded(child:
                    Text(''),flex: 2,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child:  selectedGrade == '' ?
                        TextFormField(
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
                          readOnly: true,
                          onTap: (){_showDialog();},
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "Grade",hintStyle: TextStyle(
                              fontSize: 16, color: Colors.white60
                          ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60,width: 1.5)
                            ),

                          ),
                        ):
                        TextFormField(
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
                          readOnly: true,
                          onTap: (){_showDialog();},
                          textAlign: TextAlign.center,
                          initialValue: selectedGrade,
                          decoration: InputDecoration(hintText: "$selectedGrade",hintStyle: TextStyle(
                              fontSize: 18, color: Colors.white
                          ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60,width: 1.5)
                            ),

                          ),
                        ),
                      )
                      ,flex: 6,
                    ),
                    Expanded(child: Container(
                    ),flex: 2,)
                  ],
                ),)
                ),
                // todo Student Name Field
                FadeAnimation(
                    0.4, Container(height: 65,child: Row(
                  children: <Widget>[
                    Expanded(child: Text(''),flex: 2,),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:  studentName == '' || studentName == null ? TextFormField(
                        onTap: ()async {
                          if(selectedGradeId == 0 || selectedGradeId == null) {
                            showSnack('Please, Select The Student Grade.');
                          }
                          else {
                            String message = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo(
                                schoolId: selectedSchoolId, gradeId:selectedGradeId
                            )));
                            if(message != null){
                              setState(() {
                                studentName = message;
                              });
                            }

                          }
                        },
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
                        readOnly: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(hintText: "Student Name",hintStyle: TextStyle(
                            fontSize: 16, color: Colors.white60
                        ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white60,width: 1.5),
                          ),

                        ),
                      ):TextFormField(
                        onTap: ()async {
                          if(selectedGradeId == 0 || selectedGradeId == null) {
                            showSnack('Please, Select The Student Grade.');
                          }
                          else {
                            String message = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserFilterDemo(
                                schoolId: selectedSchoolId, gradeId:selectedGradeId
                            )));
                            if(message != null ){
                              setState(() {
                                studentName = message;
                              });
                            }
                          }
                        },
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
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: InputDecoration(hintText: studentName,hintStyle: TextStyle(
                            fontSize: 18, color: Colors.white
                        ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 1.5),
                          ),

                        ),
                      ),

                    ),flex: 6,),
                    Expanded(child: Container(
                    ),flex: 2,)
                  ],
                ),)
                ),
                SizedBox(
                  height: 0,
                ),
                FadeAnimation(
                  0.4, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextFormField(
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
                            textAlign: TextAlign.center,
                            controller: mobileNumber,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value.isEmpty) {
                                return '* Insert the Mobile Number';
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(hintText: "Mobile No.",hintStyle: TextStyle(
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
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Container(
                      ),flex: 2,)
                    ],
                  ),
                  height: 65,
                ),
                ),
                SizedBox(height: 35,),
                FadeAnimation(
                  0.5, Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(30)
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(1.0,5.0),
                            )
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Material(
                            color: Color(0x00000000),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.75),width: 1.5
                                )
                            ),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(22,8,7.5,11),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Login',style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),fontSize: 16,fontWeight: FontWeight.w500,
                                    letterSpacing: 0.4,shadows:[
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                  ),),
                                ),
                              ),
                              splashColor: Colors.orange,
                              onTap: (){

                                if (_formKey.currentState.validate() && studentId !=0) {
                                  studentLoginProcess();
                                }
                                else {
                                  showSnack('Please, Select The All Field.');
                                }


                              },
                            ),
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Text(''),flex: 2,),
                    ],
                  ),
                ),
                ),
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          loginStatus =! loginStatus;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Teacher Login ?',style: TextStyle(color: Colors.white70,
                                  fontSize: 14),),
                              SizedBox(height: 4,),
                              Container(
                                height: 2,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),  color: Colors.white.withOpacity(0.75),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(1.0,5.0),
                                    )
                                  ],
                                ),

                              ),
                            ],
                          ),

                        ],
                      )
                  ),
                ),
              ],
            )
              ,
            ):
            // Teacher Login
            FadeAnimation(
              0.2, ListView(
              children: <Widget>[
                FadeAnimation(
                  0.3, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: loading
                              ? Loader()
                              : searchTextField = AutoCompleteTextField<School>(
                            key: key,
                            clearOnSubmit: false,
                            suggestions: schoolData,
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
                            decoration: InputDecoration(
                                hintText: "Search School",
                                hintStyle: TextStyle(fontSize: 16, color: Colors.white),focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70,width: 1.5)
                            )
                            ),
                            itemFilter: (item, query) {
                              return item.name
                                  .toLowerCase()
                                  .startsWith(query.toLowerCase());
                            },
                            itemSorter: (a, b) {
                              return a.name.compareTo(b.name);
                            },
                            itemSubmitted: (item)async {
                              // todo: autoCompleteField
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              int oldSchoolId = prefs.getInt('schoolId');

                              if(oldSchoolId != item.id) {
                                prefs.setInt('gradeId',0);
                                prefs.setInt('studentId',0);
                                setState(() {
                                  selectedGrade = '';
                                  selectedStudentName = '';
                                });
                              }
                              prefs.setInt('schoolId',item.id);
                              prefs.setString('logoImage',item.logoImage);

                              setState(() {
                                searchTextField.textField.controller.text = item.name;
                              });
                            },
                            itemBuilder: (context, item) {
                              return row(item);
                            },
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Container(
                      ),flex: 2,)
                    ],
                  ),
                  height: 65,
                ),
                ),
                SizedBox(
                    height: 0
                ),
                FadeAnimation(
                  0.4, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextFormField(
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
                            textAlign: TextAlign.center,
                            controller: userName,
                            validator: (value){
                              if(value.isEmpty) {
                                return '* Insert the Username';
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(hintText: "UserName",hintStyle: TextStyle(
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
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Container(
                      ),flex: 2,)
                    ],
                  ),
                  height: 65,
                ),
                ),
                FadeAnimation(
                  0.5, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: TextFormField(
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
                            textAlign: TextAlign.center,
                            controller: teacherNumber,
                            keyboardType: TextInputType.number,
                            validator: (value){
                              if(value.isEmpty) {
                                return '* Insert the Mobile Number';
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(hintText: "Mobile No.",hintStyle: TextStyle(
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
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Container(
                      ),flex: 2,)
                    ],
                  ),
                  height: 65,
                ),
                ),
                SizedBox(height: 35,),
                FadeAnimation(
                  0.5, Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(30)
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(1.0,5.0),
                            )
                          ],
                        ),
                        child: Container(
                          width: double.infinity,
                          child: Material(
                            color: Color(0x00000000),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.75),width: 1.5
                                )
                            ),
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(22,8,7.5,11),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('Login',style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),fontSize: 16,fontWeight: FontWeight.w500,
                                    letterSpacing: 0.4,shadows:[
                                    Shadow(
                                      blurRadius: 4.0,
                                      color: Colors.black12,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                  ),),
                                ),
                              ),
                              splashColor: Colors.orange,
                              onTap: (){

                                if (_formKey.currentState.validate() && selectedSchoolId !=null) {
                                  teacherLoginProcess();
                                }
                                else {
                                  showSnack('Please, Select The All Field.');
                                }


                              },
                            ),
                          ),
                        ),
                      ),flex: 6,),
                      Expanded(child: Text(''),flex: 2,),
                    ],
                  ),
                ),
                ),
                SizedBox(height: 30,),
                FadeAnimation(
                  0.5, Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          loginStatus =! loginStatus;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Student Login ?',style: TextStyle(color: Colors.white70,
                                  fontSize: 14),),
                              SizedBox(height: 4,),
                              Container(
                                height: 2,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),  color: Colors.white.withOpacity(0.75),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(1.0,5.0),
                                    )
                                  ],
                                ),

                              ),
                            ],
                          ),

                        ],
                      )
                  ),
                ),
                ),

              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
  Widget row(School school) {
    return Container(
      decoration: BoxDecoration(
          gradient: purpleGradient,
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                color: Colors.black12,blurRadius: 2
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            school.name,
            style: TextStyle(fontSize: 16.0,color: Colors.white),
          ),
          SizedBox(
            width: 10.0,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: school.address == null ? Text('') :Text(
                  school.address,style: TextStyle(color: Colors.white70,fontSize: 12),
                ),
              )
          ),
        ],
      ),
    );
  }
  String url;
  String getYearUrl;
  int getStudentId;
  studentLoginProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getStudentId = prefs.getInt('studentId');
    var mobileNo = mobileNumber.text;
    if(getStudentId == null || getStudentId == 0) {
      showSnack('Please, Select the Field.');
    }
    else {
      showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return Wait();});
      url = '${Urls.BASE_API_URL}/login/checkcredential?schoolid=$selectedSchoolId&gradeid=$selectedGradeId&studentid=$getStudentId&mobileno=$mobileNo';
      print(url);
        final response =
        await http.get(url);
      Navigator.of(context).pop();
        if (response.statusCode == 200) {
          final isUser = json.decode(response.body)['Success'];
          if(isUser == true) {
            prefs.setBool('studentStatus',true);
            showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return Success();
                }
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginStatus()),
            );
          }
          else {

            showSnack('Login Failled! Please, Try Again');
          }

        } else {

          showSnack('Login Failled! Please, Contact To The Developer');
        }

    }




  }
  teacherLoginProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var teacherName = userName.text;
    var teacherMobileNo = teacherNumber.text;
    print('lllll');
    if(selectedSchoolId == null || selectedSchoolId == 0) {
      showSnack('Please, Select the Field.');
    }
    else {
      showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return Wait();});
      url = '${Urls.BASE_API_URL}/login/checkteachercredential?schoolid=$selectedSchoolId&username=$teacherName&password=$teacherMobileNo';
      print(url);

      final response =
      await http.get(url);
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        final isUser = json.decode(response.body)['Success'];
        if(isUser == true) {
          prefs.setBool('teacherStatus',true);
          showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return Success();
              }
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginStatus()),
          );
        }
        else {

          showSnack('Login Failled!. Please Try Again.');
        }

      } else {

        showSnack('Login Failled!. Urls not Exist.');

      }
    }


  }


  resetGradeId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('gradeId',0);
  }
  int indexYear;
//  String url;
  String yearName;
  int yearId;
//  int schoolId;
  int i;


  showSnack(message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      backgroundColor: Colors.black26,
      duration: Duration(milliseconds: 800),
    ));
  }
  int indexGrade;
  Future<void> _showDialog() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId =  prefs.getInt('schoolId');

    if(schoolId == 0) {
      final scaff = Scaffold.of(context);
      scaff.showSnackBar(SnackBar(
        content: Text("Please, Select The School Name"),
        backgroundColor: Colors.black26,
        duration: Duration(milliseconds: 800),
      ));
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
                                          changedNowId =
                                              snapshot.data[index].gradeId;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int oldGradeId = prefs.getInt('gradeId');
                                          setState(() {
                                            selectedGrade = changedNowGrade;

                                          });
                                          if(oldGradeId == 0) {
                                          }
                                          else if(oldGradeId!=changedNowId) {
                                            prefs.setInt('gradeId',0);
                                            prefs.setInt('studentId',0);
                                            setState(() {
                                              selectedStudentName = '';
                                            });
                                          }
                                          selectedGradeId = changedNowId;
                                          indexGrade = index;
                                          prefs.setInt('gradeId',changedNowId);
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                '${snapshot.data[index]
                                                    .gradeNameEng}',
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
                                          changedNowId =
                                              snapshot.data[index].gradeId;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int oldGradeId = prefs.getInt('gradeId');
                                          setState(() {
                                            selectedGrade = changedNowGrade;

                                          });
                                          if(oldGradeId == 0) {
                                          }
                                          else if(oldGradeId!=changedNowId) {
                                            prefs.setInt('gradeId',0);
                                            prefs.setInt('studentId',0);
                                            setState(() {
                                              selectedStudentName = '';
                                            });
                                          }
                                          selectedGradeId = changedNowId;
                                          indexGrade = index;
                                          prefs.setInt('gradeId',changedNowId);
                                          Duration(milliseconds: 100);
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.5),
                                              child: Center(child: Text(
                                                  '${snapshot.data[index]
                                                  .gradeNameEng}')),
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

              elevation: 4,
            );} );
    }
  }



}