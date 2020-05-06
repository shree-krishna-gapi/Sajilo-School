import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<Album> futureAlbum;
  final dividerHeight = 24.0;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0x000000),
        body: InkWell( onTap: (){Navigator.of(context).pop();},
            child: Center(
                child: Container(
                    padding: EdgeInsets.all(20),

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xfffbf9e7),
                      ),
                    child: Container(
                      height: 440,
                      padding: EdgeInsets.all(15.0),
                      width: double.infinity,
                      child: FutureBuilder<Album>(
                        future: futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return FadeAnimation(
                              0.2, Column(
                              children: <Widget>[
                                CircleAvatar(
                                  minRadius: 35,
                                  backgroundColor: Colors.black12,
                                  child: Icon(Icons.person,
                                      size: 30,
                                      color: Colors.amber
                                  ),
                                ),
                                SizedBox(height: 30,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(snapshot.data.accountHeadName,style: TextStyle(fontSize: 15),),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(child: InfoLeft(txt:'Guardian Name :  '),flex: 1,),
                                    Expanded(child: InfoText(txt:snapshot.data.guardian),flex: 1,),
                                  ],
                                ),
                                Divider(height: dividerHeight,),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: InfoLeft(txt:'Address :  '),flex: 1,),
                                    Expanded(child: InfoText(txt:snapshot.data.permMunicipality),flex: 1,),
                                  ],
                                ),
                                Divider(height: dividerHeight,),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: InfoLeft(txt:'Grade :  '),flex: 1,),
                                    Expanded(child: InfoText(txt:snapshot.data.grade),flex: 1,),
                                  ],
                                ),
                                Divider(height: dividerHeight,),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: InfoLeft(txt:'Stream :  '),flex: 1,),
                                    Expanded(child: InfoText(txt:snapshot.data.stream),flex: 1,),
                                  ],
                                ),
                                Divider(height: dividerHeight,),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: InfoLeft(txt:'Guardian No. :  '),flex: 1,),
                                    Expanded(child: InfoText(txt:snapshot.data.phoneNumber),flex: 1,),
                                  ],
                                ),
                                Divider(height: dividerHeight,),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: InfoLeft(txt:'Student No. :  '),flex: 1,),
                                    Expanded(child: snapshot.data.mobileNumber != null ? InfoText(txt:snapshot.data.mobileNumber):
                                    InfoText(txt:'-'),flex: 1,),
                                  ],
                                ),
                                Divider(height: dividerHeight,),

                              ],
                            ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner.
                          return Loader();
                        },
                      ),
                    ),


                    )))));
  }
}



Future<Album> fetchAlbum() async {
  SharedPreferences prefs= await SharedPreferences.getInstance();
  int schoolId = prefs.getInt('schoolId');
  int studentId = prefs.getInt('studentId');
  print('${Urls.BASE_API_URL}/login/studentprofile?schoolid=$schoolId&studentid=$studentId');
  final response =
  await http.get('${Urls.BASE_API_URL}/login/studentprofile?schoolid=$schoolId&studentid=$studentId');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {

  final String guardian;
  final String accountHeadName;
  final String phoneNumber;
  final String permMunicipality;
  final String mobileNumber;
  final String grade;
  final String stream;

  Album({this.guardian,this.accountHeadName,this.phoneNumber,this.mobileNumber,this.permMunicipality,
  this.grade,this.stream});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      guardian: json['Guardian'],
      accountHeadName: json['AccountHeadName'],
      phoneNumber: json['PhoneNumber'],
      mobileNumber: json['MobileNumber'],
      permMunicipality: json['PermMunicipality'],
      grade: json['Grade'],
      stream: json['Stream'],
    );
  }
}


class InfoText extends StatelessWidget {
  InfoText({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(txt,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
      alignment: Alignment.topLeft,
    );
  }
}
class InfoLeft extends StatelessWidget {
  InfoLeft({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(txt,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
      alignment: Alignment.topRight,
    );
  }
}
