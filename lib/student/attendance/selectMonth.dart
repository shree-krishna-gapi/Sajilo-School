import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Month>> FetchMonth(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    final response = prefs.getString('getMonth');
      return compute(parseData1, response);
  } catch (e) {
    print("Error getting users.2");
  }
}

List<Month> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Month>((json) => Month.fromJson(json)).toList();

}
class Month {
  int monthId;
  String monthName;
  Month({this.monthId,this.monthName
  });
  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      monthId: json['Month'] as int,
      monthName: json['MonthName'] as String,

    );}
}