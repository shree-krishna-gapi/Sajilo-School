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