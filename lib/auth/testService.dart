import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TestClass {
  static Future<List<Users>> fetchUsers() async {
    final String uri = 'https://jsonplaceholder.typicode.com/users';
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Users> listOfUsers = items.map<Users>((json) {
        return Users.fromJson(json);
      }).toList();

      return listOfUsers;
    } else {
      throw Exception('Failed to load internet');
    }
  }
}
class Users {
  int id;
  String name;
  String username;
  String email;

  Users({
    this.id,
    this.name,
    this.username,
    this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
    );
  }
}



//FutureBuilder<List<Users>>(
//future: fetchUsers(),
//
//builder: (BuildContext context,
//    AsyncSnapshot<List<Users>> snapshot) {
//  return
//
//  Future<List<Users>> fetchUsers() async {