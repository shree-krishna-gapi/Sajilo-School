import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<NotificationDataDetail> fetchAlbum() async {
  SharedPreferences prefs= await SharedPreferences.getInstance();
  int schoolId = prefs.getInt('schoolId');
  String noticeId = prefs.getString('noticeId');
  final response =
  await http.get('${Urls.BASE_API_URL}/Login/GetNoticedetails?schoolId=$schoolId&noticeId=$noticeId');
  if (response.statusCode == 200) {
    return NotificationDataDetail.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
class NotificationDataDetail {
  final int id;
  final String fileLocation;
  final String caption;
  final String description;
  NotificationDataDetail({
    this.id,this.fileLocation,this.caption,this.description
  });
  factory NotificationDataDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDataDetail(
      id: json['Id'] as int,
      fileLocation: json['FileLocation'] as String,
      caption: json['Caption'] as String,
      description: json['Description'] as String,
    );}
}

