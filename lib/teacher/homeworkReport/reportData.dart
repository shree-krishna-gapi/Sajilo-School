import 'package:flutter/material.dart';
//import 'package:school/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';


class ReportData extends StatelessWidget {
  ReportData({this.homeworkDates,this.homeworkDetails,this.subjectNames});
  final String homeworkDates;
  final String homeworkDetails;
  final String subjectNames;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x000000),
      body: InkWell( onTap: () {
        Navigator.of(context).pop();
      },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xfffbf9e7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                     Row(
                       children: <Widget>[
                         headText(context,'Subject:-  '),
                         subText(context,subjectNames)
                       ],
                     ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          headText(context,'Date:-  '),
                          subText(context,homeworkDates)
                        ],
                      ),
                      SizedBox(height: 5,),
                      headText(context,'Homework Task:'),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child:
                              subText(context,'sdfds I have a problem with button expanded in flutter, I need align the icon to the left of the'),
                          )
                        ],
                      ),



                    ],
                  ),width: double.infinity, ),
              ],
            ),
          ],
        )
      ),
    );
  }
  Text subText(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.5,letterSpacing: 0.2),);
  }
  Text headText(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Colors.black.withOpacity(0.8)),);
  }
}
