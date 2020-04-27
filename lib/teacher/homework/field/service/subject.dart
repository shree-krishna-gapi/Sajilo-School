import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/api.dart';

Future<List<GetSubject>> FetchSubject(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var streamId = prefs.getInt('streamId');
  try {
    print('Stream-> ${Urls.BASE_API_URL}/login/GetSubjects?schoolid=$schoolId&streamId=$streamId');
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetSubjects?schoolid=$schoolId&streamId=$streamId");
//    print("${Urls.BASE_API_URL}/login/GetSubjects?schoolid=$schoolId&streamId=$hwStreamId");
    if (response.statusCode == 200) {
      print('sdfdsf');
      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users.");
    }
  } catch (e) {
    print("Error getting users.");
  }
}

List<GetSubject> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetSubject>((json) => GetSubject.fromJson(json)).toList();
}
class GetSubject {
  final int gradeId;
  final String gradeNameEng;
  GetSubject({this.gradeId,this.gradeNameEng,
  });
  factory GetSubject.fromJson(Map<String, dynamic> json) {
    return GetSubject(
      gradeId: json['SubjectId'] as int,
      gradeNameEng: json['SubjectNameEnglish'] as String,
    );}
}