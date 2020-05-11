import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<DownloadFile>> FetchDownload(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var noticeId = prefs.getString('noticeId');
  print('uuuuuuuuuuuuu');
  try {
    String url = "${Urls.BASE_API_URL}/login/GetNoticedetails?schoolid=$schoolId&noticeId=$noticeId";
    print(url);
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


List<DownloadFile> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<DownloadFile>((json) => DownloadFile.fromJson(json)).toList();

}
class DownloadFile {
  final String fileLocation;
  final String homeworkText;
  DownloadFile({this.fileLocation,this.homeworkText
  });
  factory DownloadFile.fromJson(Map<String, dynamic> json) {
    return DownloadFile(
      fileLocation: json['FileLocation'] as String,
      homeworkText: json['Description'] as String,
    );}
}

//import 'dart:async';
//import 'dart:convert';
//import 'package:flutter/foundation.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sajiloschool/utils/api.dart';
//
//Future<List<DownloadNoticeFile>> FetchNotice(http.Client client) async {
//  final SharedPreferences prefs = await SharedPreferences.getInstance();
//  var schoolId = prefs.getInt('schoolId');
//  var noticeId = prefs.getInt('noticeId');
//  try {
//    http://192.168.1.89:88/Api/Login/GetHomeworksDetails?schoolId=1&homeworkId=19
//    String urll = "http://192.168.1.89:88/api/login/GetNoticedetails?schoolid=1&noticeId=2";
//    String url = "${Urls.BASE_API_URL}/Login/GetNoticedetails?schoolId=$schoolId&noticeId=$noticeId";
//    print('notice download : $urll');
//    final response =
//    await http.get(urll);
//    print(response.body);
//    if (response.statusCode == 200) {
//
//      final stringData = response.body;
//      return compute(parseData, stringData);
//    } else {
//      print("Error getting users.1");
//    }
//  } catch (e) {
//    print("Error getting users.");
//  }
//// for default menu
//
//}
//
//
//List<DownloadNoticeFile> parseData(String responseBody) {
//  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//  return parsed.map<DownloadNoticeFile>((json) => DownloadNoticeFile.fromJson(json)).toList();
//
//}
//class DownloadNoticeFile {
//  final String fileLocation;
//  DownloadNoticeFile({this.fileLocation
//  });
//  factory DownloadNoticeFile.fromJson(Map<String, dynamic> json) {
//    return DownloadNoticeFile(
//      fileLocation: json['FileLocation'] as String,
//    );}
//}