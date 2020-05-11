import 'package:flutter/material.dart';
import 'package:sajiloschool/student/sidebar/sideBar.dart';
import '../../utils/fadeAnimation.dart';
import 'package:sajiloschool/student/notification/notificationBoard.dart';
import 'pages/educationalYearFees.dart';
import 'modal.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Fees extends StatefulWidget {
  @override
  _FeesState createState() => _FeesState();
}

class _FeesState extends State<Fees> {
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

    ))

    );
  }
}

class BodySection extends StatelessWidget {
  BodySection({this.connected});
  final bool connected;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 70,),
        FadeAnimation(0.4, EducationalYear(),),
        SizedBox(height: 15,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: FadeAnimation(
            0.4, Column(
              children: <Widget>[
                Container(
                  height: 100,
//                  child: TabList(title:'Paid fees',btn:'View Detail',action:'paid'),
                  child: _hwDate(context,'Paid fees','View Detail','paid'),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 100,
                  child: _hwDate(context,'Assigned Fees','View Detail','unpaid'),
//                  child: TabList(title:'Assigned Fees',btn:'View Detail',action:'unpaid'),
                ),
                SizedBox(height: 5,),
                Container(
                  height: 100,
                  child:  _hwDate(context,'Remaining Fees','View Detail','remaining'),
//                  TabList(title:'Remaining Fees',btn:'View Detail',action:'remaining'),

    ),

              ],
            ),
          ),
        ),
      ],
    );
  }
  Modal modal = new Modal();
  Card _hwDate(BuildContext context,String title,String btn,String action) {
    return Card(
      elevation: 4,
      color: Color(0x000000),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xfffdf9f7),
            borderRadius: BorderRadius.all(
                Radius.circular(10)
            )
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10,10,10,10),
          child: Row(
            children: <Widget>[
              Text(title,
                style: TextStyle(fontWeight: FontWeight.w600,
                    color: Pallate.cardtxtcolor,fontSize: 14.5,
                    fontStyle: FontStyle.italic
                ),),
              Expanded(child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Align(child: Container(decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(4)
                            )
                        ), child: Container(
                          decoration: BoxDecoration(
                              gradient: lightGradient,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14)
                              )
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14)
                                ),
                                color: Colors.green[400].withOpacity(0.8)
                            ),
                          ),
                        )),alignment: Alignment.topRight,),
                        SizedBox(width: 15,),
                        Align(child: Container(decoration: BoxDecoration(
                            gradient: lightGradient,
                            borderRadius: BorderRadius.all(
                                Radius.circular(14)
                            )
                        ), child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(14),
                            ), color:Colors.red[400].withOpacity(0.78),
                          ),

                          child: InkWell(
                            onTap: (){
                              modal.mainBottomSheet(context,action);

                            },
                            child: Padding(

                              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.remove_red_eye,size: 13,color: Colors.white,),SizedBox(width: 5,),
                                  Text(btn,style: TextStyle(color: Colors.white,
                                      fontSize: 13),),
                                ],
                              ),
                            ),
                          ),
                        )),alignment: Alignment.topRight,),
                      ],
                    ),
                  ],
                ),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}










