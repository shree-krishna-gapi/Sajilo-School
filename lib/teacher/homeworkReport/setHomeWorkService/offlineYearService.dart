import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<EducationalYear>> FetchYear(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final stringData = prefs.getString('attendanceEducationalYearData');
  return compute(parseData1, stringData);
}
List<EducationalYear> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<EducationalYear>((json) => EducationalYear.fromJson(json)).toList();
}
class EducationalYear {
  int educationalYearID;
  String sYearName;
  bool isCurrent;
  EducationalYear({this.educationalYearID,this.sYearName,this.isCurrent
  });
  factory EducationalYear.fromJson(Map<String, dynamic> json) {
    return EducationalYear(
      educationalYearID: json['EducationalYearID'] as int,
      sYearName: json['sYearName'] as String,
      isCurrent  : json['isCurrent'] as bool,
    );}
}