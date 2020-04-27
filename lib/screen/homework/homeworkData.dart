import 'package:flutter/material.dart';
import 'field/service/homeworkget.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/utils/fadeAnimation.dart';
class HomeworkData extends StatefulWidget {
  @override
  _HomeworkDataState createState() => _HomeworkDataState();
}

class _HomeworkDataState extends State<HomeworkData> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hw>>(
        future: FetchHw(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) ;
          if(snapshot.hasData) {
            return snapshot.data.length > 0 ?
            FadeAnimation(
              0.5, ListView.builder(
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15,12,15,12),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: ChildTxt(title: '${index+1}'), flex: 1,),
                              Expanded(child: ChildTxt(title: '${snapshot.data[index].subjectName}'), flex: 2,),
                              Expanded(child: Align(child: ChildTxt(
                                  title: '${snapshot.data[index].homeworkDetail}'),
                                alignment: Alignment.bottomLeft,), flex: 4,),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }
              ),
            ) : FadeAnimation(
              0.4, Align(
                  alignment: Alignment.center,
                  child: Text('Data Not Found.',style: TextStyle(fontSize: 20,
                    letterSpacing: 0.4,),)
              ),
            );
          }
          else {
            return Loader();
          }
        });
  }
}
class ChildTxt extends StatelessWidget {
  ChildTxt({this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return Text(title,style: TextStyle(
      letterSpacing: 0.4, fontSize: 15));
  }
}