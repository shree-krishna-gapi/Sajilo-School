import 'package:flutter/material.dart';
import 'package:sajiloschool/utils/pallate.dart';
class ActiveDesign extends StatelessWidget {
  ActiveDesign({this.roll,this.name});
  final int roll;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)
          ),
          color: Colors.green,
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black12,
                blurRadius: 2
            )
          ]
      ),
      padding: EdgeInsets.all(1.5),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)
            ),
            color: Colors.green[400]
        ),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('$roll',style: TextStyle(
                  fontSize: 17,color: Colors.white
              ),),
              Text('$name',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),

    );
  }
}
class InActiveDesign extends StatelessWidget {
  InActiveDesign({this.roll,this.name});
  final int roll;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)
          ),
//          color: Colors.blue,
          color: Color(0xFF28588e).withOpacity(0.7),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0),
                color: Colors.black12,
                blurRadius: 2
            )
          ]
      ),
      padding: EdgeInsets.all(1.5),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)
              ),
//          color: Colors.orange.withOpacity(0.02),
              color: Colors.white
          ),

        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)
              ),
//          color: Colors.orange.withOpacity(0.02),
              color: Colors.yellow[600].withOpacity(0.06)
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('$roll',style: TextStyle(
                  fontSize: 17
                ),),
                Text('$name',textAlign: TextAlign.center,),
              ],
            ),
          ),
        )
      ),

    );
  }
}


class ConformData extends StatelessWidget {
  ConformData({this.num});
  final int num;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text('$num',style: TextStyle(),));
  }
}
class ConformDataInfo extends StatelessWidget {
  ConformDataInfo({this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$txt',style: TextStyle(),),
    );
  }
}