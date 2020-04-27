import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/pallate.dart';
class ViewModal {
  mainBottomSheet1(BuildContext context, h) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,10,10),
                      child: Text('Routien First Terminal',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                        ,),
                    ),

                  ],
                )
              ],
            ),
          );
        });
  }
}

class Htxt extends StatelessWidget {
  Htxt({this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
        letterSpacing: 0.4, shadows: [
      Shadow(
        blurRadius: 4.0,
        color: Colors.black38,
        offset: Offset(2.0, 2.0),
      ),
    ], color: Colors.white ));
  }
}
class Btxt extends StatelessWidget {
  Btxt({this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      letterSpacing: 0.4,  ));
  }
}