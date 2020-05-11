import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';
import '../service/assignedFees.dart';
class Assigned extends StatefulWidget {
  @override
  _AssignedState createState() => _AssignedState();
}

class _AssignedState extends State<Assigned> {
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,12,15,12),
              child: Row(
                children: <Widget>[
                  Container(child: Text('Sn',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.4, shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black38,
                            offset: Offset(2.0, 2.0),
                          ),
                        ]
                    ),),width: 27,),
                  Expanded(child: Text('Fee Type',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
                      letterSpacing: 0.4, shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ])),flex: 3,),
                  Expanded(child: Text('Amount',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
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
              child: FutureBuilder<List<AssignedFees>>(
                  future: fetch(http.Client()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError);
                    if(snapshot.hasData) {
                      return snapshot.data.length > 0 ?
                      ListView.builder(
                          itemCount: (snapshot.data == null && snapshot.data.length==0) ? 0 : snapshot.data.length,
                          itemBuilder: (context, index) {
                            return FadeAnimation(
                              0.3, Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: _create1(context, '${index+1}',snapshot.data[index].feeType, snapshot.data[index].amount),
                                  ),
                                  Divider()
                                ],
                              ),
                            );
                          }
                      ) :
                      FadeAnimation(
                        0.3, Align(
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
  Row _create1(BuildContext context, String sn, String type, double amt) {
    return Row(
      children: <Widget>[
        Container(child: Text(sn,
          style: TextStyle(fontSize: 15,
            letterSpacing: 0.4,
          ),),width: 27,),
        Expanded(child: Text(type == null ? 'Nothing': type,style: TextStyle(fontSize: 15,
          letterSpacing: 0.4, )),flex: 3,),
        Expanded(child: Text('$amt',style: TextStyle(fontSize: 15,
          letterSpacing: 0.4,)),flex: 2,),
      ],
    );
  }
  ListTile _createTile(BuildContext context, String name, IconData icon, Function action){
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      onTap: (){
        Navigator.of(context).pop();
        _showDialog(context,'hhghg   ..');
      },
    );
  }

  void _showDialog(BuildContext context,txtmseg) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
              title: Row(
                children: <Widget>[
                  Container(width: 5, height: 22, color: Colors.green[400],),
                  SizedBox(width: 15,),
                  Expanded(child: Text('View $txtmseg'))
                ],
              ),
              elevation: 4,
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Text('$txtmseg'));});
  }
}
