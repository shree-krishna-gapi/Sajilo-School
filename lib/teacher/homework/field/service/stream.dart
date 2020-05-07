import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/api.dart';

Future<List<GetStream>> FetchStream(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var gradeId = prefs.getInt('gradeId');
  try {
    print('stream-> ${Urls.BASE_API_URL}/login/GetStreams?schoolid=$schoolId&gradeId=$gradeId');
    final response =
    await http.get("${Urls.BASE_API_URL}/login/GetStreams?schoolid=$schoolId&gradeId=$gradeId");
    if (response.statusCode == 200) {

      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users.");
    }
  } catch (e) {
    print("Error getting users.");
  }
}

List<GetStream> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<GetStream>((json) => GetStream.fromJson(json)).toList();
}
class GetStream {
  final int streamId;
  final String streamName;
  GetStream({this.streamId,this.streamName,
  });
  factory GetStream.fromJson(Map<String, dynamic> json) {
    return GetStream(
      streamId: json['StreamId'] as int,
      streamName: json['StreamNameEnglish'] as String,
    );}
}