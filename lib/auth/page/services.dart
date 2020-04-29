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

        String rr  = response.body.toString();
//      var rr  = response.body;
        print('ssdsd->$rr');
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
}