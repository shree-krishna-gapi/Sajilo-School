import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
String url;
Future<List<FeeRemaningGet>>fetchRemaningFee(http.Client client) async {

  print('screen/fees/service/remaningFees');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var educationalYearId = prefs.getInt('educationalYearIdFees');
  var studentId = prefs.getInt('studentId');
  url = "${Urls.BASE_API_URL}/login/StudentRemainingFees?schoolid=$schoolId&educationYear=$educationalYearId&studentId=$studentId";
  final response =
  await http.get(url);
  print('$url');
  if (response.statusCode == 200) {
    final stringData = response.body;
    return compute(parseData, stringData);
  } else {
    print("Error getting users.1");

  }
}

List<FeeRemaningGet> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<FeeRemaningGet>((json) => FeeRemaningGet.fromJson(json)).toList();

}
class FeeRemaningGet {
  String fromMonthName;
  String toMonthName;
  double amount;
  double total;
  String feeTypeEng;
  FeeRemaningGet({
    this.fromMonthName,this.toMonthName,this.amount,this.total,this.feeTypeEng
  });
  factory FeeRemaningGet.fromJson(Map<String, dynamic> json) {
    return FeeRemaningGet(
      fromMonthName: json['FromMonthName'] as String,
      toMonthName: json['ToMonthName'] as String,
      amount: json['Amount'] as double,
      total: json['Total'] as double,
      feeTypeEng: json['FeeTypeEng'] as String,

    );}
}

