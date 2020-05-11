import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewModal.dart';
import '../service/subAcademicPeriod.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../subResult/subResult.dart';
import '../Routine/routine.dart';
class Modal {
  mainBottomSheet(BuildContext context, title,id,exams) {

    ViewModal viewModal = new ViewModal();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FadeAnimation(
            0.6, Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  color: Colors.white

                ),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,10,10,10),
                            child: Text(title,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
                              ,),
                          ),
                        ),
                        Container(
                          child:Padding(
                            padding: const EdgeInsets.fromLTRB(10,12,10,12),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Htxt(title:'Sn'),flex: 1,),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Htxt(title:'Exam Name'),
                                ),flex: 6,),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Htxt(title:'Date'),
                                ),flex: 4,),
                                Expanded(child: Htxt(title:'    Actions'),flex: 4,),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              gradient: purpleGradient,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(2, 2)
                                )
                              ]
                          ),
                        ),
                        Container( height: 440,
                          padding: EdgeInsets.only(bottom: 168),
                          child: FutureBuilder<List<SubAcademicPeriod>>(
                              future: FetchsubAcademicPeriod(http.Client()),
                              builder: (context, snapshot) {
                                if (snapshot.hasError);
                                if(snapshot.hasData) {
                                  return snapshot.data.length > 0 ?
                                  ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return DataField(
                                          examName:snapshot.data[index].examName,
                                          fromDate:snapshot.data[index].fromDate,
                                          toDate:snapshot.data[index].toDate,
                                          examId:snapshot.data[index].examId,
                                          sn:index,
                                        );
                                      }
                                  ) : Center(child: Empty());
                                }else {
                                  return Loader();
                                }
                              }),
                        ),

//                    Container(height: 1,color: Colors.black12,),
                      ],
                    ),

                  ],
                ),
            ),
          );
        });
  }



}

class Btxt1 extends StatelessWidget {
  Btxt1({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title.replaceAll('T', '\n'),style: TextStyle(
      letterSpacing: 0.4,fontSize: 13  ));
  }
}


class DataField extends StatelessWidget {
  DataField({this.examName,this.fromDate,this.toDate,this.examId,this.sn});
  final String examName,fromDate,toDate;
  final int examId;
  final int sn;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
                            padding: const EdgeInsets.fromLTRB(10,12,10,12),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: Btxt(title:'${sn+1}'),flex: 1,),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Btxt(title:examName),
                                ),flex: 5,),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Btxt1(title:fromDate),
                                      SizedBox(height: 6,),
                                      Btxt1(title:toDate),
                                    ],
                                  ),
                                ),flex: 4,),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)
                                            ),
                                            color: Colors.red[400].withOpacity(0.8)
                                        ),
                                        child:InkWell(
                                          onTap: () async{
                                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setInt('examId', examId);
                                            showDialog<void>(
                                                context: context,// user must tap button!
                                                builder: (BuildContext context) {return SubResult();});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 6.5, 10, 6.5),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.remove_red_eye,size: 12,color: Colors.white,),SizedBox(width:5),
                                                  Text('Result',style: TextStyle(color: Colors.white,
                                                      fontSize: 12
                                                  ),),
                                                ],
                                              ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)
                                            ),
                                            color: Colors.orange[400].withOpacity(0.8)
                                        ),
                                        child: InkWell(
                                          onTap: () async{
                                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setInt('examId', examId);
                                            showDialog<void>(
                                            context: context,// user must tap button!
                                            builder: (BuildContext context) {return Routine();});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(9, 6.5, 9, 6.5),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.remove_red_eye,size: 12,color: Colors.white,),SizedBox(width:5),
                                                Text('Routine',style: TextStyle(color: Colors.white,
                                                    fontSize: 12
                                                ),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),flex: 3,),
                              ],
                            ),
                          ),
        Container(
          height: 1,
          decoration: BoxDecoration(
            color: Colors.black12,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(2, 2)
                )
              ]
          ),
        )
      ],
    );
  }
}
