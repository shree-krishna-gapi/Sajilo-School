import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:sajiloschool/utils/api.dart';

class Services {
  static Future<List<User>> getUsers(schoolId,gradeId) async {
   String url = '${Urls.BASE_API_URL}/login/getstudent?schoolid=$schoolId&gradeid=$gradeId';
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<User> list = parseUsers(response.body);
          return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  // Grade
  static Future<List<Grade1>> getGrades(schoolId) async {
    String url = '${Urls.BASE_API_URL}/login/getgrades?schoolid=$schoolId';
    print(url);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Grade1> list1 = parseUsers1(response.body);
        return list1;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  static List<Grade1> parseUsers1(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Grade1>((json) => Grade1.fromJson(json)).toList();
  }
}
class Grade1 {
  int id;
  String name;
  int email;
  Grade1({this.id, this.name, this.email});
  factory Grade1.fromJson(Map<String, dynamic> json) {
    return Grade1(
      id: json["GradeId"] as int,
      name: json["GradeNameEng"] as String,
      email: json["GradeId"] as int,
    );
  }
}