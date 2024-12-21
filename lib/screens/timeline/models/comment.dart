// To parse this JSON data, do
//
//   final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  String id;
  String text;
  String username;
  String displayname;
  String userRole;
  String userId;
  bool isEdited;

  Comment({
    required this.id,
    required this.text,
    required this.username,
    required this.displayname,
    required this.userRole,
    required this.userId,
    required this.isEdited,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    text: json["text"],
    username: json["username"],
    displayname: json["displayname"],
    userRole: json["user_role"],
    userId: json["user_id"],
    isEdited: json["is_edited"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "username": username,
    "displayname": displayname,
    "user_role": userRole,
    "user_id": userId,
    "is_edited": isEdited,
  };
}

