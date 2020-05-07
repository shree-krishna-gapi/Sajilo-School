import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:sajiloschool/auth/service/user.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:sajiloschool/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/sidebar/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'calender.dart';
import 'package:sajiloschool/screen/hh.dart';
import 'package:sajiloschool/global/service/offlineYear.dart';
import 'package:sajiloschool/global/service/offlineMonth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final bool isSidebarOpened = true;
  bool menuActive;
  final _animationDuration = const Duration(milliseconds: 200);
  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void appBarSlide() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted= animationStatus == AnimationStatus.completed;
    if(isAnimationCompleted) {
      menuActive = false;
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    }else {
      menuActive = true;
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: isSidebarOpenedStream,
        builder: (context, isSideBarOpenedAsync)
        {
          return AnimatedPositioned(
              duration: _animationDuration,
              top: 0,
              bottom: 0,
              left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
              right: isSideBarOpenedAsync.data ? 0 : screenWidth - 36,
              child: Row(
                children: <Widget>[
                  Expanded(child: Container(
                      decoration: BoxDecoration(
                        gradient: purpleGradient,
                      ),
                      child: SideBarBody()
                  ),

                  ),
                  Container(
                    color: menuActive == true ? Colors.black26 : Color(0x00000000),

                    child: InkWell(
                      onTap: (){
                        menuActive == true ? appBarSlide() : null;
                      },
                      child: Align(
                        alignment: Alignment(0, -0.9),
                        child: InkWell(
                          onTap: () {
                            appBarSlide();
                          },
                          child: Container(
                            child: ClipPath(
                              clipper: CustomMenuClipper(),
                              child: Container(
                                width: 36,
                                height: 110,
                                decoration: BoxDecoration(
                                  gradient: purpleGradient,
                                ),
                                alignment: Alignment.centerLeft,
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.menu_close,
                                  progress: _animationController.view,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}


class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


class SideBarBody extends StatefulWidget {
  @override
  _SideBarBodyState createState() => _SideBarBodyState();
}

class _SideBarBodyState extends State<SideBarBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: purpleGradient
        ),
      child: ListView(
        children: <Widget>[
          Container(
            child: new UserAccountsDrawerHeader(
//              accountName: Text(studentName),
//              accountEmail: Text('$studentName@demo.com'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: 30,
                      color: Colors.amber
                  ),
                ),
              ),margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color(0x0000000), const Color(0xD9333333)],
                      stops: [0.0,0.9], begin: FractionalOffset(0.0, 0.0), end: FractionalOffset(0.0, 4.0))
              ),
            ),
          ),

          Container(
              padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.fromLTRB(15,12,15,12),
//                  child: InkWell(
//                    onTap: () {
//                      showDialog<void>(
//                          context: context,
//                          barrierDismissible: true, // user must tap button!
//                          builder: (BuildContext context) {
//                            return Profile();
//                          });
//                    },
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        ListText(txt: 'Profile Details',),
//                        Icon(Icons.contact_mail,color: SideBarColor.color),
//                      ],
//                    ),
//                  ),
//                ),
                Container(color: Colors.black12.withOpacity(0.05),height: 1,),
                Container(
                  padding: EdgeInsets.fromLTRB(15,12,15,12),
                  child: InkWell(
                    onTap: () {
                      getYear();
//                      showDialog<void>(
//                          context: context,// user must tap button!
//                          builder: (BuildContext context) {
//                            return Calender(
//                            );
//                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ListText(txt: 'Calender',),
                        Icon(Icons.calendar_today,color: SideBarColor.color),
                      ],
                    ),
                  ),
                ),
                Container(color: Colors.black12.withOpacity(0.05),height: 1,),
                Container(
                  padding: EdgeInsets.fromLTRB(15,12,15,12),
                  child: InkWell(
                    onTap: () {
                      signOut();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ListText(txt: 'Sign Out',),
                        Icon(Icons.settings_power,color: SideBarColor.color),
                      ],
                    ),
                  ),
                ),
                Container(color: Colors.black12.withOpacity(0.05),height: 1,),
                SizedBox(height: 35,),

                InkWell( onTap: _launchURL,
                  child: ListTile(leading: Container(width: 65,child: SvgPicture.asset('assets/logo/drawerlogo.svg',
                    fit: BoxFit.fitWidth,color: Colors.white.withOpacity(0.8),),),title:

                  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Developed By :',style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 14,color: SideBarColor.color.withOpacity(0.8),letterSpacing: 0.1,),),
                      SizedBox(height: 4,),
                      Text('MiningInfosys.com.np',style: TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 12,color: SideBarColor.color.withOpacity(0.8),letterSpacing: 0.1),),
                      SizedBox(height: 2,),
                      Container(height: 1, color: Colors.white.withOpacity(0.7), width: 122,),
                    ],
                  )

                  ),
                ),
              ],
            ),

          ),

        ],
      ),
    );
  }
  int changedNowYearId;
  int selectedYearId=0;
  String selectedYear='';
  String changedNowYear;
  // Year
  //Month
  int changedNowMonthId;
  int selectedMonthId=0;
  String selectedMonth='Baisakh';
  String changedNowMonth;
  String selectedMonthNow;
  int indexYearSidebar;
  Future<void> getYear() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbf9e7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            content: Container(

              child: Column(
                children: <Widget>[
                  Container(
                    height: 50, color: Colors.black.withOpacity(0.04),
                    child: Align(alignment: Alignment.center,
                      child: Text('Educational Year',style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20,5,20,5),
                          child: FutureBuilder<List<OfflineFeeYear>>(
                            future: FetchOffline(http.Client()),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) ;
                              if(snapshot.hasData) {
                                return snapshot.data.length > 0 ?
                                ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return
                                        index == indexYearSidebar ? Container(
                                          color: Colors.orange[400],
                                          child: InkWell(
                                            onTap: () {
                                              indexYearSidebar = index;
                                              changedNowYearId =
                                                  snapshot.data[index]
                                                      .educationalYearID;
                                              Navigator.of(context).pop();
                                              Timer(Duration(
                                                  milliseconds: 100), () {
                                                getMonth(changedNowYearId);
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.5),
                                                  child: Center(child: Text(
                                                    snapshot.data[index]
                                                        .sYearName,
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    ),)),
//                                    color: Colors.black12,
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        ) :
                                        Container(
                                          child: InkWell(
                                            onTap: () async {
                                              indexYearSidebar = index;
                                              changedNowYearId =
                                                  snapshot.data[index]
                                                      .educationalYearID;
                                              Navigator.of(context).pop();
                                              Timer(Duration(
                                                  milliseconds: 100), () {
                                                getMonth(changedNowYearId);
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.5),
                                                  child: Center(child: Text(
                                                      snapshot.data[index]
                                                          .sYearName)),
//                                    color: Colors.black12,
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                    }
                                ) : Empty();
                              } else {
                                return Loader();
                              }
                            },
                          )
                      ),
                    ),
                  ),


                ],
              ),
            ),
            elevation: 4,
          );}
    );

  }
  int indexMonthSidebar;
  getMonth(yearId) {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xfffbf9e7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            content: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 50, color: Colors.black.withOpacity(0.04),
                    child: Align(alignment: Alignment.center,
                      child: Text('Month',style: TextStyle(fontWeight: FontWeight.w500),),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20,5,20,5),
                          child: FutureBuilder<List<OfflineFeeMonth>>(
                            future: FetchOfflineMonth(http.Client()),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) ;
                              if(snapshot.hasData) {
                                return snapshot.data.length > 0 ?
                                ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return
                                        index == indexMonthSidebar ? Container(
                                          color: Colors.orange[400],
                                          child: InkWell(
                                            onTap: () async{
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              changedNowMonthId =
                                                  snapshot.data[index]
                                                      .month;
                                              prefs.setInt('educationalYearIdCalender',changedNowYearId);
                                              prefs.setInt('monthIdCalender',changedNowMonthId);
                                              indexYearSidebar = index;
                                              Navigator.of(context).pop();
                                              Timer(Duration(milliseconds: 100), () {
                                                showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: true, // user must tap button!
                                                    builder: (BuildContext context) {
                                                      return Calender();
                                                    });
                                              });
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
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        ) :
                                        Container(
                                          child: InkWell(
                                            onTap: () async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              changedNowMonthId =
                                                  snapshot.data[index]
                                                      .month;
                                              prefs.setInt('educationalYearIdCalender',changedNowYearId);
                                              prefs.setInt('monthIdCalender',changedNowMonthId);
                                              indexYearSidebar = index;
                                              Navigator.of(context).pop();
                                              Timer(Duration(milliseconds: 100), () {
                                                showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: true, // user must tap button!
                                                    builder: (BuildContext context) {
                                                      return Calender();
                                                    });
                                              });
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
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                    }
                                ) : Empty();
                              } else {
                                return Loader();
                              }
                            },
                          )
                      ),
                    ),
                  ),



                ],
              ),
            ),

            elevation: 4,
          );}
    );

  }
  _launchURL() async {
    String url = 'https://mininginfosys.com.np';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  signOut() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Wait();
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('teacherStatus',false);
    Timer(Duration(milliseconds: 200), () {
      Navigator.of(context).pop();
    });
    Timer(Duration(milliseconds: 400), () {
      Navigator.of(context).pop();
      showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return Success(txt: 'Sign Out',);
          }
      );
    });
    Timer(Duration(milliseconds: 600), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });

  }
}

class ListText extends StatelessWidget {
  ListText({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(txt,
        style: TextStyle(color: SideBarColor.color,fontSize: 15),),
      alignment: Alignment.centerLeft,
    );
  }
}

class SideBarColor {
  static Color color = Colors.white;
}