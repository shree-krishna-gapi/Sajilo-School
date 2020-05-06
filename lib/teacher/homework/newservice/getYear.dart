import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'package:sajiloschool/teacher/generic/educationalYear.dart';
import 'dart:async';
class GetYear extends StatefulWidget {
  @override
  _GetYearState createState() => _GetYearState();
}
class _GetYearState extends State<GetYear> {
  String selectedYear;
  int selectedYearId;
  @override
  void initState(){
    getCurrentYear();
    super.initState();
  }
  String currentYear;
  Future getCurrentYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentYear = prefs.getString('educationalYearNameHw');
    setState(() {
      selectedYear = currentYear;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: LabelText(labelTitle:'Education Year'),flex: 3,),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:  TextFormField(
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
              initialValue: selectedYear,
              decoration: InputDecoration(hintText: selectedYear,hintStyle: TextStyle(
                  fontSize: 15, color: Colors.white
              ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width: 1.5)
                ),
              ),
            ),
          )
          ,flex: 5,
        ),
      ],
    );
  }
  Future<void> _showDialog() {

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
                child: Container( height: 260,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,10,20,0),
                      child: FutureBuilder<List<EducationalYear>>(
                        future: FetchYear(http.Client()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) ;
                          return snapshot.hasData ?
                          CupertinoPicker(
                            itemExtent: 60.0,
                            backgroundColor: Color(0x00000000),
                            onSelectedItemChanged: (index) {

                              changedNowYear = snapshot.data[index].sYearName;
                              changedNowYearId = snapshot.data[index].educationalYearID;

                            },
                            children: new List<Widget>.generate(snapshot.data.length, (index) {
                              changedNowYear = snapshot.data[0].sYearName;
                              changedNowYearId = snapshot.data[0].educationalYearID;
                              return Align(
                                alignment: Alignment.center,
                                child: Text(snapshot.data[index].sYearName,style: TextStyle(
                                    fontSize: 17,fontWeight: FontWeight.w600, letterSpacing: 0.8
                                ),),
                              );
                            }),
                          ):Center(child: Loader());
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
                    setState(() {
                      selectedYear = changedNowYear;
                    });
                    selectedYearId = changedNowYearId;
                    prefs.setInt('educationalYearIdHw',selectedYearId);
                    prefs.setString('educationalYearNameHw',selectedYear);
                    Duration(milliseconds: 100);
                    Navigator.of(context).pop();
                  },
                ),
              ],
              elevation: 4,
            );} );

  }

  int changedNowYearId;
  String changedNowYear;

}


class LabelText extends StatelessWidget {
  LabelText({this.labelTitle});
  final String labelTitle;
  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerRight,child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(labelTitle,style: TextStyle(
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
    ));
  }
}
