import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<GetNepaliMonth>> FetchMonth(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  try {
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetNepaliMonths?schoolid=$schoolId");
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData, stringData);
    } else {
      print("Error getting users.");
    }
  } catch (e) {
    print("Error getting users.");
  }
}

List<GetNepaliMonth> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetNepaliMonth>((json) => GetNepaliMonth.fromJson(json)).toList();
}
class GetNepaliMonth {
  final int month;
  final String monthName;
  GetNepaliMonth({this.month,this.monthName
  });
  factory GetNepaliMonth.fromJson(Map<String, dynamic> json) {
    return GetNepaliMonth(
      month: json['Month'] as int,
      monthName: json['MonthName'] as String,
    );}
}

