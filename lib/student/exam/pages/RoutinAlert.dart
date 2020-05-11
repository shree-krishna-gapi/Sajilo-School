import 'package:flutter/material.dart';
import '../../../utils/pallate.dart';
class RoutinAlert extends StatefulWidget {
  @override
  _RoutinAlertState createState() => _RoutinAlertState();
}

class _RoutinAlertState extends State<RoutinAlert> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 220,
      width: double.infinity,

      child: Column(
        children: <Widget>[
          Container(
//        color: Colors.white.withOpacity(0.95),
            decoration: BoxDecoration(
                gradient: purpleGradient
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,11,10,4),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: RoutinHead(head:'SN'),flex: 1,),
                      Expanded(child: RoutinHead(head:'Subject'),flex: 4),
                      Expanded(child: RoutinHead(head:'Date'),flex: 3,),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RoutinHead(head:'Examiner'),
                      ),flex: 3,),
                    ],
                  ),
                  SizedBox(height: 10,),
//              DetailList()
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Row(
                children: <Widget>[
                  Expanded(child: RoutinTxtBody(Btitle:'1.'),flex: 1,),
                  Expanded(child: RoutinTxtBody(Btitle:'Science'),flex: 4,),
                  Expanded(child: RoutinTxtBody(Btitle:'04/02/2076'),flex: 4,),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: RoutinTxtBody(Btitle:'Hari Sir'),
                  ),flex: 3,),
                ],
              ),
            ),
          ),
          Container(color: Colors.black12,height: 1,),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,4,0,0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(''),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinTxt(head:'80.00'),
                  ],
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinTxt(head:'25.00'),
                  ],
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinTxt(head:'35.00'),
                  ],
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinTxt(head:'15.00'),
                  ],
                ),flex: 2,),
              ],
            ),
          ),
          Container(color: Colors.black12,height: 1,),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,0),
            child: Row(
              children: <Widget>[
                Expanded(child: Container(
                    color: Colors.greenAccent[100].withOpacity(0.4),
                    child: Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(15,4,0,4),
                            child: Text('Marks',
                              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
                            )
                        ),


                      ],
                    )
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinBtnTitle(head:'Theory'),
                  ],
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinBtnTitle(head:'Pract'),
                  ],
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinBtnTitle(head:'Pass'),
                  ],
                ),flex: 2,),
                Expanded(child: Row(
                  children: <Widget>[
                    Hr(),
                    RoutinBtnTitle(head:'P.Pass'),
                  ],
                ),flex: 2,),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.black12,
          )

        ],
      ),

    );
  }
}
class RoutinTxtBody extends StatelessWidget {
  RoutinTxtBody({this.Btitle});
  String Btitle;
  @override
  Widget build(BuildContext context) {
    return Container(
//        color: Colors.orange[100].withOpacity(0.4),
        child: Padding(padding: EdgeInsets.fromLTRB(0,4,0,4),
            child: Text(Btitle,
              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
            )
        )
    );
  }
}
class RoutinBtnTitle extends StatelessWidget {
  RoutinBtnTitle({this.head});
  String head;
  @override
  Widget build(BuildContext context) {
    return Container(
//        color: Colors.orange[100].withOpacity(0.4),
        child: Padding(padding: EdgeInsets.fromLTRB(0,4,0,4),
            child: Text(head,
              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
            )
        )
    );
  }
}
class RoutinHead extends StatelessWidget {
  RoutinHead({this.head});
  String head;
  @override
  Widget build(BuildContext context) {
    return Text(head,
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.4,
      ),);
  }
}

class RoutinTxt extends StatelessWidget {
  RoutinTxt({this.head});
  String head;
  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.orange[100].withOpacity(0.4),
        child: Padding(padding: EdgeInsets.fromLTRB(0,4,0,4),
            child: Text(head,
              style: TextStyle(fontSize: 14,letterSpacing: 0.4,),
            )
        )
    );
  }
}




class Hr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Align(alignment: Alignment.centerLeft, child:Container(color: Colors.black12, height: 24, width: 1,)),
    );
  }
}
