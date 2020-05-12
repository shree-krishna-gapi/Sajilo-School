import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajiloschool/utils/api.dart';

Future<List<Grade>> Fetch(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');

  try {
    final response =
    await http.get("${Urls.BASE_API_URL}/login/getgrades?schoolid=$schoolId");
    print('grade -> ${Urls.BASE_API_URL}/login/getgrades?schoolid=$schoolId');
    if (response.statusCode == 200) {

      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users.");
    }
  } catch (e) {
    print("Error getting users.");
  }
// for default menu

}


List<Grade> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Grade>((json) => Grade.fromJson(json)).toList();

}
class Grade {
  final int gradeId;
  final String gradeNameEng;
//  final String gradeNameNep;
//  final int startingMonth;
//  final int endingMonth;
//  final String remarks;
//  final bool status;
//  final String createdDate;
//  final int createdBy;
//  final String updatedDate;
//  final String updatedBy;
//  final int gradeLevel;
//  final int organizationId;
 Grade({this.gradeId,this.gradeNameEng
//   ,this.gradeNameNep,this.startingMonth,this.endingMonth,this.remarks,this.status,this.createdDate,this.createdBy,
//  this.updatedDate,this.updatedBy,this.gradeLevel,this.organizationId,
  });
  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      gradeId: json['GradeId'] as int,
      gradeNameEng: json['GradeNameEng'] as String,
//      gradeNameNep  : json['GradeNameNep'] as String,
//      startingMonth : json['StartingMonth'] as int,
//      endingMonth : json['EndingMonth'] as int,
//      remarks: json['Remarks'] as String,
//      status : json['Status'] as bool,
//      createdDate : json['CreatedDate'] as String,
//      createdBy : json['CreatedBy'] as int,
//      updatedDate : json['UpdatedDate'] as String,
//      updatedBy : json['UpdatedBy'] as String,
//      gradeLevel : json['GradeLevel'] as int,
//      organizationId : json['OrganizationId'] as int,
    );}
}