// To parse this JSON data, do
//
//     final favorites = favoritesFromJson(jsonString);

import 'dart:convert';

List<Favorites> favoritesFromJson(String str) => List<Favorites>.from(json.decode(str).map((x) => Favorites.fromJson(x)));

String favoritesToJson(List<Favorites> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorites {
    String model;
    String pk;
    Fields fields;

    Favorites({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String foodie;
    String product;
    String category;

    Fields({
        required this.foodie,
        required this.product,
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        foodie: json["foodie"],
        product: json["product"],
        category: json["category"],
    );

    Map<String, dynamic> toJson() => {
        "foodie": foodie,
        "product": product,
        "category": category,
    };
}
