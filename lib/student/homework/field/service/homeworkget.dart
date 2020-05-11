import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/api.dart';

Future<List<Hw>> FetchHw(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  String hwDate = prefs.getString('hwDate');
  try {
    var url = "${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=$hwDate";
    print('${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=$hwDate');
    final response =
    await http.get(url);
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData, stringData);
    } else {
      print("Error getting users.1");
    }
  } catch (e) {
    print("Error getting users.");
  }
// for default menu

}


List<Hw> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Hw>((json) => Hw.fromJson(json)).toList();

}
class Hw {
  final int homeworkId;
  final String subjectName;
  final String homeworkDetail;
  final bool isFileExist;
  Hw({this.homeworkId,this.subjectName,this.homeworkDetail,this.isFileExist
  });
  factory Hw.fromJson(Map<String, dynamic> json) {
    return Hw(
      homeworkId: json['HomeworkId'] as int,
      subjectName: json['SubjectName'] as String,
      homeworkDetail: json['HomeworkDetail'] as String,
      isFileExist: json['IsFileExist'] as bool
    );}
}









Future<List<Hw1>> FetchHw1(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var studentId = prefs.getInt('studentId');
  String hwDate = prefs.getString('hwDate');
  try {
    var url = "${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=$hwDate";
    print('${Urls.BASE_API_URL}/Login/GetHOmeworks?schoolId=$schoolId&studentId=$studentId&date=$hwDate');
    final response =
    await http.get(url);
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      final stringData1 = response.body;
      return compute(parseData1, stringData1);
    } else {
      print("Error getting users.1");
    }
  } catch (e) {
    print("Error getting users.");
  }
// for default menu

}


List<Hw1> parseData1(String responseBody1) {
  final parsed1 = json.decode(responseBody1).cast<Map<String, dynamic>>();
  return parsed1.map<Hw1>((json) => Hw1.fromJson(json)).toList();

}
class Hw1 {
  final int homeworkId;
  final String subjectName;
  final String homeworkDetail;
  final bool isFileExist;
  Hw1({this.homeworkId,this.subjectName,this.homeworkDetail,this.isFileExist
  });
  factory Hw1.fromJson(Map<String, dynamic> json) {
    return Hw1(
        homeworkId: json['HomeworkId'] as int,
        subjectName: json['SubjectName'] as String,
        homeworkDetail: json['HomeworkDetail'] as String,
        isFileExist: json['IsFileExist'] as bool
    );}
}