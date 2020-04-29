//import 'dart:async';
//import 'dart:convert';
//import 'package:flutter/foundation.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sajiloschool/utils/api.dart';
//
//Future<List<Student>> FetchStudent(http.Client client) async {
//  final SharedPreferences prefs = await SharedPreferences.getInstance();
//  var schoolId = prefs.getInt('schoolId');
//  var gradeId = prefs.getInt('gradeId');
//  try {
//    final response =
//    await http.get("${Urls.BASE_API_URL}/login/getstudent?schoolid=$schoolId&gradeid=$gradeId");
//    print('${Urls.BASE_API_URL}/login/getstudent?schoolid=$schoolId&gradeid=$gradeId');
//    //todo : get student url
//    if (response.statusCode == 200) {
//      final stringData = response.body;
////      if(response.body == null) {
////        return 'Empty mseg';
////      }
//      prefs.setString('getStudent',stringData.toString());
//      return compute(parseData1, stringData);
//    } else {
//      print("Error getting student!");
//    }
//  } catch (e) {
//    print("Error getting student.");
//  }
//// for default menu
//
//}
//
//
//List<Student> parseData1(String responseBody) {
//  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//  return parsed.map<Student>((json) => Student.fromJson(json)).toList();
//
//}
//class Student {
//  final int profileId;
//  final  String guardian;
//  final  int organizationId;
//  final  int accountHeadId;
//  final  String accountHeadName;
////  final  String phoneNumber;
////  final  String mobileNumber;
//  final  String registrationDate;
//  final  String registrationDateNepali;
//  final  int permanentMunicipalityId;
//  final  String permMunicipality;
//  final  String imageLocation;
//  final  String imageName;
//  final  bool imageChange;
//  final  String emailAddress;
//  final  int permWard;
////  final  String temporaryMunicipalityId;
////  final  String tempWard;
////  final  String remarks;
//  final  bool isDropped;
////  final  String dropedRemarks;
//  final  bool status;
//  final  int createdBy;
//  final  String createdDate;
//  final  int modifiedBy;
//  final  String modifiedDate;
////  final  String studentProfileList;
//  final  int studentClassId;
////  final  String section;
//  final  String grade;
//  final  int gradeId;
//  final  String stream;
//  final  int streamId;
//  final  int rollNo;
//  final  int gender;
//  final  String genderName;
//  final  String middleName;
//  final  int religion;
//  final  String religionName;
//  final  int ethnicity;
////  final  String ethnicityGroup;
//  final  String dateOfBirth;
//  final  int nationality;
//  final  String nationalityName;
//  final  int spokenLanguage;
//  final  String spokenLanguageName;
//  final  int shift;
////  final  String shiftName;
//  final  int districtId;
//  final  int provinceId;
////  final  String tempProvinceId;
////  final  String tempDistrictId;
//  final  String dateOfBirthNepali;
//  final  bool isAlreadyRegistered;
//  final  int classId;
//  final  bool isSelected;
//  final  String validTill;
//  final  String studentName;
//  final  int educationalYearId;
//  final  int studentBusId;
////  final  String dEOid;
//  final  String house;
//  final  String houseName;
//  final  String localAddress;
//  Student({this.profileId,this.guardian,this.organizationId,this.accountHeadId,this.accountHeadName,
////    this.phoneNumber,this.mobileNumber,
//    this.registrationDate,
//  this.registrationDateNepali,this.permanentMunicipalityId,this.permMunicipality,this.imageLocation,this.imageName,this.imageChange,
//  this.emailAddress,this.permWard,
////    this.temporaryMunicipalityId,this.tempWard,this.remarks,
//    this.isDropped,
////    this.dropedRemarks,
//    this.status,
//  this.createdBy,this.createdDate,this.modifiedBy,this.modifiedDate,
////    this.studentProfileList,
//    this.studentClassId,
////    this.section,
//    this.grade,
//    this.gradeId,this.stream,this.streamId,this.rollNo,this.gender,this.genderName,this.middleName,this.religion,
//    this.religionName,this.ethnicity,
////    this.ethnicityGroup,
//    this.dateOfBirth,this.nationality,this.nationalityName,
//    this.spokenLanguage,this.spokenLanguageName,this.shift,
////    this.shiftName,
//    this.districtId,this.provinceId,
////    this.tempProvinceId,this.tempDistrictId,
//    this.dateOfBirthNepali,this.isAlreadyRegistered,this.classId,this.isSelected,
//    this.validTill,this.studentName,this.educationalYearId,this.studentBusId,
////    this.dEOid,
//    this.house,this.houseName,this.localAddress,
//  });
//  factory Student.fromJson(Map<String, dynamic> json) {
//    return Student(
//      profileId: json['ProfileId'] as int,
//      guardian: json['Guardian'] as String,
//      organizationId: json['OrganizationId'] as  int,
//      accountHeadId: json['AccountHeadId'] as  int,
//      accountHeadName: json['AccountHeadName'] as String,
////      phoneNumber: json['PhoneNumber'] as String,
////      mobileNumber: json['MobileNumber'] as String,
//      registrationDate: json['RegistrationDate'] as String,
//      registrationDateNepali: json['RegistrationDateNepali'] as String,
//      permanentMunicipalityId: json['PermanentMunicipalityId'] as  int,
//      permMunicipality: json['PermMunicipality'] as String,
//      imageLocation: json['ImageLocation'] as String,
//      imageName: json['ImageName'] as String,
//      imageChange: json['ImageChange'] as  bool,
//      emailAddress: json['EmailAddress'] as String,
//      permWard: json['PermWard'] as  int,
////      temporaryMunicipalityId: json['TemporaryMunicipalityId'] as String,
////      tempWard: json['TempWard'] as String,
////      remarks: json['Remarks'] as String,
//      isDropped: json['IsDropped'] as  bool,
////      dropedRemarks: json['DropedRemarks'] as String,
//      status: json['Status'] as  bool,
//      createdBy: json['CreatedBy'] as  int,
//      createdDate: json['CreatedDate'] as String,
//      modifiedBy: json['modifiedBy'] as int,
//      modifiedDate: json['modifiedDate'] as String,
////      studentProfileList: json['StudentProfileList'] as String,
//      studentClassId: json['StudentClassId'] as  int,
////      section: json['Section'] as String,
//      grade: json['Grade'] as String,
//      gradeId: json['GradeId'] as  int,
//      stream: json['Stream'] as String,
//      streamId: json['StreamId'] as  int,
//      rollNo: json['RollNo'] as  int,
//      gender: json['Gender'] as  int,
//      genderName: json['GenderName'] as String,
//      middleName: json['MiddleName'] as String,
//      religion: json['Religion'] as  int,
//      religionName: json['ReligionName'] as String,
//      ethnicity: json['Ethnicity'] as  int,
////      ethnicityGroup: json['EthnicityGroup'] as String,
//      dateOfBirth: json['DateOfBirth'] as String,
//      nationality: json['Nationality'] as  int,
//      nationalityName: json['NationalityName'] as String,
//      spokenLanguage: json['SpokenLanguage'] as  int,
//      spokenLanguageName: json['SpokenLanguageName'] as String,
//      shift: json['Shift'] as  int,
////      shiftName: json['ShiftName'] as String,
//      districtId: json['DistrictId'] as  int,
//      provinceId: json['ProvinceId'] as  int,
////      tempProvinceId: json['TempProvinceId'] as String,
////      tempDistrictId: json['TempDistrictId'] as String,
//      dateOfBirthNepali: json['DateOfBirthNepali'] as String,
//      isAlreadyRegistered: json['IsAlreadyRegistered'] as  bool,
//      classId: json['ClassId'] as  int,
//      isSelected: json['IsSelected'] as  bool,
//      validTill: json['ValidTill'] as String,
//      studentName: json['StudentName'] as String,
//      educationalYearId: json['EducationalYearId'] as  int,
//      studentBusId: json['StudentBusId'] as  int,
////      dEOid: json['DEOid'] as String,
//      house: json['House'] as String,
//      houseName: json['HouseName'] as String,
//      localAddress: json['LocalAddress'] as String,
//    );}
//}