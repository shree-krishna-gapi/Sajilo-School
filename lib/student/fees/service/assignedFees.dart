import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<AssignedFees>> fetch(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var schoolId = prefs.getInt('schoolId');
  var educationalYearId = prefs.getInt('educationalYearIdFees');
  var studentId = prefs.getInt('studentId');
  try {
    final response = await http.get("${Urls.BASE_API_URL}/login/StudentAssignedFee?schoolid=$schoolId&educationYear=$educationalYearId&studentId=$studentId");
    print('${Urls.BASE_API_URL}/login/StudentAssignedFee?schoolid=$schoolId&educationYear=$educationalYearId&studentId=$studentId');
    if (response.statusCode == 200) {
      final stringData = response.body;
      return compute(parseData1, stringData);
    } else {
      print("Error getting users.1");
    }
  } catch (e) {
    print("Error getting users.2");
  }
}

List<AssignedFees> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<AssignedFees>((json) => AssignedFees.fromJson(json)).toList();

}
class AssignedFees {
  int feeTypeId;
  double amount;
  String feeType;
  String paymentPeriod;
  int feeReceivableId;
  bool isActive;
  double unbalanceAmt;
  AssignedFees({
    this.feeTypeId,this.amount,this.feeType,this.paymentPeriod,this.feeReceivableId,this.isActive,this.unbalanceAmt
  });
  factory AssignedFees.fromJson(Map<String, dynamic> json) {
    return AssignedFees(
      feeTypeId: json['FeeTypeId'] as int,
      amount: json['Amount'] as double,
      feeType: json['FeeType'] as String,
      paymentPeriod: json['PaymentPeriod'] as String,
      feeReceivableId: json['FeeReceivableId'] as int,
      isActive: json['IsActive'] as bool,
      unbalanceAmt: json['UnbalanceAmt'] as double,

    );}
}

