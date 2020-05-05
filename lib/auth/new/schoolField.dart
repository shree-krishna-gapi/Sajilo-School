import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:sajiloschool/utils/api.dart';
import 'package:http/http.dart' as http;
import 'schoolService.dart';
import 'package:sajiloschool/utils/pallate.dart';
import 'dart:async';
import 'dart:convert';
class SchoolField extends StatefulWidget {
  @override
  _SchoolFieldState createState() => _SchoolFieldState();
}

class _SchoolFieldState extends State<SchoolField> {
  GlobalKey<AutoCompleteTextFieldState<School>> schoolKey = new GlobalKey();
  AutoCompleteTextField searchSchoolField;
  bool loading = true;
  int selectedSchoolId;
  @override
  void initState() {
    getUsers();
    super.initState();
  }

  static List<School> schoolData = new List<School>();
  getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('schoolId',0);
    prefs.setInt('gradeId',0);
    try {
      final response =
      await http.get('${Urls.BASE_API_URL}/login/getschools');
      print('${Urls.BASE_API_URL}/login/getschools');
      if (response.body != null) {
        setState(() {
          schoolData = loadUsers(response.body);
          loading = false;
        });
      } else {
        print("Error getting users1.");
      }
    } catch (e) {
      print("Error getting users2. $e");
    }
  }

  static List<School> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<School>((json) => School.fromJson(json)).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(child: Text(''),flex: 2,),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: loading
                  ? Loader()
                  : searchSchoolField = AutoCompleteTextField<School>(
                key: schoolKey,
                clearOnSubmit: false,
                suggestions: schoolData,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black12,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                decoration: InputDecoration(
                    hintText: "Search School",
                    hintStyle: TextStyle(fontSize: 16, color: Colors.white),focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70,width: 1.5)
                )
                ),
                itemFilter: (item, query) {
                  return item.name
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.name.compareTo(b.name);
                },
                itemSubmitted: (item)async {
                  // todo: autoCompleteField
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  int oldSchoolId = prefs.getInt('schoolId');

                  if(oldSchoolId != item.id) {
                    prefs.setInt('gradeId',0);
                    prefs.setInt('studentId',0);
//                    selectedStudentId = 0;
//                    setState(() {
//                      selectedGrade = '';
//                      selectedStudentName = '';
//                    });

                  }
                  selectedSchoolId = item.id;
                  prefs.setInt('schoolId',selectedSchoolId);
                  print('${item.logoImage}');
                  prefs.setString('logoImage',item.logoImage);
                  setState(() {
                    searchSchoolField.textField.controller.text = item.name;
                  });
                },
                itemBuilder: (context, item) {
                  return row(item);
                },
              ),
            ),
          ),flex: 6,),
          Expanded(child: Container(
          ),flex: 2,)
        ],
      ),
      height: 65,
    );
  }
  Widget row(School school) {
    return Container(
      decoration: BoxDecoration(
          gradient: purpleGradient,
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                color: Colors.black12,blurRadius: 2
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            school.name,
            style: TextStyle(fontSize: 16.0,color: Colors.white),
          ),
          SizedBox(
            width: 10.0,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: school.address == null ? Text('') :Text(
                  school.address,style: TextStyle(color: Colors.white70,fontSize: 12),
                ),
              )
          ),
        ],
      ),
    );
  }
}
