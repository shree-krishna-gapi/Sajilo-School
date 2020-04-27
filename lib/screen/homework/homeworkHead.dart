//import 'package:flutter/material.dart';
//import 'package:school/utils/fadeAnimation.dart';
//import 'package:school/utils/api.dart';
//import 'package:school/global/educationalYear.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:nepali_date_picker/nepali_date_picker.dart';
//class HomeworkHead extends StatefulWidget {
//  @override
//  _HomeworkHeadState createState() => _HomeworkHeadState();
//}
//class _HomeworkHeadState extends State<HomeworkHead> {
//  String logoImage;
//  @override
//  void initState() {
//    getImageLink();
//    super.initState();
//  }
//  getImageLink() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      logoImage = prefs.getString('logoImage');
//    });
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Column(
//      children: <Widget>[
//        SizedBox(height: 35,),
//        FadeAnimation(
//          1.0, Container(
//          height: 100, width: double.infinity,
////            child: FlutterLogo()
//          child:   logoImage != null ? Image.network('${Urls.Image_API_URL}/$logoImage') :
//          FlutterLogo(),
//        ),
//        ),
//        SizedBox(height: 25,),
//        FadeAnimation(0.4, EducationalYear(),),
//        SizedBox(height: 15,),
//        Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 20),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Text('Selected Date:',style: TextStyle(fontStyle: FontStyle.italic,
//                    fontSize: 15),),
//                SizedBox(width: 15,),
//                InkWell(
//                  onTap: () async{
//                    SharedPreferences prefs= await SharedPreferences.getInstance();
//                    String old = prefs.getString('hwDate');
//                    NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
//                      context: context,
//                      initialDate: NepaliDateTime.now(),  //NepaliDateTime.now(),
//                      firstDate: NepaliDateTime(2000),
//                      lastDate: NepaliDateTime(2090),
//                      language: Language.english,
//                      initialDatePickerMode: DatePickerMode.day,
//                    );
//                    setState(() {
//                      date=NepaliDateFormat("y-MM-dd").format(_selectedDateTime);
//                    });
//                    prefs.setString('hwDate',date);
//                    if(old != date) {
//                      setState(() {
//                        loadDate = true;
//                      });
//                    }
//
//
//                  },
//                  child: Row(
//                    children: <Widget>[
//                      Column(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Text('$date',style: TextStyle(
//                                  fontWeight: FontWeight.w600,
//                                  letterSpacing: 0.8,
//                                  fontSize: 15,
//                                  fontStyle: FontStyle.italic
//                              ),),
//                              SizedBox(width: 5,),
//                              Icon(Icons.arrow_downward,size: 16,),
//                            ],
//                          ),
//                          SizedBox(height: 3,),
//                          Container(
//                            height: 2,
//                            width: 105,
//                            decoration: BoxDecoration(
//                                gradient: purpleGradient
//                            ),
//                          )
//                        ],
//                      )
//
//                    ],
//                  ),
//                ),
//              ],
//            )
//        )
//      ],
//    );
//  }
//}
