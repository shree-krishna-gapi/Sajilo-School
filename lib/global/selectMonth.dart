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
  String selectedMonth='Baisakh';
  String changedNowMonth;
  String selectedMonthNow;
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
                          selectedMonth == '' ?
                          Text('Month',style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.black26
                          ),):
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

              child: Container( height: 180,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,20,20,10),
                    child: FutureBuilder<List<OfflineFeeMonth>>(
                      future: FetchOfflineMonth(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) ;
                        return snapshot.hasData ?
                        CupertinoPicker(
                          itemExtent: 60.0,
                          backgroundColor: Color(0x00000000),
                          onSelectedItemChanged: (index)async {

                            changedNowMonth = snapshot.data[index].monthName;
                            changedNowMonthId = snapshot.data[index].month;
                          },
                          children: new List<Widget>.generate(snapshot.data.length, (index) {
                            changedNowMonth = snapshot.data[0].monthName;
                            changedNowMonthId = snapshot.data[0].month;
                            return Align(
                              alignment: Alignment.center,//
                              child: Text(snapshot.data[index].monthName,
                                style: TextStyle(
                                    fontSize: 17,fontWeight: FontWeight.w600, letterSpacing: 0.8,color: Colors.black
                                ),),
                            );
                          }),
                        ):Loader();
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
                  setState(() {
                    selectedMonth = changedNowMonth;
                  });
                  prefs.setInt('monthId',changedNowMonthId);
                  Duration(milliseconds: 500);
                  Navigator.of(context).pop();

                },
              ),
            ],
            elevation: 4,
          );}
    );

  }


}
