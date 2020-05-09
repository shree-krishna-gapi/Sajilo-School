import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attendanceDesign.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
class ForceAttendance extends StatefulWidget {
  ForceAttendance({this.attendanceId,this.indexing,this.forcePresent,this.studentName,this.studentId,this.rollId,this.total});
  final int attendanceId;
  int indexing;
  bool forcePresent;
  final String studentName;
  final int studentId;
  final int rollId;
  final int total;
  @override
  _ForceAttendanceState createState() => _ForceAttendanceState();
}

class _ForceAttendanceState extends State<ForceAttendance> {
  @override
  void initState(){
    firstProcess();
    super.initState();
  }
  firstProcess()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('attendanceId${widget.indexing}', widget.attendanceId);
    prefs.setInt('stdId${widget.indexing}',widget.studentId);
    prefs.setBool('stdPresent${widget.indexing}',widget.forcePresent);
    prefs.setInt('stdRoll${widget.indexing}',widget.rollId);
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeAnimation( 0.0,
          widget.forcePresent ?  //|| widget.forcePresent
          InkWell(
            onTap: ()async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState((){
                widget.forcePresent =! widget.forcePresent;
              });
              prefs.setBool('stdPresent${widget.indexing}',widget.forcePresent);
            },
            child:ActiveDesign(roll: widget.rollId,name:widget.studentName),

          )
              :InkWell(
            onTap: ()async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState((){
                widget.forcePresent =! widget.forcePresent;
              });
              prefs.setBool('stdPresent${widget.indexing}',widget.forcePresent);
            },
            child:InActiveDesign(roll: widget.rollId,name:widget.studentName),

          )
      ),
    );
  }

}




