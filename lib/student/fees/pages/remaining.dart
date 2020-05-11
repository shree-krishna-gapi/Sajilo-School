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
                  Container(child: Text('Sn',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.4, shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black38,
                            offset: Offset(2.0, 2.0),
                          ),
                        ]
                    ),),width: 24,),
                  Expanded(child: Text(' Fee Type',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 5,),
//                  Expanded(child: Text('Date',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
//                      letterSpacing: 0.4, shadows: [
//                        Shadow(
//                          blurRadius: 4.0,
//                          color: Colors.black38,
//                          offset: Offset(2.0, 2.0),
//                        ),
//                      ])),flex: 3,),
                  Expanded(child: Text('Rate',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 2,),
                  Expanded(child: Text('Total',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white,
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
            height: 440,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,12,15,132),
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
                                    snapshot.data[index].rate,
                                    (snapshot.data[index].toMonth - snapshot.data[index].fromMonth +1) * snapshot.data[index].rate,

                                  ),
                                  SizedBox(height: 5,),
                                  Container(height: 1, color: Colors.black12,),SizedBox(height: 10,),


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
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: <Widget>[
          Container( color: Colors.orange[400],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,4,0,4),
              child: Row(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
//                  Text('From:'),
                      Text('       From:  ',style: TextStyle(color: Colors.white),),
                      Text('$fromDate',style: TextStyle(fontSize: 14,
                        letterSpacing: 0.4,fontWeight: FontWeight.w500,color: Colors.white )),
                      Text('   |   ',style: TextStyle(color: Colors.white),),
//                  Text('To:'),
                      Text('$toDate',style: TextStyle(fontSize: 14,
                        letterSpacing: 0.4, fontWeight: FontWeight.w500,color: Colors.white )),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 2,),
          Row(
            children: <Widget>[
              Container(child: Text(sn,
                style: TextStyle(fontSize: 15,
                  letterSpacing: 0.4,
                ),),width: 24, ),
              Expanded(child: Text(  feeTypeEng,style: TextStyle(fontSize: 15,
                letterSpacing: 0.2, )),flex: 5,),
              
              Expanded(child: Text('$amount',style: TextStyle(fontSize: 15,
                letterSpacing: 0.4, )),flex: 2,),
              Expanded(child: Text('$total',style: TextStyle(fontSize: 15,
                letterSpacing: 0.4,)),flex: 2,),
            ],
          ),

        ],
      ),
    );
  }



}
