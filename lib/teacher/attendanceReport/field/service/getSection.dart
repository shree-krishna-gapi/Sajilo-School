//import 'dart:async';
//import 'dart:convert';
//import 'package:flutter/foundation.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import '../../../../../utils/api.dart';
//
//Future<List<GetSection>> FetchStream(http.Client client) async {
//  final SharedPreferences prefs = await SharedPreferences.getInstance();
//  var schoolId = prefs.getInt('schoolId');
//  var hwStreamId = prefs.getInt('hwStreamId');
//  var hwYearId = prefs.getInt('hwYearId');
//  try {
//    final response =
//    await http.get("${Urls.BASE_API_URL}/login/GetClass?schoolId=$schoolId"
//        "&streamId=$hwStreamId&educationYearId=$hwYearId");
//    print("${Urls.BASE_API_URL}/login/GetClass?schoolId=$schoolId"
//        "&streamId=$hwStreamId&educationYearId=$hwYearId");
//    if (response.statusCode == 200) {
//
//      final stringData = response.body;
//      return compute(parseData1, stringData);
//    } else {
//      print("Error getting users.");
//    }
//  } catch (e) {
//    print("Error getting users.");
//  }
//}
//
//List<GetSection> parseData1(String responseBody) {
//  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//  return parsed.map<GetSection>((json) => GetSection.fromJson(json)).toList();
//}
//class GetSection {
//  final int gradeId;
//  final String gradeNameEng;
//  GetSection({this.gradeId,this.gradeNameEng,
//  });
//  factory GetSection.fromJson(Map<String, dynamic> json) {
//    return GetSection(
//      gradeId: json['ClassId'] as int,
//      gradeNameEng: json['Section'] as String,
//    );}
//}