import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<AcademicPeriodId>> FetchAcademicPeriodId(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  var educationalYearId = prefs.getInt('educationalYearId');
  String url;
  try {
    url = '${Urls.BASE_API_URL}/login/academicperiods?schoolid=$schoolId&studentid=$studentId&eduyearid=$educationalYearId';
    final response =
    await http.get(url);
    print('$url');
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("exam service academicPeriod -> Error getting users1.");

    }
  } catch (e) {
    print("exam service academicPeriod -> Error getting users.2");

  }
}

List<AcademicPeriodId> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AcademicPeriodId>((json) => AcademicPeriodId.fromJson(json)).toList();

}
class AcademicPeriodId {
  final int academicPeriodId;
  final String academicPeriodName;
  final int educationalYearId;
  final String educationalYear;
  final String fromDateNepali;
  final String toDateNepali;
  final String examDateNepali;
  final String examDate;
  final bool isActive;
  final int createdBy;
  final String createdDate;
  final String exam;
  final String academicPeriods;
  final String exams;
  AcademicPeriodId({
    this.academicPeriodId,this.academicPeriodName,
    this.educationalYearId,
    this.educationalYear,
    this.fromDateNepali,
    this.toDateNepali,this.examDateNepali,this.examDate,this.isActive,this.createdBy,this.createdDate,this.exam,
    this.academicPeriods,
    this.exams,
  });
  factory AcademicPeriodId.fromJson(Map<String, dynamic> json) {
    return AcademicPeriodId(
      academicPeriodId: json['AcademicPeriodId'] as int,
      academicPeriodName: json['AcademicPeriodName'] as String,
      educationalYearId: json['EducationalYearId'] as  int,
      educationalYear: json['EducationalYear'] as  String,
      fromDateNepali: json['FromDateNepali'] as String,
      toDateNepali: json['ToDateNepali'] as String,
      examDate: json['ExamDate'] as String,
      isActive: json['IsActive'] as  bool,
      createdBy: json['CreatedBy'] as int,
      createdDate: json['CreatedDate'] as String,
      exam: json['Exam'] as String,
      academicPeriods: json['AcademicPeriods'] as  String,
      exams: json['Exams'] as String,

    );}
}

