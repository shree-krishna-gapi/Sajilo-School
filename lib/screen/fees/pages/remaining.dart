import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import '../service/remaningFees.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';


class Remaining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            decoration: BoxDecoration(
              //                      color: Colors.orange,
                gradient: purpleGradient,
                borderRadius: BorderRadius.only(
                  topLeft:  Radius.circular(24),
                  topRight: Radius.circular(24),
                )
            ),
            child:Padding(
              padding: const EdgeInsets.fromLTRB(15,12,15,12),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('SN',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.4, shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black38,
                            offset: Offset(2.0, 2.0),
                          ),
                        ]
                    ),),flex: 1,),
                  Expanded(child: Text(' Fee Type',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 5,),
                  Expanded(child: Text('Date',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 3,),
                  Expanded(child: Text('Rate',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 2,),
                  Expanded(child: Text('Total',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 2,),
                ],
              ),
            ),

          ),
          Container(
            height: 360,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,12,15,12),
              child: FutureBuilder<List<FeeRemaningGet>>(
                  future: fetchRemaningFee(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError);
                    if(snapshot.hasData) {
                      return snapshot.data.length > 0 ?
                      ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return FadeAnimation(
                              0.4, Column(
                                children: <Widget>[
//                                Text('sdsdfsd')
                                  _create1(context, '${index+1}',
                                    snapshot.data[index].feeTypeEng,
                                    snapshot.data[index].fromMonthName,
                                    snapshot.data[index].toMonthName,
                                    snapshot.data[index].amount,
                                    snapshot.data[index].total,

                                  ),
                                  Divider()

                                ],
                              ),
                            );
                          }
                      ) :
                      FadeAnimation(
                        0.4, Align(
                            alignment: Alignment.center,
                            child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                              letterSpacing: 0.4,),)
                        ),
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
    );
  }
  Padding _create1(BuildContext context, String sn, String feeTypeEng, String fromDate,String toDate,double amount,double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(sn,
            style: TextStyle(fontSize: 15,
              letterSpacing: 0.4,
            ),),flex: 1,),
          Expanded(child: Text(  feeTypeEng,style: TextStyle(fontSize: 15,
            letterSpacing: 0.4, )),flex: 5,),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('$fromDate',style: TextStyle(fontSize: 15,
                letterSpacing: 0.4, )),
              Text('$toDate',style: TextStyle(fontSize: 15,
                letterSpacing: 0.4, )),
            ],
          ),flex: 3,),
          Expanded(child: Text('$amount',style: TextStyle(fontSize: 15,
            letterSpacing: 0.4, )),flex: 2,),
          Expanded(child: Text('$total',style: TextStyle(fontSize: 15,
            letterSpacing: 0.4,)),flex: 2,),
        ],
      ),
    );
  }



}
