import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<PaidFee>>fetchfee(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var educationalYearId = prefs.getInt('educationalYearIdFees');
  var studentId = prefs.getInt('studentId');
    final response =
    await http.get("${Urls.BASE_API_URL}/login/StudentPaidFees?schoolid=$schoolId&educationYear=$educationalYearId&studentId=$studentId");
    print('${Urls.BASE_API_URL}/login/StudentPaidFees?schoolid=$schoolId&educationYear=$educationalYearId&studentId=$studentId');
    if (response.statusCode == 200) {
      final stringData = response.body;
//      print('hello');
//     if(response.body == null) {
//       print('data is empty');
//     }
      return compute(parseData1, stringData);
    } else {

      print("Error getting users.1");

    }
}

List<PaidFee> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<PaidFee>((json) => PaidFee.fromJson(json)).toList();

}
class PaidFee {
  int studentBillMasterId;
  String billNumber;
  String billDate;
  String billDateNepali;
  double amount;
  double receiptAmount;
  double discount;
  int voucherId;
  PaidFee({
    this.studentBillMasterId,this.billNumber,this.billDate,this.billDateNepali,this.amount,this.receiptAmount,this.discount,this.voucherId
  });
  factory PaidFee.fromJson(Map<String, dynamic> json) {
    return PaidFee(
      studentBillMasterId: json['StudentBillMasterId'] as int,
      billNumber: json['BillNumber'] as String,
      billDate: json['BillDate'] as String,
      billDateNepali: json['BillDateNepali'] as String,
      amount: json['Amount'] as double,
      receiptAmount: json['ReceiptAmount'] as double,
      discount:json['Discount'] as double,
      voucherId: json['VouvherId'] as int,

    );}
}

