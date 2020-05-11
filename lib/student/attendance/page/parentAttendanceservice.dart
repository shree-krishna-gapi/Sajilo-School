import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<StudentAttendanceData>> FetchParentAttendance(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  int yearId = prefs.getInt('educationalYearIdAttendance');
  int monthId = prefs.getInt('educationalMonthIdAttendance');
  String fromDate = prefs.getString('AttendanceSelectFromDate');
  String toDate = prefs.getString('AttendanceSelectToDate');
  bool isMonthly = prefs.getBool('parentAttendanceIsMonthly');
  String url;
//  String urll = "http://192.168.1.89:88/api/Login/GetAttendanceOfStudent?schoolId=1&yearId=30&monthId=0&studentId=319&fromDate=2076-12-09&toDate=2076-12-23";
  if(isMonthly) {
    url = "${Urls.BASE_API_URL}/Login/GetAttendanceOfStudent?schoolId=$schoolId&yearId=$yearId&monthId=$monthId&studentId=$studentId&fromDate=%02%03&toDate=%02%03";
  }
  else {
    url = "${Urls.BASE_API_URL}/Login/GetAttendanceOfStudent?schoolId=$schoolId&yearId=$yearId&monthId=0&studentId="
        "$studentId&fromDate=$fromDate&toDate=$toDate";
  }
  print('attendance $url');

  final response =
  await http.get(url);
  print(response.body);
  if (response.statusCode == 200) {
    var yy = jsonDecode(response.body)['StudentAttenances'];
    var zz = jsonEncode(yy);
    return compute(parseData, zz.toString());
  } else {
    print("Error getting users.1");
  }
}
List<StudentAttendanceData> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<StudentAttendanceData>((json) => StudentAttendanceData.fromJson(json)).toList();
}
class StudentAttendanceData {
  final String dateOfYearNepali;
  final bool isPresent;
  final bool isWorkingDay;
  final String dayName;
//  final List studentAttenances;
  StudentAttendanceData({this.dateOfYearNepali,this.isPresent,this.isWorkingDay,this.dayName
  });
  factory StudentAttendanceData.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceData(
        dateOfYearNepali: json['DateOfYearNepali'] as String,
      isPresent:json['IsPresent'] as bool,
        isWorkingDay:json['IsWorkingDay'] as bool,
    dayName:json['DayName'] as String
//      studentAttenances: json['StudentAttenances'] as List,
    );}
}



Future<List<StudentAttendanceData1>> FetchParentAttendance1(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  int yearId = prefs.getInt('educationalYearIdAttendance');
  int monthId = prefs.getInt('educationalMonthIdAttendance');
  String fromDate = prefs.getString('AttendanceSelectFromDate');
  String toDate = prefs.getString('AttendanceSelectToDate');
  bool isMonthly = prefs.getBool('parentAttendanceIsMonthly');
  String url;
//  String urll = "http://192.168.1.89:88/api/Login/GetAttendanceOfStudent?schoolId=1&yearId=30&monthId=0&studentId=319&fromDate=2076-12-09&toDate=2076-12-23";
  if(isMonthly) {
    url = "${Urls.BASE_API_URL}/Login/GetAttendanceOfStudent?schoolId=$schoolId&yearId=$yearId&monthId=$monthId&studentId=$studentId&fromDate=%02%03&toDate=%02%03";
  }
  else {
    url = "${Urls.BASE_API_URL}/Login/GetAttendanceOfStudent?schoolId=$schoolId&yearId=$yearId&monthId=0&studentId="
        "$studentId&fromDate=$fromDate&toDate=$toDate";
  }
  print('attendance1 $url');

  final response =
  await http.get(url);
  print(response.body);
  if (response.statusCode == 200) {
    var yy = jsonDecode(response.body)['StudentAttenances'];
//    final stringData = response.body;
    var zz = jsonEncode(yy);
    return compute(parseData1, zz.toString());
  } else {
    print("Error getting users.1");
  }


}


List<StudentAttendanceData1> parseData1(String responseBody1) {
  final parsed1 = json.decode(responseBody1).cast<Map<String, dynamic>>();
  return parsed1.map<StudentAttendanceData1>((json) => StudentAttendanceData1.fromJson(json)).toList();

}
class StudentAttendanceData1 {
  final String dateOfYearNepali;
  final bool isPresent;
  final bool isWorkingDay;
  final String dayName;
//  final List studentAttenances;
  StudentAttendanceData1({this.dateOfYearNepali,this.isPresent,this.isWorkingDay,this.dayName
  });
  factory StudentAttendanceData1.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceData1(
        dateOfYearNepali: json['DateOfYearNepali'] as String,
        isPresent:json['IsPresent'] as bool,
        isWorkingDay:json['IsWorkingDay'] as bool,
        dayName:json['DayName'] as String
//      studentAttenances: json['StudentAttenances'] as List,
    );}
}