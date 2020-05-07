import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<GetClass>> FetchClass(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var streamId = prefs.getInt('tempChangedGradeId');
  var yearId = prefs.getInt('educationalYearIdHw');
  try {
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetClass?schoolId=$schoolId"
        "&streamId=$streamId&educationYearId=$yearId");
    print("${Urls.BASE_API_URL}/login/GetClass?schoolId=$schoolId"
        "&streamId=$streamId&educationYearId=$yearId");
    if (response.statusCode == 200) {

      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users.");
    }
  } catch (e) {
    print("Error getting users.");
  }
}

List<GetClass> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetClass>((json) => GetClass.fromJson(json)).toList();
}
class GetClass {
  final int classId;
  final String className;
  GetClass({this.classId,this.className,
  });
  factory GetClass.fromJson(Map<String, dynamic> json) {
    return GetClass(
      classId: json['ClassId'] as int,
      className: json['Section'] as String,
    );}
}