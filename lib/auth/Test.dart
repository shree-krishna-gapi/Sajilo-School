import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'testService.dart';
class JsonApiDropdown extends StatefulWidget {
  @override
  JsonApiDropdownState createState() {
    return new JsonApiDropdownState();
  }
}

class JsonApiDropdownState extends State<JsonApiDropdown> {
  Users _currentUser;


  @override
  void initState() {
    super.initState();
//    TestClass.fetchUsers().then((usersFromServer) {
//      print(usersFromServer.runtimeType);
//      print(usersFromServer);
//      setState(() {
////        _currentUser = usersFromServer;
//      });
//    });
  }


   List<String> _items = ['sdf','sdfsdf'].toList();

  String _selection;
  @override
  Widget build(BuildContext context) {
    _selection = _items.first;

    final dropdownMenuOptions = _items
        .map((String item) =>
    new DropdownMenuItem<String>(value: item, child: new Text(item))
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Fetching data from JSON - DropdownButton'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(onPressed: (){
              TestClass.fetchUsers().then((usersFromServer) {
                print(usersFromServer.runtimeType);
                print(usersFromServer);
              });
            }, child: Text('sdfsdf')), SizedBox(height: 40,),
            DropdownButton<String>(
                value: _selection,
                items: dropdownMenuOptions,
                onChanged: (s) {
                  setState(() {
                    if(s != null)
                      _selection = s;
                  });
                }
            )

          ],
        ),
      ),
    );
  }
}

