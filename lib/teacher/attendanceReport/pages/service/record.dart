import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<GetRecord>> fetchRecord(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
      final stringData = prefs.getString('attendanceRecord');
//      final realData = jsonDecode(prefs.getString('attendanceRecordEncode')[0]);
      print(stringData);
//  print('realData $realData');
      return compute(parseData1,stringData);
}

List<GetRecord> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetRecord>((json) => GetRecord.fromJson(json)).toList();
}
class GetRecord {
  final String studentName;
  final int studentId;
  final int rollNo;
//  final int totalMonthlyDays;
//  final int totalWorkingDays;
  final int presentDays;
  final bool isMonthly;
  final DateTime fromDateNepali;
  final String toDateNepali;
  GetRecord({this.studentName,this.studentId,this.rollNo
    ,this.presentDays,
    this.isMonthly,
    this.fromDateNepali,this.toDateNepali
  });
  factory GetRecord.fromJson(Map<String, dynamic> json) {
    return GetRecord(
      studentName: json['StudentName'] as String,
      studentId: json['StudentId'] as int,
      rollNo: json['RollNo'] as int,
//      totalMonthlyDays: json['TotalMonthlyDays'] as int,
//      totalWorkingDays: json['TotalWorkingDays'] as int,
        presentDays: json['PresentDays'] as int,
        isMonthly: json['IsMonthly'] as bool,
        fromDateNepali: json['FromDateNepali'] as DateTime,
        toDateNepali: json['ToDateNepali'] as String,
    );}
}