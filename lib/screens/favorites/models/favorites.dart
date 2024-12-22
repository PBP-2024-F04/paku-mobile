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
    FCategory category;

    Fields({
        required this.foodie,
        required this.product,
        required this.category,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        foodie: json["foodie"],
        product: json["product"],
        category: fCategoryValues.map[json["category"]] ?? FCategory.wantToTry, // Default jika null
    );

    Map<String, dynamic> toJson() => {
        "foodie": foodie,
        "product": product,
        "category": fCategoryValues.reverse[category],
    };
}

enum FCategory {
  wantToTry,
  lovingIt,
  allTimeFavorites,
}

final fCategoryValues = EnumValues({
  "want_to_try": FCategory.wantToTry,
  "loving_it": FCategory.lovingIt,
  "all_time_favorites": FCategory.allTimeFavorites,
});


class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

extension FCategoryExtension on FCategory {
  String get displayName {
    switch (this) {
      case FCategory.wantToTry:
        return "Want to Try";
      case FCategory.lovingIt:
        return "Loving It";
      case FCategory.allTimeFavorites:
        return "All Time Favorites";
    }
  }

  String get apiName {
    switch (this) {
      case FCategory.wantToTry:
        return "wtt";
      case FCategory.lovingIt:
        return "li";
      case FCategory.allTimeFavorites:
        return "atf";
    }
  }
}