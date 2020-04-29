import 'dart:async';
import 'dart:convert'; // convert json to list
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // http: ^0.12.0+2

void main()=>runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: new HomePage(),
  theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.blue)),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List data;
//  static List<User> users = new List<User>();
// getUsers() async{
//    String url = 'http://192.168.1.89:88/api/login/getstudent?schoolid=1&gradeid=3';
//    var response = await http.get(Uri.encodeFull(url),
//    );
//    users = loadUsers(response.body);
//
//
//    data = jsonDecode(response.body);
//    print(data[1]['title']);
//    return "Success!";
//  }
  @override
  void initState() {
//    this.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sample of Json Data'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),
            onPressed: (){showSearch(context: context, delegate: DataSearch());},
          )
        ],
      ),



//      floatingActionButton: FloatingActionButton(onPressed: getData,child: Icon(Icons.mic), ),
//      drawer: Drawer(),
    );
  }
}

class DataSearch extends SearchDelegate<String> {

  final cities = [
    "adfaf",
    "rewdsfds",
    "sdfsaaasd",
    "ererg",
    "wef",
    "efew",
    "ewr",
    "wv",
    "rtjtr",
    "yyuiyu",
    "abdbadfs",
    "trjhge",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    }) ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        icon:AnimatedIcons.menu_arrow,color: Colors.purple,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    // show more result based on the selection
    return Center(
      child: Container(

        child: Text(query,style: TextStyle(fontSize: 24.0),),


      ),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty?cities
        :cities.where((p) => p.startsWith(query)).toList(); // search filter by character

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
//          showResults(context);
          print('${cities[index]}');
        },
        leading: Icon(Icons.search),
        title: RichText(text: TextSpan(
            text: suggestionList[index].substring(0,query.length),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                  text: suggestionList[index].substring(query.length),
                  style: TextStyle(color: Colors.red)
              )
            ]
        )),
      ),
      itemCount: suggestionList.length,
    );
  }
}