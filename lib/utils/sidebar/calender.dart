import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'calenderService.dart';
import 'package:http/http.dart' as http;
class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x000000),
      body: InkWell( onTap: (){Navigator.of(context).pop();},
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xfffbf9e7),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
//                              color: Colors.orange,
                              gradient: purpleGradient,
                              borderRadius: BorderRadius.only(
                                  topLeft:  Radius.circular(15),
                                  topRight: Radius.circular(15)
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(child: _title(context,'  SN'),flex: 1,),
                                Expanded(child: _title(context,'Date'),flex: 2,),
                                Expanded(child: _title(context,'  Day'),flex: 2,),
                                Expanded(child: _title(context,'    Remark'),flex: 3,),

                              ],
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<CalenderData>>(
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
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text('   ${index+1}',style: TextStyle(color: Colors.white),),flex: 1,),
                    Expanded(child: Text('${snapshot.data[index].dayOfYearNepali}',style: TextStyle(color: Colors.white)),flex: 2,),
                    Expanded(child: Text('  ${snapshot.data[index].dayName}',style: TextStyle(color: Colors.white)),flex: 2,),
                    Expanded(child: Text('     -',style: TextStyle(color: Colors.white)),flex: 3,)
                  ],
      ),
              ),
            ): Padding(padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('   ${index+1}'),flex: 1,),
                  Expanded(child: Text('${snapshot.data[index].dayOfYearNepali}'),flex: 2,),
                  Expanded(child: Text('  ${snapshot.data[index].dayName}'),flex: 2,),
                  Expanded(child: Text('     -'),flex: 3,)
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
                  )
              )
          )


    );
  }
  Text _title(BuildContext context, String txt) {
    return Text(txt,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.white,
        letterSpacing: 0.4, shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black12,
            offset: Offset(2.0, 2.0),
          ),
        ]));
  }
}



