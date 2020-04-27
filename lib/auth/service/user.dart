class User {
  int id;
  String name;
  String address;
  String logoImage;
  User({this.id, this.name, this.address,this.logoImage});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson["Id"],
      name: parsedJson["SchoolName"] as String,
      address: parsedJson["Address"] as String,
      logoImage: parsedJson["LogoImage"] as String,
    );
  }
}

//class Student {
//  int studentId;
//  String studentName;
//  int rollNo;
//  Student({this.studentId,this.studentName,this.rollNo});
//  factory Student.fromJson(Map<String, dynamic> parsedJson) {
//    return Student(
//      studentId: parsedJson["StudentId"],
//      studentName: parsedJson["StudentName"] as String,
//      rollNo: parsedJson["RollNo"] as int,
//    );
//  }
//}