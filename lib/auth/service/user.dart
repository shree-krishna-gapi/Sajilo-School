class School {
  int id;
  String name;
  String address;
  String logoImage;
  School({this.id, this.name, this.address,this.logoImage});

  factory School.fromJson(Map<String, dynamic> parsedJson) {
    return School(
      id: parsedJson["Id"],
      name: parsedJson["SchoolName"] as String,
      address: parsedJson["Address"] as String,
      logoImage: parsedJson["LogoImage"] as String,
    );
  }
}

class Test {
  int studentId;
  String studentName;
  int rollNo;
  Test({this.studentId,this.studentName,this.rollNo});
  factory Test.fromJson(Map<String, dynamic> parsedJson) {
    return Test(
      studentId: parsedJson["StudentId"],
      studentName: parsedJson["StudentName"] as String,
      rollNo: parsedJson["RollNo"] as int,
    );
  }
}


class Std {
  int studentId;
  String studentName;
  int rollNo;
  Std({this.studentId,this.studentName,this.rollNo});

  factory Std.fromJson(Map<String, dynamic> parsedJson) {
    return Std(
      studentId: parsedJson["StudentId"],
      studentName: parsedJson["StudentName"] as String,
      rollNo: parsedJson["RollNo"] as int,
    );
  }
}