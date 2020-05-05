//import 'package:flutter/material.dart';
//import 'dart:async';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'package:sajiloschool/utils/api.dart';
//class StudentGrade extends StatefulWidget {
//  StudentGrade({this.schoolId});
//  final int schoolId;
//
//  @override
//  _StudentGradeState createState() => _StudentGradeState();
//}
//
//class _StudentGradeState extends State<StudentGrade> {
//
//  String _valProvince;
//  List<dynamic> _dataProvince = List();
//  void getProvince() async {
//    String _baseUrl = "${Urls.BASE_API_URL}/login/getgrades?schoolid=1";
//    print(_baseUrl);
//    final respose = await http.get(_baseUrl); //untuk melakukan request ke webservice
//    print(respose.body);
//    var listData = jsonDecode(respose.body); //lalu kita decode hasil datanya
//    setState(() {
//      _dataProvince = listData; // dan kita set kedalam variable _dataProvince
//    });
//    print("data : $listData");
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    getProvince();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text("Dropdown Menu Button JSON")),
//      body: Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            DropdownButton(
//              hint: Text("Select Province"),
//              value: _valProvince,
//              items: _dataProvince.map((item) {
//                return DropdownMenuItem(
//                  child: Text(item['GradeNameEng']),
//                  value: item['GradeId'],
//                );
//              }).toList(),
//              onChanged: (value) {
//                print('sdfsdfs ${value['GradeNameEng']}');
//                setState(() {
//                  _valProvince = value['GradeNameEng'];
//                });
//              },
//            ),
//            Text(
//              "Kamu memilih provinsi $_valProvince",
//              style: TextStyle(
//                  color: Colors.black,
//                  fontSize: 20,
//                  fontWeight: FontWeight.bold),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
