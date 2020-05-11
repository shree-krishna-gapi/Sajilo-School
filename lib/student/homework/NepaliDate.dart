//import 'package:flutter/material.dart';
//import 'package:nepali_date_picker/nepali_date_picker.dart';
///// Example
//class NepaliDatePickerExample extends StatefulWidget {
//  @override
//  _NepaliDatePickerExampleState createState() =>
//      _NepaliDatePickerExampleState();
//}
//
//class _NepaliDatePickerExampleState extends State<NepaliDatePickerExample> {
//  var _selectedDateTime =  NepaliDateTime.now();
//  getDate()async {
//    NepaliDateTime _selectedDateTime = await showMaterialDatePicker(
//      context: context,
//      initialDate: NepaliDateTime.now(),
//      firstDate: NepaliDateTime(2000),
//      lastDate: NepaliDateTime(2090),
//      language: Language.english,
//
//      initialDatePickerMode: DatePickerMode.day,
//    );
//    print(NepaliDateFormat("dd/mm/y",).format(_selectedDateTime));
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: Container(height:50, child: InkWell(
//        child: Text('Select Date: ${NepaliDateFormat("dd/mm/y",).format(_selectedDateTime)}'),
//        onTap: () {
//          getDate();
//          },
//      )),
//    );
//  }
//}