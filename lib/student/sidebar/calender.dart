import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'calenderService.dart';
import 'package:http/http.dart' as http;
import 'calender/selectMonth.dart';
import 'calender/selectYear.dart';
class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  bool calenderSearch = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calender'),
          backgroundColor: Color(0xFF28588e),
        ),
      backgroundColor: Color(0x000000),
      body:Container(
                      decoration: BoxDecoration(

                        color: Color(0xfffbf9e7),
                      ),
                      child: Column(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container( padding: EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    EducationalYear(),
                                    SelectMonth(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 15,bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    color: Colors.orange,
                                  ),
                                  padding: EdgeInsets.fromLTRB(11,7,11,7),
                                  child: InkWell(onTap: () {
                                    setState(() {
                                      calenderSearch =! calenderSearch;
                                    });
                                  },
                                    child: Text('Search Attendance',style: TextStyle(color: Colors.white, shadows: [
                                      Shadow(
                                        blurRadius: 4.0,
                                        color: Colors.black12,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ]),),

                                  ),
                                ),
                              ),

                            ],
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
//                              color: Colors.orange,
                              gradient: purpleGradient,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: _title(context,'  SN'),flex: 1,),
                                Expanded(child: _title(context,'Date'),flex: 2,),
                                Expanded(child: _title(context,'  Day'),flex: 2,),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.only(left:4.0),
                                  child: _title(context,'Remark'),
                                ),flex: 3,),

                              ],
                            ),
                          ),
                          Expanded(
                              child: calenderSearch ? FutureBuilder<List<CalenderData>>(
                                  future: FetchCalender(http.Client()),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) ;
                                    if(snapshot.hasData) {
                                      return snapshot.data.length > 0 ? ListView.builder(
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            return

                                              snapshot.data[index].isHoliday ? Container(
                                                color: Colors.orange[400],
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4.5),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(child: Text('   ${index+1}',style: TextStyle(color: Colors.white),),flex: 1,),
                                                      Expanded(child: Text('${snapshot.data[index].dayOfYearNepali}',style: TextStyle(color: Colors.white)),flex: 2,),
                                                      Expanded(child: Text('  ${snapshot.data[index].dayName}',style: TextStyle(color: Colors.white)),flex: 2,),
                                                      Expanded(child: Padding(
                                                        padding: const EdgeInsets.only(left:4.0,right: 10),
                                                        child: snapshot.data[index].remark == null ? Text('-',style: TextStyle(color: Colors.white)) :
                                                        Text('${snapshot.data[index].remark}',style: TextStyle(color: Colors.white)),
                                                      ),flex: 3,)
                                                    ],
                                                  ),
                                                ),
                                              ): Padding(padding: const EdgeInsets.symmetric(vertical: 4.5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(child: Text('   ${index+1}'),flex: 1,),
                                                    Expanded(child: Text('${snapshot.data[index].dayOfYearNepali}'),flex: 2,),
                                                    Expanded(child: Text('  ${snapshot.data[index].dayName}'),flex: 2,),
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.only(left:4.0,right: 10),
                                                      child: snapshot.data[index].remark == null ?Text('-') : Text('${snapshot.data[index].remark}'),
                                                    ),flex: 3,)
                                                  ],

                                                ),
                                              );

                                          }
                                      ) :Empty();
                                    } else {
                                      return Loader();
                                    }



                                  } )
                            : FutureBuilder<List<CalenderData1>>(
                                future: FetchCalender1(http.Client()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) ;
                                  if(snapshot.hasData) {
                                    return snapshot.data.length > 0 ? ListView.builder(
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return

                                            snapshot.data[index].isHoliday ? Container(
                                              color: Colors.orange[400],
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.5),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(child: Text('   ${index+1}',style: TextStyle(color: Colors.white),),flex: 1,),
                                                    Expanded(child: Text('${snapshot.data[index].dayOfYearNepali}',style: TextStyle(color: Colors.white)),flex: 2,),
                                                    Expanded(child: Text('  ${snapshot.data[index].dayName}',style: TextStyle(color: Colors.white)),flex: 2,),
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.only(left:4.0,right: 10),
                                                      child: snapshot.data[index].remark == null ? Text('-',style: TextStyle(color: Colors.white)) :
                                                      Text('${snapshot.data[index].remark}',style: TextStyle(color: Colors.white)),
                                                    ),flex: 3,)
                                                  ],
                                                ),
                                              ),
                                            ): Padding(padding: const EdgeInsets.symmetric(vertical: 4.5),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(child: Text('   ${index+1}'),flex: 1,),
                                                  Expanded(child: Text('${snapshot.data[index].dayOfYearNepali}'),flex: 2,),
                                                  Expanded(child: Text('  ${snapshot.data[index].dayName}'),flex: 2,),
                                                  Expanded(child: Padding(
                                                    padding: const EdgeInsets.only(left:4.0,right: 10),
                                                    child: snapshot.data[index].remark == null ?Text('-') : Text('${snapshot.data[index].remark}'),
                                                  ),flex: 3,)
                                                ],

                                              ),
                                            );

                                        }
                                    ) :Empty();
                                  } else {
                                    return Loader();
                                  }



                                } ),
                          ),
                        ],
                      ))



    );
  }
  Text _title(BuildContext context, String txt) {
    return Text('$txt',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white,
        letterSpacing: 0.4, shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black12,
            offset: Offset(2.0, 2.0),
          ),
        ]));
  }
}



