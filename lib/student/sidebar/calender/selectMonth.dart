import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'dart:async';
class SelectMonth extends StatefulWidget {
  @override
  _SelectMonthState createState() => _SelectMonthState();
}
class _SelectMonthState extends State<SelectMonth> {
  int selectedMonthId;
  String selectedMonth;
  String currentMonth;
  @override
  void initState() {
    getMonthName(0,1,'Baisakh');
    super.initState();
  }
  int indexMonthCalender;
  getMonthName(index,id,name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String currentMonth =prefs.getString('educationalMonthNameAttendance');
    prefs.setInt('studentCalenderMonthId',id);
    setState(() {
      selectedMonth = name;
    });
    print('moth is $name');print('moth Id is $id');
    indexMonthCalender = index;
  }
  final staticMonth = [
    {
      "Month": 1,
      "MonthName": "Baisakh"
    },
    {
      "Month": 2,
      "MonthName": "Jestha"
    },
    {
      "Month": 3,
      "MonthName": "Ashadh"
    },
    {
      "Month": 4,
      "MonthName": "Shrawan"
    },
    {
      "Month": 5,
      "MonthName": "Bhadra"
    },
    {
      "Month": 6,
      "MonthName": "Ashoj"
    },
    {
      "Month": 7,
      "MonthName": "Kartik"
    },
    {
      "Month": 8,
      "MonthName": "Mangsir"
    },
    {
      "Month": 9,
      "MonthName": "Poush"
    },
    {
      "Month": 10,
      "MonthName": "Magh"
    },
    {
      "Month": 11,
      "MonthName": "Falgun"
    },
    {
      "Month": 12,
      "MonthName": "Chaitra"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: (){_showDialog();},
          child: Row(
            children: <Widget>[
          Text('Month:',style: TextStyle(fontStyle: FontStyle.italic,
                                            fontSize: 15,fontWeight: FontWeight.w600),),
                                        SizedBox(width: 7,),
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
//                  padding: EdgeInsets.only(bottom: 40),
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20,10,20,0),
                    child:
                    Center(
                      child: ListView.builder(
                          itemCount: staticMonth.length,
                          itemBuilder: (context,int index) {
                            return
                              index == indexMonthCalender ? Container(
                                color: Colors.orange[400],
                                child: InkWell(
                                  onTap: (){
                                    getMonthName(index,staticMonth[index]['Month'],staticMonth[index]['MonthName']);

                                    Timer(Duration(milliseconds: 100), () {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 8.5),
                                        child: Center(child: Text('${staticMonth[index]['MonthName']}',style: TextStyle(
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
                                  onTap: () {
                                    getMonthName(index,staticMonth[index]['Month'],staticMonth[index]['MonthName']);
                                    Timer(Duration(milliseconds: 100), () {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 8.5),
                                        child: Center(child: Text('${staticMonth[index]['MonthName']}')),
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
                      ),

                    )
                ),
              ),
            ),

            elevation: 4,
          );}
    );

  }


}
