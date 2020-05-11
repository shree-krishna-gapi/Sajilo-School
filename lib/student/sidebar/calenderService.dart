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
  int monthId = prefs.getInt('studentCalenderMonthId');
  String url = '${Urls.BASE_API_URL}/Login/GetSchoolCalendar?schoolId=$schoolId&yearId=$yearId&monthId=$monthId&IsStudent=true';
  print('calender $url');
  try {
    final response = await http.get(url);
    return compute(parseData, response.body);
  } catch (e) {
    print("Error getting users.2");
  }
}

List<CalenderData> parseData(String responseBody) {
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



Future<List<CalenderData1>> FetchCalender1(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int schoolId = prefs.getInt('schoolId');
  int yearId = prefs.getInt('educationalYearIdCalender');
  int monthId = prefs.getInt('studentCalenderMonthId');
  String url = '${Urls.BASE_API_URL}/Login/GetSchoolCalendar?schoolId=$schoolId&yearId=$yearId&monthId=$monthId&IsStudent=true';
  print('calender $url');
  try {
    final response = await http.get(url);
    return compute(parseData1, response.body);
  } catch (e) {
    print("Error getting users.2");
  }
}

List<CalenderData1> parseData1(String responseBody1) {
  final parsed1 = json.decode(responseBody1).cast<Map<String, dynamic>>();
  return parsed1.map<CalenderData1>((json) => CalenderData1.fromJson(json)).toList();

}
class CalenderData1 {
  String dayOfYearNepali;
  String remark;
  String dayName;
  bool isHoliday;
  CalenderData1({this.dayOfYearNepali,this.remark,this.dayName,this.isHoliday
  });
  factory CalenderData1.fromJson(Map<String, dynamic> json) {
    return CalenderData1(
        dayOfYearNepali: json['DayOfYearNepali'] as String,
        remark: json['Remarks'] as String,
        dayName: json['DayName'] as String,
        isHoliday: json['IsHoliday'] as bool

    );}
}