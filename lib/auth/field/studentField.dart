import "package:flutter/material.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class StudentField extends StatefulWidget {
  @override
  _StudentFieldState createState() => _StudentFieldState();
}

class _StudentFieldState extends State<StudentField> {
  String _mySelection;

  List data = List(); //edited line
  Future<String> getSWData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var s = prefs.getInt('gradeId'
        '');
    final String url = "http://192.168.1.89:88/api/login/getstudent?schoolid=1&gradeid=$s";
    var res = await http
        .get(Uri.encodeFull(url));
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
          hint: Text('Select',style: TextStyle(color: Colors.white),),
          style: TextStyle(color: Colors.orange),
          items: data.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['StudentName']),
              value: item['ProfileId'].toString(),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
            });
          },
          value: _mySelection,
        )
      ;
  }
}