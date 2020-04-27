import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'service/subject.dart';
import 'package:sajiloschool/utils/api.dart';
class SubjectId extends StatefulWidget {
  @override
  _SubjectIdState createState() => _SubjectIdState();
}
class _SubjectIdState extends State<SubjectId> {
  int changedNowId;
  String changedNowSubject;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: Align(alignment: Alignment.centerRight,child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Subject',style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.6,
              fontSize: 15,
              shadows: [
                Shadow(
                  color: Colors.black12,
                  blurRadius: 4.0,

                )
              ]
          ),),
        )),flex: 3,),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:  selectedSubject == '' ?
            TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black12,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              readOnly: true,
              onTap: (){_showDialog();},
//                  textAlign: TextAlign.center,
              decoration: InputDecoration(hintText: "Subject",hintStyle: TextStyle(
                  fontSize: 15, color: Colors.white60
              ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60,width: 1.5)
                ),

              ),
            ):
            TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black12,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              readOnly: true,
              onTap: (){_showDialog();},
              textAlign: TextAlign.left,
              initialValue: selectedSubject,
              decoration: InputDecoration(hintText: "$selectedSubject",hintStyle: TextStyle(
                  fontSize: 15, color: Colors.white
              ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60,width: 1.5)
                ),

              ),
            ),
          )
          ,flex: 5,
        ),
      ],
    );
  }
  Future<void> _showDialog() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int schoolId =  prefs.getInt('schoolId');

    if(schoolId == 0) {
      final scaff = Scaffold.of(context);
      scaff.showSnackBar(SnackBar(
        content: Text("Please, Select The School Name"),
        backgroundColor: Colors.black26,
        duration: Duration(milliseconds: 800),
      ));
    }
    else {
      return showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xfffbf9e7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                child: Container( height: 180,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,20,20,10),

                      child: FutureBuilder<List<GetSubject>>(
                  future: FetchSubject(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasError) ;
                  return snapshot.hasData ?
                  CupertinoPicker(
                    itemExtent: 60.0,
                    backgroundColor: Color(0x00000000),
                    onSelectedItemChanged: (index) {
                      changedNowSubject = snapshot.data[index].gradeNameEng;
                      changedNowId = snapshot.data[index].gradeId;
                    },
                    children: new List<Widget>.generate(snapshot.data.length, (index) {
                      changedNowSubject = snapshot.data[0].gradeNameEng;
                      changedNowId = snapshot.data[0].gradeId;
                      return Align(
                        alignment: Alignment.center,
                        child: Text(snapshot.data[index].gradeNameEng,style: TextStyle(
                            fontSize: 16,fontWeight: FontWeight.w600, letterSpacing: 0.8
                        ),),
                      );
                      return Align(
                        alignment: Alignment.center,
                        child: Text(snapshot.data[index].gradeNameEng,style: TextStyle(
                            fontSize: 17,fontWeight: FontWeight.w600, letterSpacing: 0.8
                        ),),
                      );
                    }),
                  ):Loader();
                },
              )
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: ()async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('hwSubjectId',changedNowId);
                    setState(() {
                      selectedSubject = changedNowSubject;
                      selectedSubjectId = changedNowId;
                    });
//                    final myInheritedWidget = StateContainer.of(context);
//                    myInheritedWidget.updateEventInfo(
//                        eventName: changedNowGrade);
                    Duration(milliseconds: 500);
                    Navigator.of(context).pop();
                  },
                ),
              ],
              elevation: 4,
            );} );
    }
  }

  int selectedSubjectId = 0;
  String selectedSubject = '';
}
