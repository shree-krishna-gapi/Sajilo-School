import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<AcademicMarksheetData>> FetchGetPeriodExamMarks(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  var examId = prefs.getInt('examId');
  String url = "${Urls.BASE_API_URL}/Login/GetExamRoutine?schoolId=$schoolId&examId=$examId&studentId=$studentId";
  try {
    final response =
    await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users1.");

    }
  } catch (e) {
    print("Error getting users.2");
  }
}

List<AcademicMarksheetData> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AcademicMarksheetData>((json) => AcademicMarksheetData.fromJson(json)).toList();

}
class AcademicMarksheetData {
  final String examDateNepali;
  final String subjectName;
  AcademicMarksheetData({
    this.examDateNepali,this.subjectName
  });
  factory AcademicMarksheetData.fromJson(Map<String, dynamic> json) {
    return AcademicMarksheetData(
      examDateNepali: json['ExamDateNepali'] as String,
      subjectName: json['Subject'] as String,


    );}
}

