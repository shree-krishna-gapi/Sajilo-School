import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';
Future<List<CalenderData>> FetchCalender(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int schoolId = prefs.getInt('schoolId');
  int yearId = prefs.getInt('educationalYearIdCalender');
  int monthId = prefs.getInt('monthIdCalender');
  String url = '${Urls.BASE_API_URL}/Login/GetSchoolCalendar?schoolId=$schoolId&yearId=$yearId&monthId=$monthId&IsStudent=true';
  print(url);
  try {
    final response = await http.get(url);
    return compute(parseData1, response.body);
  } catch (e) {
    print("Error getting users.2");
  }
}

List<CalenderData> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CalenderData>((json) => CalenderData.fromJson(json)).toList();

}
class CalenderData {
  String dayOfYearNepali;
  String remark;
  String dayName;
  bool isHoliday;
  CalenderData({this.dayOfYearNepali,this.remark,this.dayName,this.isHoliday
  });
  factory CalenderData.fromJson(Map<String, dynamic> json) {
    return CalenderData(
      dayOfYearNepali: json['DayOfYearNepali'] as String,
      remark: json['Remarks'] as String,
        dayName: json['DayName'] as String,
isHoliday: json['IsHoliday'] as bool

    );}
}