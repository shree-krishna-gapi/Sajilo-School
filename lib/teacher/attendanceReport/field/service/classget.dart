
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<GetStream>> FetchStream(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var hwStreamId = prefs.getInt('hwStreamId');
  var hwYearId = prefs.getInt('hwYearId');
  try {
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetClass?schoolId=$schoolId"
        "&streamId=$hwStreamId&educationYearId=$hwYearId");
    print("${Urls.BASE_API_URL}/login/GetClass?schoolId=$schoolId"
        "&streamId=$hwStreamId&educationYearId=$hwYearId");
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

List<GetStream> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetStream>((json) => GetStream.fromJson(json)).toList();
}
class GetStream {
  final int gradeId;
  final String gradeNameEng;
  final int sectionId;
  GetStream({this.gradeId,this.gradeNameEng,this.sectionId
  });
  factory GetStream.fromJson(Map<String, dynamic> json) {
    return GetStream(
      gradeId: json['ClassId'] as int,
      gradeNameEng: json['Section'] as String,
      sectionId: json['SectionId'] as int,
    );}
}