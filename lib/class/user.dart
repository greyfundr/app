import 'dart:convert'; // Import for jsonEncode and jsonDecode

class User {
  final int id;
  final String first_name;
  final String last_name;
  final String profile_pic;
  final String username;
  final String occupation;

  User({required this.id, required this.first_name, required this.last_name, required this.profile_pic, required this.username, required this.occupation});

  // Convert object to a Map
  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": first_name,
    "last_name": last_name,
    "profile_pic": profile_pic,
    "username": username,
    "occupation": occupation,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    first_name: json["first_name"],
    last_name: json["last_name"],
    profile_pic: json["profile_pic"],
    username: json["username"],
    occupation: json["occupation"],
  );
}