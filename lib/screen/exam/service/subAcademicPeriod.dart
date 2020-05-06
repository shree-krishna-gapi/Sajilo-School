import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<SubAcademicPeriod>> FetchsubAcademicPeriod(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var academicPeriodId = prefs.getInt('educationalYearIdExam');
  String url = "${Urls.BASE_API_URL}/login/periodexams?schoolid=$schoolId&AcademicPeriodId=$academicPeriodId";
  try {
    final response =
    await http.get(url);
    print('exam view detail* screen/exam/service/subAcademic $url');
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData, stringData);
    } else {
      print("Error getting users.");
    }
  } catch (e) {
    print("Error getting users.");
  }
// for default menu

}


List<SubAcademicPeriod> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<SubAcademicPeriod>((json) => SubAcademicPeriod.fromJson(json)).toList();

}

class SubAcademicPeriod {
  final int academicPeriodId;
  final int examTypeId;
  final String examType;
  final int examId;
  final String examName;
  final String fromDate;
  final String toDate;
  SubAcademicPeriod({
    this.academicPeriodId,this.examTypeId,
    this.examType,this.examName,this.examId,this.fromDate,this.toDate

  });
  factory SubAcademicPeriod.fromJson(Map<String, dynamic> json) {
    return SubAcademicPeriod(
      academicPeriodId: json['AcademicPeriodId'] as int,
      examTypeId: json['ExamTypeId'] as int,
      examType: json['ExamType'] as  String,
      examId: json['ExamId'] as  int,
      examName: json['ExamName'] as  String,
      fromDate: json['FromDateNepali'] as  String,
      toDate: json['ToDateNepali'] as  String,

    );}
}

