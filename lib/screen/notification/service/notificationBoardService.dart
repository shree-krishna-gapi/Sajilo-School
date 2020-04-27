import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<NotificationData>>fetchNotification(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  final response =
  await http.get("${Urls.BASE_API_URL}/login/GetNotice?schoolid=$schoolId");
  print('${Urls.BASE_API_URL}/login/GetNotice?schoolid=$schoolId');
  if (response.statusCode == 200) {
    final stringData = response.body;
    return compute(parseData, stringData);
  } else {

    print("Error getting users.1");

  }
}

List<NotificationData> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<NotificationData>((json) => NotificationData.fromJson(json)).toList();
}
class NotificationData {
  final int id;
  final int contentTypeId;
  final String caption;
  final String description;
  final bool isPublish;
  final String publishDateNepali;
  NotificationData({
   this.id,this.contentTypeId,this.caption,this.description,this.isPublish,this.publishDateNepali
  });
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['Id'] as int,
      contentTypeId: json['ContentTypeId'] as int,
      caption: json['Caption'] as String,
      description: json['Description'] as String,
      isPublish: json['IsPublish'] as bool,
      publishDateNepali: json['PublishedDateNepali'] as String,

    );}
}

