import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<GetMonth>> FetchMonth(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  try {
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetNepaliMonths?schoolid=$schoolId");
    if (response.statusCode == 200) {

      final stringData = response.body;
      return compute(parseData, stringData);
    } else {
      print("Error getting users status.");
    }
  } catch (e) {
    print("Error getting users error.");
  }
}

List<GetMonth> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetMonth>((json) => GetMonth.fromJson(json)).toList();
}
class GetMonth {
  final int monthId;
  final String monthName;
  GetMonth({this.monthId,this.monthName,
  });
  factory GetMonth.fromJson(Map<String, dynamic> json) {
    return GetMonth(
      monthId: json['Month'] as int,
      monthName: json['MonthName'] as String,
    );}
}