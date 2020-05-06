import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/record.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'modal.dart';
import 'dart:async';

class RecordShow extends StatefulWidget {
  @override
  _RecordShowState createState() => _RecordShowState();
}

class _RecordShowState extends State<RecordShow> {
  Modal modal = new Modal();
  @override
  void initState() {
    titleInfo();
    super.initState();
  }
  String selectedMonth;
  String fromDate;
  String toDate;
  bool isMonthly;
  titleInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isMonthly = prefs.getBool('isMonthlyPer');
    if(isMonthly == true) {
      setState(() {
        selectedMonth = prefs.getString('monthName');
      });
    }
    else {
      setState(() {
        fromDate = prefs.getString('fromDatePer');
        toDate =prefs.getString('fromDatePer');
      });
    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: purpleGradient
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(child: titleHead(context,'SN'),width:31),
                    Expanded(child: titleHead(context,'Name')),
                    Container(child: titleHead(context,'Roll No'),width:68,),
                    Container(child: titleHead(context,'Present'),width:68,),
                    Container(child: titleHead(context,'Action'),width:68,),
                  ],
                ),
              ),
              Expanded(
                  child: Container(color: Colors.yellow[600].withOpacity(0.1),
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: FutureBuilder<List<GetRecord>>(
                        future: fetchRecord(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          return snapshot.hasData ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FadeAnimation(
                                0.2, Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: <Widget>[
                                      Container(child: subTitle(context,'${index+1}'),width:31),
                                      Expanded(child: subTitle(context,'${snapshot.data[index].studentName}')),
                                      Container(child: subTitle(context,'${snapshot.data[index].rollNo}'),width:68,),
                                      Container(child: subTitle(context,'${snapshot.data[index].presentDays}'),width:68,),
                                      Container(child: InkWell(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Details',style: TextStyle(color: Colors.orange,
                                            fontSize: 14.5
                                          ),),
                                          Container(height: 1,color: Colors.orange[600], width: 46,)
                                        ],
                                      ),
                                      onTap: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setInt('studentIdPer', snapshot.data[index].studentId);
                                          modal.mainBottomSheet(context,'${snapshot.data[index].studentName}',
                                              '${snapshot.data[index].rollNo}',isMonthly,selectedMonth,fromDate,toDate
                                          );
                                      },
                                      ),width: 68,),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ) : Loader(); }),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
//  perDetail() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    int schoolId = prefs.getInt('schoolId');
//    int yearId = prefs.getInt('attenendanceEducationalYearId');
//    bool isMonthly = prefs.getBool('isMonthlyPer');
//    int monthId = prefs.getInt('monthIdPer');
//    String fromDate = prefs.getString('fromDatePer');
//    String toDate=  prefs.getString('fromDatePer');
//    var url ="http://192.168.1.89:88/Api/Login/GetAttendanceOfStudent?schoolId=$schoolId&"
//        "yearId=$yearId&monthId=$monthId&studentId=322&fromDate=$fromDate&toDate=$toDate";
//  }
  Text titleHead(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4, shadows: [
      Shadow(
        blurRadius: 4.0,
        color: Colors.black12,
        offset: Offset(2.0, 2.0),
      ),
    ], color: Colors.white ));
  }
  Text subTitle(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontSize: 14.5,
        letterSpacing: 0.2,));
  }
}
