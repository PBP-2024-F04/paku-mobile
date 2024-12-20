// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String id;
    User user;
    Product product;
    int rating;
    String comment;
    DateTime createdAt;
    DateTime updatedAt;

    Review({
        required this.id,
        required this.user,
        required this.product,
        required this.rating,
        required this.comment,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        user: User.fromJson(json["user"]),
        product: Product.fromJson(json["product"]),
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "product": product,
        "rating": rating,
        "comment": comment,
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

class Product {
  String productName;
  String restaurant;
  int price;

  Product({
    required this.productName,
    required this.restaurant,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productName: json["product_name"],
        restaurant: json["restaurant"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "restaurant": restaurant,
        "price": price,
      };
}