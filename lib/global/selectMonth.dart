import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/pallate.dart';
import 'service/offlineMonth.dart';
import 'dart:async';
import 'dart:convert';

class SelectMonth extends StatefulWidget {
  @override
  _SelectMonthState createState() => _SelectMonthState();
}
class _SelectMonthState extends State<SelectMonth> {
  int changedNowMonthId;
  int selectedMonthId=0;
  String selectedMonth;
  String changedNowMonth;
  String selectedMonthNow;
  @override
  void initState() {
    getMonthName();
    super.initState();
  }
  int indexMonthAttendance;
  getMonthName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentMonth =prefs.getString('educationalMonthNameAttendance');
    indexMonthAttendance = prefs.getInt('indexMonthAttendance');
    setState(() {
      selectedMonth = currentMonth;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: (){_showDialog();},
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('$selectedMonth',style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              fontSize: 15,
                              fontStyle: FontStyle.italic
                          ),),
                          SizedBox(width: 5,),
                          Icon(Icons.arrow_downward,size: 16,),
                        ],
                      ),
                      SizedBox(height: 3,),
                      Container(
                        height: 2,
                        width: 85,
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
        );
  }
  Future<void> _showDialog() async {

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
                  padding: EdgeInsets.only(bottom: 40),
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,15,20,10),
                    child: FutureBuilder<List<OfflineFeeMonth>>(
                      future: FetchOfflineMonth(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) ;
                        return snapshot.hasData ?
                        ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index) {
                              return
                                index == indexMonthAttendance ? Container(
                                  color: Colors.orange[400],
                                  child: InkWell(
                                    onTap: ()async {
                                      indexMonthAttendance = index;
                                      setState(() {
                                        selectedMonth = snapshot.data[index].monthName;
                                      });
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setInt('indexMonthAttendance',index);
                                      prefs.setString('educationalMonthNameAttendance',snapshot.data[index].monthName);
                                      prefs.setInt('educationalMonthIdAttendance',snapshot.data[index].month);
                                      Timer(Duration(milliseconds: 100), () {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.5),
                                          child: Center(child: Text(snapshot.data[index].monthName,style: TextStyle(
                                              color: Colors.white
                                          ),)),
//                                    color: Colors.black12,
                                        ),
                                        Container(
                                          height: 1, color: Colors.black.withOpacity(0.05),
                                        )
                                      ],
                                    ),
                                  ),
                                ):
                                Container(
                                  child: InkWell(
                                    onTap: ()async {
                                      indexMonthAttendance = index;
                                      setState(() {
                                        selectedMonth = snapshot.data[index].monthName;
                                      });
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setInt('indexMonthAttendance',index);
                                      prefs.setString('educationalMonthNameAttendance',snapshot.data[index].monthName);
                                      prefs.setInt('educationalMonthIdAttendance',snapshot.data[index].month);
                                      Timer(Duration(milliseconds: 100), () {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.5),
                                          child: Center(child: Text(snapshot.data[index].monthName)),
//                                    color: Colors.black12,
                                        ),
                                        Container(
                                          height: 1, color: Colors.black.withOpacity(0.05),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                            }
                        ):Loader();
                      },
                    )
                ),
              ),
            ),

            elevation: 4,
          );}
    );

  }


}
