import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<OfflineFeeYear>> FetchOffline(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    String stringData = prefs.getString('getEducationalYearData');
    return compute(parseData1, stringData);
  } catch (e) {
    print("Error getting users.2");
  }
}
List<OfflineFeeYear> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<OfflineFeeYear>((json) => OfflineFeeYear.fromJson(json)).toList();
}
class OfflineFeeYear {
  int educationalYearID;
  String sYearName;
  bool isCurrent;
  OfflineFeeYear({this.educationalYearID,this.sYearName,this.isCurrent
  });
  factory OfflineFeeYear.fromJson(Map<String, dynamic> json) {
    return OfflineFeeYear(
      educationalYearID: json['EducationalYearID'] as int,
      sYearName: json['sYearName'] as String,
      isCurrent  : json['isCurrent'] as bool,

    );}
}