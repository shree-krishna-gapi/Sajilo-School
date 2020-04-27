import 'package:flutter/material.dart';
import '../utils/fadeAnimation.dart';
import '../utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screen/home.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'service/user.dart';
import 'service/grade.dart';
import 'service/student.dart';
import 'package:sajiloschool/teacher/teacher.dart';

class LoginBody extends StatefulWidget {
  final String title = "AutoComplete Demo";
  @override
  _LoginBodyState createState() => _LoginBodyState();
}
class _LoginBodyState extends State<LoginBody> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  double paddingValue = 10.0;
  @override
  void initState() {
    getUsers();
    super.initState();
  }
  static List<User> users = new List<User>();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController teacherNumber = TextEditingController();
  TextEditingController userName = TextEditingController();
//  bool loader = true;
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
  String studentName;
  int studentId;
  // School



  getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('schoolId',0);
    prefs.setInt('gradeId',0);
    try {
      final response =
      await http.get('${Urls.BASE_API_URL}/login/getschools');
      print('${Urls.BASE_API_URL}/login/getschools');
      if (response.body != null) {
        setState(() {
          users = loadUsers(response.body);
          loading = false;
        });
      } else {
        print("Error getting users1.");
      }
    } catch (e) {
      print("Error getting users2. $e");
    }
  }

  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
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
              0.6, ListView(
              children: <Widget>[
                FadeAnimation(
                  0.5, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: loading
                              ? Loader()
                              : searchTextField = AutoCompleteTextField<User>(
                            key: key,
                            clearOnSubmit: false,
                            suggestions: users,
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
                    height: 0
                ),
                FadeAnimation(
                    0.6, Container(height: 65,child: Row(
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
                FadeAnimation(
                    0.7, Container(height: 65,child: Row(
                  children: <Widget>[
                    Expanded(child: Text(''),flex: 2,),
                    Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:
                        selectedStudentName == '' ?
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
                          onTap: (){_showDialogS();},
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: "Student Name",hintStyle: TextStyle(
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
                          onTap: (){_showDialogS();},
                          textAlign: TextAlign.center,
                          initialValue: selectedStudentName,
                          decoration: InputDecoration(hintText: "$selectedStudentName",hintStyle: TextStyle(
                              fontSize: 18, color: Colors.white
                          ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white60,width: 1.5)
                            ),

                          ),
                        )

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
                  0.8, Container(
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
                  0.9, Padding(
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
                                if (_formKey.currentState.validate()) {
//

                                }
                                studentLoginProcess();

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
              0.6, ListView(
              children: <Widget>[
                FadeAnimation(
                  0.6, Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(''),flex: 2,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: loading
                              ? Loader()
                              : searchTextField = AutoCompleteTextField<User>(
                            key: key,
                            clearOnSubmit: false,
                            suggestions: users,
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
                              print('${item.logoImage}');
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
                  0.7, Container(
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
                  0.8, Container(
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
                  0.9, Padding(
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
                                if (_formKey.currentState.validate()) {
                                  teacherLoginProcess();
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
                  1.2, Padding(
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
  Widget row(User user) {
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
            user.name,
            style: TextStyle(fontSize: 16.0,color: Colors.white),
          ),
          SizedBox(
            width: 10.0,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: user.address == null ? Text('') :Text(
                  user.address,style: TextStyle(color: Colors.white70,fontSize: 12),
                ),
              )
          ),
        ],
      ),
    );
  }

  studentLoginProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var schoolId =  prefs.getInt('schoolId');
    var gradeId =  prefs.getInt('gradeId');
    var studentId =  prefs.getInt('studentId');
    var mobileNo = mobileNumber.text;
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbfbef),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
//            backgroundColor: Color(0x00000000),
            title: Container( height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(backgroundColor: Colors.yellow[700],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  SizedBox(height: 30,),
                  Shimmer.fromColors(baseColor: Colors.black,highlightColor: Colors.black12,
                      child: Text('Please Wait...', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,
                          letterSpacing: 0.6),))
                ],
              ),
            ),
          );});

    final response =
    await http.get("${Urls.BASE_API_URL}/login/checkcredential?schoolid=$schoolId&gradeid=$gradeId&studentid=$studentId&mobileno=$mobileNo");
    if (response.statusCode == 200) {
      final isUser = json.decode(response.body)['Success'];
      if(isUser == true) {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return Success();
            }
        );
        prefs.setBool('userStatus',true);
        Navigator.of(context).pop();
        Timer(Duration(milliseconds: 600), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        });
      }
      else {
        Navigator.of(context).pop();
        final scaff = Scaffold.of(context);
        scaff.showSnackBar(SnackBar(
          content: Text("Login Failled!."),
          backgroundColor: Colors.black26,
          duration: Duration(seconds: 2),
        ));
      }

    } else {
      Navigator.of(context).pop();
      final scaff = Scaffold.of(context);
      scaff.showSnackBar(SnackBar(
        content: Text("Login Failled!. Urls not Exist."),
        backgroundColor: Colors.black26,
        duration: Duration(seconds: 2),
      ));
    }



  }
  teacherLoginProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var schoolId =  prefs.getInt('schoolId');
    var username = userName.text;
    var mobileNo = teacherNumber.text;
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbfbef),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
//            backgroundColor: Color(0x00000000),
            title: Container( height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(backgroundColor: Colors.yellow[700],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  SizedBox(height: 30,),
                  Shimmer.fromColors(baseColor: Colors.black,highlightColor: Colors.black12,
                      child: Text('Please Wait...', style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,
                          letterSpacing: 0.6),))
                ],
              ),
            ),
          );});
    if(schoolId != 0) {
      print('${Urls.BASE_API_URL}/login/checkteachercredential?schoolid=$schoolId&username=$username&password=$mobileNo');
      final response =
      await http.get("${Urls.BASE_API_URL}/login/checkteachercredential?schoolid=$schoolId&username=$username&password=$mobileNo");
      if (response.statusCode == 200) {
        final isUser = json.decode(response.body)['Success'];
        if(isUser == true) {
          showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return Success();
              }
          );
          prefs.setBool('teacherStatus',true);
          Navigator.of(context).pop();
          Timer(Duration(milliseconds: 600), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Teacher()),
            );
          });
        }
        else {
          Navigator.of(context).pop();
          final scaff = Scaffold.of(context);
          scaff.showSnackBar(SnackBar(
            content: Text("Login Failled!."),
            backgroundColor: Colors.black26,
            duration: Duration(seconds: 2),
          ));
        }

      } else {
        Navigator.of(context).pop();
        final scaff = Scaffold.of(context);
        scaff.showSnackBar(SnackBar(
          content: Text("Login Failled!. Urls not Exist."),
          backgroundColor: Colors.black26,
          duration: Duration(seconds: 2),
        ));
      }
    } else {
      Navigator.of(context).pop();
      final scaff = Scaffold.of(context);
      scaff.showSnackBar(SnackBar(
        content: Text("Please, Field First."),
        backgroundColor: Colors.black26,
        duration: Duration(seconds: 2),
      ));
    }


  }
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
                child: Container( height: 180,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,20,20,10),
                      child: FutureBuilder<List<Grade>>(
                        future: Fetch(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) ;
                          return snapshot.hasData ?
                          CupertinoPicker(
                            itemExtent: 60.0,
                            backgroundColor: Color(0x00000000),
                            onSelectedItemChanged: (index) {
                              changedNowGrade = snapshot.data[index].gradeNameEng;
                              changedNowId = snapshot.data[index].gradeId;
                            },
                            children: new List<Widget>.generate(snapshot.data.length, (index) {
                              changedNowGrade = snapshot.data[0].gradeNameEng;
                              changedNowId = snapshot.data[0].gradeId;
                              return Align(
                                alignment: Alignment.center,
                                child: Text(snapshot.data[index].gradeNameEng,style: TextStyle(
                                    fontSize: 17,fontWeight: FontWeight.w600, letterSpacing: 0.8
                                ),),
                              );
                            }),
                          ):Center(child: Loader());
                        },
                      )
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: ()async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int oldGradeId = prefs.getInt('gradeId');
//                    prefs.setInt('gradeId',changedNowId);
                    setState(() {
                      selectedGrade = changedNowGrade;
                      selectedGradeId = changedNowId;
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


                    prefs.setInt('gradeId',changedNowId);



                    Duration(milliseconds: 500);
                    Navigator.of(context).pop();
                  },
                ),
              ],
              elevation: 4,
            );} );
    }
  }

  resetGradeId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('gradeId',0);
  }


  // login body
  _showDialogS() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId =  prefs.getInt('schoolId');
    int gradeId = prefs.getInt('gradeId');
    if(schoolId == 0 || gradeId == 0){
      final scaff = Scaffold.of(context);
      scaff.showSnackBar(SnackBar(
        content: Text("Please, Select The Student Grade."),
        backgroundColor: Colors.black26,
        duration: Duration(milliseconds: 800),
      ));
    }
    else {
      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return FadeAnimation(0.4,
              AlertDialog(
                backgroundColor: Color(0xfffbf9e7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                content: Container( height: 180,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,20,20,10),
                      child: FutureBuilder<List<Student>>(
                        future: FetchStudent(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) ;
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ?
                            CupertinoPicker(
                              itemExtent: 60.0,
                              backgroundColor: Color(0x00000000),
                              onSelectedItemChanged: (index) {
                                selectedStudentName = snapshot.data[index].studentName;
                                selectedStudentId = snapshot.data[index].profileId;
                              },
                              children: new List<Widget>.generate(snapshot.data.length, (index) {
                                selectedStudentName = snapshot.data[0].studentName;
                                selectedStudentId = snapshot.data[0].profileId;
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 6,),
                                      Text('${snapshot.data[index].studentName}',style: TextStyle(
                                          fontSize: 17,fontWeight: FontWeight.w600, letterSpacing: 0.6
                                      ),),
                                      SizedBox(height: 3,),
                                      Align(alignment: Alignment.bottomRight, child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text('Roll No.: ',style: TextStyle(
                                              fontSize: 13.0,letterSpacing: 0.4
                                          ),),
                                          Text(' ${snapshot.data[index].rollNo}',style: TextStyle(
                                              fontSize: 13.0, fontWeight: FontWeight.w600))
                                        ],
                                      ),)
                                    ],
                                  ),
                                );
                              }),
                            ) :
                            Align(
                                alignment: Alignment.center,
                                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                                  letterSpacing: 0.4,),)
                            );
                          } else {
                            return Loader();
                          }

                        },
                      )
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: ()async {
                      setState(() {
                        studentName = selectedStudentName;
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt('studentId',selectedStudentId);
                      prefs.setString('studentName',selectedStudentName);
                      Duration(milliseconds: 500);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                elevation: 4,
              ),
            );} );
    }
  }


}