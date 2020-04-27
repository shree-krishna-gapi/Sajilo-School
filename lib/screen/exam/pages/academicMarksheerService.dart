//import 'dart:async';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'package:flutter/foundation.dart';
//import '../../../utils/api.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//Future<List<AcademicMarksheetData>> FetchMarksheet(http.Client client) async {
//  final SharedPreferences prefs = await SharedPreferences.getInstance();
//  var schoolId = prefs.getInt('schoolId');
//  var studentId = prefs.getInt('studentId');
//  var academicPeriodId = prefs.getInt('academicPeriodId');
//  String url = "${Urls.BASE_API_URL}/Login/GetAcademicExamMarks?schoolId=$schoolId&academicperiodId=$academicPeriodId&studentId=$studentId";
//  try {
//    final response =
//    await http.get(url);
//    print(url);
//    if (response.statusCode == 200) {
//      final stringData = response.body;
//      return compute(parseData1, stringData);
//    } else {
//      print("Error getting users1.");
//
//    }
//  } catch (e) {
//    print("Error getting users.2");
//  }
//}
//
//List<AcademicMarksheetData> parseData1(String responseBody) {
//  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//  return parsed.map<AcademicMarksheetData>((json) => AcademicMarksheetData.fromJson(json)).toList();
//
//}
//class AcademicMarksheetData {
//  final double obtainedMarks;
//  final String subjectName;
//  final int rollNo;
//  final double fullMarks;
//  final double passMarks;
//  AcademicMarksheetData({
//    this.obtainedMarks,this.subjectName,this.rollNo,this.fullMarks,
//    this.passMarks
//  });
//  factory AcademicMarksheetData.fromJson(Map<String, dynamic> json) {
//    return AcademicMarksheetData(
//    obtainedMarks: json['ObtainedMarks'] as double,
//    subjectName: json['SubjectName'] as String,
//    rollNo: json['RollNo'] as int,
//    fullMarks: json['FullMarks'] as double,
//    passMarks: json['PassMarks'] as double,
//
//
//    );}
//}
//
