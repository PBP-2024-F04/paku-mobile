import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String id;
  User user;
  String text;
  bool isEdited;
  bool isMine;
  DateTime createdAt;
  DateTime updatedAt;

  Post({
    required this.id,
    required this.user,
    required this.text,
    required this.isEdited,
    required this.isMine,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        user: User.fromJson(json["user"]),
        text: json["text"],
        isEdited: json["is_edited"],
        isMine: json["is_mine"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "text": text,
        "is_edited": isEdited,
        "is_mine": isMine,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  String role;
  String displayName;
  String username;

  User({
    required this.role,
    required this.displayName,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        role: json["role"],
        displayName: json["display_name"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "display_name": displayName,
        "username": username,
      };
}
