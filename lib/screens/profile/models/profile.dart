// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Profile commentFromJson(String str) => Profile.fromJson(json.decode(str));

String commentToJson(Profile data) => json.encode(data.toJson());

class Profile {
  String username;
  String displayName;
  String role;

  Profile({
    required this.username,
    required this.displayName,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        username: json["username"],
        displayName: json["display_name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "display_name": displayName,
        "role": role,
      };
}
