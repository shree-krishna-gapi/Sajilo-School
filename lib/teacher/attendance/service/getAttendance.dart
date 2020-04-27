import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<AttendanceGet>> fetchAttendance(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString('getStudentForAttendance');
      return compute(parseData, data);
}
List<AttendanceGet> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AttendanceGet>((json) => AttendanceGet.fromJson(json)).toList();
}
class AttendanceGet {
  final int attendanceId;
  final String studentName;
  final int studentId;
  final bool isPresent;
  final int rollNo;
  AttendanceGet({this.attendanceId,this.studentName,this.studentId,this.isPresent,this.rollNo
  });
  factory AttendanceGet.fromJson(Map<String, dynamic> json) {
    return AttendanceGet(
      attendanceId:json['AttendanceId'] as int,
      studentName: json['StudentName'] as String,
      studentId: json['StudentId'] as int,
      isPresent: json['IsPresent'] as bool,
      rollNo: json['RollNo'] as int,
    );}
}