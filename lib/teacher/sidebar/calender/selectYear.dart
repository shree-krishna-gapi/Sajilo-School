import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/pallate.dart';
import 'offlineYearService.dart';
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
  int indexYearCalender;
  getCurrentYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentYear = prefs.getString('educationalYearNameCalenderT');
    indexYearCalender = prefs.getInt('indexYearCalenderT');
    setState(() {
      selectedYear = currentYear;
    });
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
            SizedBox(width: 7,),
            InkWell(
              onTap: (){_showDialog();},
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
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

              child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,15,20,10),
                    child: FutureBuilder<List<OfflineFeeYear>>(
                      future: FetchOffline(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) ;
                        return snapshot.hasData ?
                        ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index) {
                              return
                                index == indexYearCalender ? Container(
                                  color: Colors.orange[400],
                                  child: InkWell(
                                    onTap: ()async {
                                      indexYearCalender = index;
                                      setState(() {
                                        selectedYear = snapshot.data[index].sYearName;
                                      });
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setInt('indexYearCalenderT',index);
                                      prefs.setString('educationalYearNameCalenderT',snapshot.data[index].sYearName);
                                      prefs.setInt('educationalYearIdCalenderT',snapshot.data[index].educationalYearID);
                                      Timer(Duration(milliseconds: 100), () {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.5),
                                          child: Center(child: Text(snapshot.data[index].sYearName,style: TextStyle(
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
                                      indexYearCalender = index;
                                      setState(() {
                                        selectedYear = snapshot.data[index].sYearName;
                                      });
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setInt('indexYearCalenderT',index);
                                      prefs.setString('educationalYearNameCalenderT',snapshot.data[index].sYearName);
                                      prefs.setInt('educationalYearIdCalenderT',snapshot.data[index].educationalYearID);
                                      Timer(Duration(milliseconds: 100), () {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.5),
                                          child: Center(child: Text(snapshot.data[index].sYearName)),
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
