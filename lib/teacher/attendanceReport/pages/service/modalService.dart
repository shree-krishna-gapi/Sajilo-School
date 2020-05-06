import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<AttendancePerStudents>>fetchService(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var educationalYearId = prefs.getInt('educationalYearIdHwAR');
  var studentId = prefs.getInt('studentIdPer');
  bool isMonthly = prefs.getBool('isMonthlyPer');
  int monthId = prefs.getInt('monthIdPer');
  String fromDate = prefs.getString('fromDatePer');
  String toDate=  prefs.getString('fromDatePer');
  String url;
  if (isMonthly == true) {
     url = '${Urls.BASE_API_URL}/login/GetAttendanceOfStudent?schoolId=$schoolId&yearId=$educationalYearId&monthId=$monthId&studentId=$studentId&fromDate=%22%22&toDate=%22%22';
     print('one-> $url');
  }
  else {

    url = "${Urls.BASE_API_URL}/login/GetAttendanceOfStudent?schoolId=$schoolId&yearId=$educationalYearId&"
        "studentId=$studentId&fromDate=$fromDate&toDate=$toDate";
    print('two-> $url');
  }
//  http://192.168.1.89:88/api/login/GetAttendanceOfStudent?schoolId=1&yearId=30&monthId=1&studentId=320&fromDate=""&toDate=""
  final response =
  await http.get(url);
print(url);
  if (response.statusCode == 200) {
    print(response.body);
   final stringData=  jsonDecode(response.body)['StudentAttenances'];
  print('stringData $stringData');
   final e=jsonEncode(stringData);
    print('eeeeee $e');
//    final stringData = response.body;
    return compute(parseData, e);
  } else {

    print("Error getting users.1");

  }
}

List<AttendancePerStudents> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AttendancePerStudents>((json) => AttendancePerStudents.fromJson(json)).toList();

}
class AttendancePerStudents {
  String dateOfYearNepali;
  bool isPresent;
  AttendancePerStudents({
    this.dateOfYearNepali,this.isPresent });
  factory AttendancePerStudents.fromJson(Map<String, dynamic> json) {
    return AttendancePerStudents(
      dateOfYearNepali: json['DateOfYearNepali'] as String,
      isPresent: json['IsPresent'] as bool

    );}
}

