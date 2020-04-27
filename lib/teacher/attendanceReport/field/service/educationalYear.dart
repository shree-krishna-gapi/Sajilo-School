import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<EducationalYear>> FetchYear(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');

  try {
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetEducationalYear?schoolid=$schoolId");
    print("${Urls.BASE_API_URL}/login/GetEducationalYear?schoolid=$schoolId");
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users.1");
    }
  } catch (e) {
    print("Error getting users.2");
  }
// for default menu

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