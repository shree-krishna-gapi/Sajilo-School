import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Testing1(),
      ),
    );
  }
}
class Testing1 extends StatefulWidget {
  @override
  _Testing1State createState() => _Testing1State();
}

class _Testing1State extends State<Testing1> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text('SN'),flex: 1,),
            Expanded(child: Text('Name'),flex: 4,),
            Expanded(child: Text('Roll No'),flex: 3,),
            Expanded(child: Text('Present'),flex: 3,),
            Expanded(child: Text('Action'),flex: 2,),
          ],
        ),
        Container(
            height: 600,
            color: Colors.yellow[600].withOpacity(0.1),
            width: double.infinity,
            child: FutureBuilder<List<GetRecord>>(
                future: fetchRecord(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError);
                  return snapshot.hasData ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FadeAnimation(
                        0.5, Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Text('${index+1}'),flex: 1,),
                              Expanded(child: Text('${snapshot.data[index].studentName}'),flex: 4,),
                              Expanded(child: Text('${snapshot.data[index].rollNo}'),flex: 3,),
                              Expanded(child: Text('${snapshot.data[index].presentDays}'),flex: 3,),
                              Expanded(child: InkWell(child: Text('Details',style: TextStyle(color: Colors.orange),),
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('studentIdPer', snapshot.data[index].studentId);
                                  modal.mainBottomSheet(context,'${snapshot.data[index].studentName}',
                                      '${snapshot.data[index].rollNo}',isMonthly,selectedMonth,fromDate,toDate
                                  );
                              },
                              ),flex: 2,),
                            ],
                          ),
                        ),
                      );
                    },
                  ) : Loader(); })
        ),
      ],
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

}
