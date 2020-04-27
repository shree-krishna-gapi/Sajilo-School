import 'package:flutter/material.dart';
import 'service/modalService.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/fadeAnimation.dart';
class Modal{
  mainBottomSheet(BuildContext context,name,roll,isMonthly,selectedMonth,fromDate,toDate){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return FadeAnimation(
            0.6, Container(
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
                    height: 60,
                    child: isMonthly ? Row(
                      children: <Widget>[
                        Text('  Student: $name'),Text(' Roll No. $roll'),Text(' Report of. $selectedMonth'),
                      ],
                    ):Row(
                      children: <Widget>[
                        Text('  Student: $name'),Text(' Roll No. $roll'),Text('Report from: $fromDate'),
                        Text('Report from: $toDate')
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                          topLeft:  Radius.circular(24),
                          topRight: Radius.circular(24),
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15,12,15,12),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: ModalTitle(txt:'SN'),flex: 1,),
                          Expanded(child: ModalTitle(txt: 'Date',),flex: 2,),
                          Expanded(child: ModalTitle(txt: 'Status',),flex: 3,),
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
                                          Expanded(child: SubModalTitle(txt:'${index+1}'),flex: 1,),
                                          Expanded(child: SubModalTitle(txt: '${snapshot.data[index].dateOfYearNepali}',),flex: 2,),
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
}



class ModalTitle extends StatelessWidget {
  ModalTitle({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(txt,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white,
        letterSpacing: 0.4, shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black38,
            offset: Offset(2.0, 2.0),
          ),
        ]));
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

