import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/pallate.dart';
class SelectFromDate extends StatefulWidget {
  @override
  _SelectFromDateState createState() => _SelectFromDateState();
}
class _SelectFromDateState extends State<SelectFromDate> {
  String selectToDate =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now())}');
  String selectFromDate =('${NepaliDateFormat("y-MM-dd",).format(NepaliDateTime.now().add(Duration(days: -16)))}');
  void initState() {
    setDate();
    super.initState();
  }
  Future setDate()async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    prefs.setString('AttendanceSelectToDate',selectToDate);
    prefs.setString('AttendanceSelectFromDate',selectFromDate);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text('From:  ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),),
          InkWell(
            onTap: () async{
              SharedPreferences prefs= await SharedPreferences.getInstance();
              NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
                context: context,
                initialDate: NepaliDateTime.now(),  //NepaliDateTime.now(),
                firstDate: NepaliDateTime(2000),
                lastDate: NepaliDateTime(2090),
                language: Language.english,
                initialDatePickerMode: DatePickerMode.day,
              );

              setState(() {
                selectFromDate=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
              });
              prefs.setString('AttendanceSelectFromDate',selectFromDate);
            },
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('$selectFromDate',style: TextStyle(
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
          SizedBox(width: 4,),
          Text(' To:  ',style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),),
          InkWell(child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('$selectToDate',style: TextStyle(
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
                    width: 102,
                    decoration: BoxDecoration(
                        gradient: purpleGradient
                    ),
                  )
                ],
              )

            ],
          ),
            onTap: () async{
              SharedPreferences prefs= await SharedPreferences.getInstance();
              NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
                context: context,
                initialDate: NepaliDateTime.now(),  //NepaliDateTime.now(),
                firstDate: NepaliDateTime(2000),
                lastDate: NepaliDateTime(2090),
                language: Language.english,
                initialDatePickerMode: DatePickerMode.day,
              );

              setState(() {
                selectToDate=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
              });
              prefs.setString('AttendanceSelectToDate',selectToDate);
            },
          ),

        ],
      ),
    );
  }
}
