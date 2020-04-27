import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendanceDesign.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
class NormalAttendance extends StatefulWidget {
  NormalAttendance({this.attendanceId,this.indexing,this.studentName,this.studentId,this.isPresent,this.rollId,this.total});
  final int attendanceId;
  int indexing;

  bool isPresent;
  final String studentName;
  final int studentId;
  final int rollId;
  final int total;
  @override
  _NormalAttendanceState createState() => _NormalAttendanceState();
}

class _NormalAttendanceState extends State<NormalAttendance> {
  @override
  void initState(){
    firstProcess();
    super.initState();
  }
  firstProcess()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('attendanceId${widget.indexing}', widget.attendanceId);
    prefs.setInt('stdId${widget.indexing}',widget.studentId);
    prefs.setBool('stdPresent${widget.indexing}',widget.isPresent);
    prefs.setInt('stdRoll${widget.indexing}',widget.rollId);
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeAnimation( 0.6,
          widget.isPresent ?  //|| widget.forcePresent
          InkWell(
            onTap: ()async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState((){
                widget.isPresent =! widget.isPresent;
              });
              prefs.setBool('stdPresent${widget.indexing}',widget.isPresent);
            },
            child:ActiveDesign(roll: widget.rollId,name:widget.studentName),
          )
              :InkWell(
            onTap: ()async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState((){
                widget.isPresent =! widget.isPresent;
              });
              prefs.setBool('stdPresent${widget.indexing}',widget.isPresent);
            },
            child:InActiveDesign(roll: widget.rollId,name:widget.studentName),
          )
      ),
    );
  }

}




