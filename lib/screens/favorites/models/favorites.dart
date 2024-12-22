import 'dart:convert';

List<Favorites> favoriteFromJson(String str) =>
    List<Favorites>.from(json.decode(str).map((x) => Favorites.fromJson(x)));

String favoriteToJson(List<Favorites> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorites {
  String favorite;
  String foodie;
  String product;
  String productId;
  FCategory category;

  Favorites({
    required this.favorite,
    required this.foodie,
    required this.product,
    required this.productId,
    required this.category,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        favorite: json["favorite"],
        foodie: json["foodie"],
        product: json["product"],
        productId: json["product_id"],
        category: fCategoryValues.map[json["category"]]!,
      );

  Map<String, dynamic> toJson() => {
        "favorite": favorite,
        "foodie": foodie,
        "product": product,
        "product_id": productId,
        "category": category,
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
