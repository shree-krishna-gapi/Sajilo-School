import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'service/modalService.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/fadeAnimation.dart';
class Modal{
  mainBottomSheet(BuildContext context,name,roll,isMonthly,selectedMonth,fromDate,toDate){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context){
          return FadeAnimation(
            0.6, Container(
              height: 400,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(24),
                  topRight: Radius.circular(24),
                )
            ),
            child: ListView(
              children: <Widget>[
                Container(
//                    height: 60,
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 7),
                    child: isMonthly ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(child: keyText(context,"Name :"),width: 60,),
                                  valueText(context,"$name"),
                                ],
                              ),
                              SizedBox(height: 3,),
                              Row(
                                children: <Widget>[
                                  Container(child: keyText(context,"Roll No :"),width: 60,),
                                  valueText(context,"$roll"),
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            keyText(context,'Report of. '),
                            keyTextHead(context,'$selectedMonth'),
                          ],
                        )
                      ],
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(child: keyText(context,"Name :"),width: 60,),
                                  valueText(context,"$name"),
                                ],
                              ),
                              SizedBox(height: 3,),
                              Row(
                                children: <Widget>[
                                  Container(child: keyText(context,"Roll No. :"),width: 60,),
                                  valueText(context,"$roll"),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                keyText(context,'From: '),
                                keyTextHead(context,'$fromDate'),
                              ],
                            ),
                            SizedBox(height: 3,),
                            Row(
                              children: <Widget>[
                                keyText(context,'To: '),
                                keyTextHead(context,'$fromDate'),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: purpleGradient,
//                      borderRadius: BorderRadius.only(
//                        topLeft:  Radius.circular(24),
//                        topRight: Radius.circular(24),
//                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,12,15,12),
                    child: Row(
                      children: <Widget>[
                        Container(child: ModalTitle(txt:'Sn'),width: 30,),
                        Container(child: ModalTitle(txt: 'Date',),width: 90,),
                        Expanded(child: ModalTitle(txt: 'Status',)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 380,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,12,15,12),
                    child: FutureBuilder<List<AttendancePerStudents>>(
                        future: fetchService(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ?
                            ListView.builder(
                                itemCount: (snapshot.data == null && snapshot.data.length==0) ? 0 : snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: <Widget>[
                                        Container(child: SubModalTitle(txt:'${index+1}'),width: 30,),
                                        Container(child: SubModalTitle(txt: '${snapshot.data[index].dateOfYearNepali}',),width: 90,),
                                        Expanded(child: snapshot.data[index].isPresent?
                                        SubModalTitle(txt: 'Present',):
                                        SubModalTitle(txt: '*Absent',)
                                          ,flex: 3,),
                                      ],
                                    ),
                                  );
                                }
                            ) :
                            Align(
                                alignment: Alignment.center,
                                child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                                  letterSpacing: 0.4,),)
                            );
                          } else {
                            return Loader();
                          }
                        }),

//                            ],
//                          ),
                  ),
                ),
              ],
            ),
          ),
          );
        }
    );
  }
  Text keyTextHead(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,fontStyle: FontStyle.italic
    ),);
  }
  Text keyText(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontWeight: FontWeight.w500
    ),);
  }
  Text valueText(BuildContext context,String txt) {
    return Text(txt,style: TextStyle(
        fontWeight: FontWeight.w500
    ),);
  }
}





class SubModalTitle extends StatelessWidget {
  SubModalTitle({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(txt,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,
      letterSpacing: 0.4, ));
  }
}

