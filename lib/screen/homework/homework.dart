import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/sideBar.dart';
import '../../utils/fadeAnimation.dart';
import '../../utils/pallate.dart';
import 'homeworkData.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:sajiloschool/screen/notification/notificationBoard.dart';
import 'package:fluttertoast/fluttertoast.dart';
class BodySection extends StatefulWidget {
  @override
  _BodySectionState createState() => _BodySectionState();
}
class _BodySectionState extends State<BodySection> {
  bool loadDate = false;
  String logoImage;
  String date =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now())}');
  void initState() {
    setDate();
//    getImageLink();
    super.initState();
  }
  setDate() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('hwDate',date);
  }
//  getImageLink() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      logoImage = prefs.getString('logoImage');
//    });
//  }
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
          child: ListView(
            children: <Widget>[
              SizedBox(height: 70,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('Date:',style: TextStyle(fontStyle: FontStyle.italic,
                          fontSize: 15,fontWeight: FontWeight.w600),),
                      SizedBox(width: 15,),
                      InkWell(
                        onTap: () async{
                          SharedPreferences prefs= await SharedPreferences.getInstance();
                          String old = prefs.getString('hwDate');
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
                          prefs.setString('hwDate',date);
                          if(old != date) {
                           setState(() {
                             loadDate = true;
                           });
                          }

                        },
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('$date',style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.8,
                                        fontSize: 14.5,
                                        fontStyle: FontStyle.italic
                                    ),),
                                    SizedBox(width: 5,),
                                    Icon(Icons.arrow_downward,size: 16,),
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  height: 2,
                                  width: 105,
                                  decoration: BoxDecoration(
                                      gradient: purpleGradient
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: 14,),
              FadeAnimation(
                0.5, Container(child:
              MainRow(),
                decoration: BoxDecoration(
                    gradient: purpleGradient
                ),),
              ),
              Container( height: 440,
                decoration: BoxDecoration(
                    color: Color(0xfffbf9e7).withOpacity(0.5)
                ),
                child: loadDate ? HomeworkData() :HomeworkData1(),
              ),



            ],
          ),
        ),

    );
  }

}


class HomeWork extends StatefulWidget {
  @override
  _HomeWorkState createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Expanded(child: Txt(title:'SN'),flex: 1,),
          Expanded(child: Txt(title:'Subject'),flex: 2,),
          Expanded(child: Txt(title:'Homework'),flex: 5,),
        ],
      ),
    );
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



