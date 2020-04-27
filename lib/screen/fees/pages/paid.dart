import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
import 'package:sajiloschool/utils/pallate.dart';
import '../service/paidFees.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api.dart';

class Paid extends StatefulWidget {
  @override
  _PaidState createState() => _PaidState();
}

class _PaidState extends State<Paid> {
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
                        Expanded(child: ModalTitle(txt:'SN'),flex: 1,),
                        Expanded(child: ModalTitle(txt: 'Bill No.',),flex: 3,),
                        Expanded(child: ModalTitle(txt: 'Date',),flex: 3,),

                        Expanded(child: ModalTitle(txt: 'Amount',),flex: 2,),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 440,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,12,15,12),
                    child: FutureBuilder<List<PaidFee>>(
                        future: fetchfee(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError);
                          if(snapshot.hasData) {
                            return snapshot.data.length > 0 ?
                            FadeAnimation(
                              0.4, ListView.builder(
                                  itemCount: (snapshot.data == null && snapshot.data.length==0) ? 0 : snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: <Widget>[
                                        Padding(padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: _create1(context, '${index+1}',snapshot.data[index].billNumber,snapshot.data[index].billDateNepali,'${snapshot.data[index].amount}')),
                                        Divider()
                                      ],
                                    );
                                  }
                              ),
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
  Row _create1(BuildContext context, String sn, String type,String billDate, String amt) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(sn,
          style: TextStyle(fontSize: 15,
            letterSpacing: 0.4,
          ),),flex: 1,),
        Expanded(child: Text(type == null ? 'Nothing': type,style: TextStyle(fontSize: 15,
          letterSpacing: 0.4, )),flex: 3,),
        Expanded(child: Text(billDate,style: TextStyle(fontSize: 15,
          letterSpacing: 0.4, )),flex: 3,),
        Expanded(child: Text(amt,style: TextStyle(fontSize: 15,
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
        _showDialog(context,'Under Construction');
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

class ModalTitle extends StatelessWidget {
  ModalTitle({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(txt,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: Colors.white,
        letterSpacing: 0.4, shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black38,
            offset: Offset(2.0, 2.0),
          ),
        ]));
  }
}
