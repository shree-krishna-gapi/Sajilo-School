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
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xfffbf9e7),
              ),
              height: 260,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)
                        ),
                        gradient: purpleGradient
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,11,10,11
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(child: RoutinHead(head:'Date'),width:80),
                              Expanded(child: RoutinHead(head:'Subject'),flex: 3,),
                              Expanded(child: RoutinHead(head:'Homework'),flex: 4),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,8,10,8),
                    child: Row(
                      children: <Widget>[
                        Container(child: Text(homeworkDates),width: 80,),
                        Expanded(child: Text(subjectNames),flex: 3,),
                        Expanded(child: Text(homeworkDetails),flex: 4,),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 1, color: Colors.black12,)

                ],
              ),

            ),


          ),
        ),
      ),
    );
  }
}


class RoutinHead extends StatelessWidget {
  final String head;
  RoutinHead({this.head});

  @override
  Widget build(BuildContext context) {
    return Text(head,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.4,
      ),);
  }
}
