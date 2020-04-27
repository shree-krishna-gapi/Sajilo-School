import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sajiloschool/utils/api.dart';
import 'service/educationalYear.dart';
class GetYear extends StatefulWidget {
  @override
  _GetYearState createState() => _GetYearState();
}
class _GetYearState extends State<GetYear> {
  String selectedYear = '';
  int selectedYearId;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: Align(alignment: Alignment.centerRight,child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text('Educational Year',style: TextStyle(
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
            child:  selectedYear == '' ?
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
              decoration: InputDecoration(hintText: "YYYY",hintStyle: TextStyle(
                  fontSize: 15, color: Colors.white60
              ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white60,width: 1.5)
                ),
              ),
            )
                :
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
              initialValue: selectedYear,
              decoration: InputDecoration(hintText: "$selectedYear",hintStyle: TextStyle(
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
                child: Container( height: 180,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,20,20,10),
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
                    prefs.setInt('hwYearId',changedNowYearId);
                    setState(() {
                      selectedYear = changedNowYear;
                      selectedYearId = changedNowYearId;
                    });
                    Duration(milliseconds: 500);
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
