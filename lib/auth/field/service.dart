import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class Services {
  static const String url = 'http://192.168.1.89:88/api/login/getstudent?schoolid=1&gradeid=1';

  getUsers() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<User> list = parseUsers(response.body);
        return list;

      var tt= response.body.toString();
      return tt;
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