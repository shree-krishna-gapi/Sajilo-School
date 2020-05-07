import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'services.dart';
import 'dart:async';
import 'package:sajiloschool/utils/pallate.dart';
import 'dart:convert';
class UserFilterDemo extends StatefulWidget {
  final int schoolId;
  final int gradeId;
  UserFilterDemo({this.schoolId,this.gradeId}) : super();

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
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

class UserFilterDemoState extends State<UserFilterDemo> {

  final _debouncer = Debouncer(milliseconds: 100);
  List<User> users = List();
  List<User> filteredUsers = List();
  bool loader=true;
  @override
  void initState() {
    super.initState();
    Services.getUsers(widget.schoolId,widget.gradeId).then((usersFromServer) {
      loader = false;
      print('this is no. of student ${usersFromServer.length}');
      setState(() {
        users = usersFromServer;
        filteredUsers = users;
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
              Container(height: 50,
                color: Color(0xfffbfbef),
                child: Row(
                  children: <Widget>[
                    Expanded(child: InkWell(child: Icon(Icons.arrow_back,color: Colors.blue[900],),onTap: (){
                      Navigator.of(context).pop();
                    },),flex: 1,),
                    Expanded(child: TextField(
//                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        hintText: 'Student Name Search By Letter',
                      ),
                      onChanged: (string) {
                        _debouncer.run(() {
                          setState(() {
                            filteredUsers = users
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

              Expanded(child: loader ? WaitLoader() :
              filteredUsers.length > 0 ? ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return
                  FadeAnimation(
                    0.1, Card(color: Color(0xfffbfbef),
                    elevation: 2,
                    child: InkWell(
                      onTap: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setInt('studentId', filteredUsers[index].id);
                        prefs.setString('studentName', filteredUsers[index].name);
                        Navigator.pop(context,filteredUsers[index].name);
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
                            Align(alignment: Alignment.centerRight,
                              child: Text(
                                'Roll No. ${filteredUsers[index].email}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  );
                },
              ): Align(
                  alignment: Alignment.center,
                  child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                    letterSpacing: 0.4,color: Colors.white),)
              )  )
            ],
          ),
        ),
      ),
    );
  }
}
