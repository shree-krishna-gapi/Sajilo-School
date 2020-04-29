class User {
  int id;
  String name;
  int email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["ProfileId"] as int,
      name: json["StudentName"] as String,
      email: json["RollNo"] as int,
    );
  }
}