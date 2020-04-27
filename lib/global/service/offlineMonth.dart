import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<OfflineFeeMonth>> FetchOfflineMonth(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringData = prefs.getString('getMonthData');
    print(stringData);
    return compute(parseData1, stringData);

}
List<OfflineFeeMonth> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<OfflineFeeMonth>((json) => OfflineFeeMonth.fromJson(json)).toList();
}
class OfflineFeeMonth {
  int month;
  String monthName;
  OfflineFeeMonth({this.month,this.monthName
  });
  factory OfflineFeeMonth.fromJson(Map<String, dynamic> json) {
    return OfflineFeeMonth(
      month: json['Month'] as int,
      monthName: json['MonthName'] as String,

    );}
}