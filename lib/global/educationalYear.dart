import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/pallate.dart';
import 'service/offlineYear.dart';
import 'dart:async';
import 'dart:convert';
class EducationalYear extends StatefulWidget {
  @override
  _EducationalYearState createState() => _EducationalYearState();
}
class _EducationalYearState extends State<EducationalYear> {
  int changedNowYearId;
  int selectedYearId=0;
  String selectedYear='';
  String changedNowYear;
  @override
  void initState(){
    getCurrentYear();
    super.initState();
  }

  getCurrentYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedYear = prefs.getString('educationalYearName');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Year:',style: TextStyle(fontStyle: FontStyle.italic,
                fontSize: 15,fontWeight: FontWeight.w600),),
            SizedBox(width: 15,),
            InkWell(
              onTap: (){_showDialog();},
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          selectedYear == '' ?
                          Text('yyyy',style: TextStyle(
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                              fontSize: 14.5,
                              fontStyle: FontStyle.italic,
                              color: Colors.black12
                          ),):
                          Text('$selectedYear',style: TextStyle(
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
                        width: 60,
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
                    child: FutureBuilder<List<OfflineFeeYear>>(
                      future: FetchOffline(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) ;
                        return snapshot.hasData ?
                        CupertinoPicker(
                          itemExtent: 60.0,
                          backgroundColor: Color(0x00000000),
                          onSelectedItemChanged: (index)async {
                            changedNowYear = snapshot.data[index].sYearName;
                            changedNowYearId = snapshot.data[index].educationalYearID;
                          },
                          children: new List<Widget>.generate(snapshot.data.length, (index) {
                            changedNowYear = snapshot.data[0].sYearName;
                            changedNowYearId = snapshot.data[0].educationalYearID;
                            return Align(
                              alignment: Alignment.center,//
                              child: Text(snapshot.data[index].sYearName,
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
                    selectedYear = changedNowYear;
                    selectedYearId = changedNowYearId;
                  });
                  prefs.setInt('educationalYearIdAttendance',changedNowYearId);
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
