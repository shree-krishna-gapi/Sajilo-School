import 'package:flutter/material.dart';
import 'user.dart';
import 'service.dart';
import 'dart:async';
class UserFilterDemo extends StatefulWidget {
  UserFilterDemo() : super();

  final String title = "Filter List Demo";

  @override
  UserFilterDemoState createState() => UserFilterDemoState();
}


class UserFilterDemoState extends State<UserFilterDemo> {

  List<User> users = List();
  List<User> filteredUsers = List();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Search School',
              ),
              onChanged: (string) {

                  setState(() {
                    filteredUsers = users
                        .where((u) => (u.name
                        .toLowerCase()
                        .contains(string.toLowerCase()) ||
                        u.email.toLowerCase().contains(string.toLowerCase())))
                        .toList();
                  });

              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: filteredUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context,filteredUsers[index].name);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              filteredUsers[index].name,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              filteredUsers[index].email.toLowerCase(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}