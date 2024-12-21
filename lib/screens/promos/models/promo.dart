// To parse this JSON data, do
//
//     final promo = promoFromJson(jsonString);

import 'dart:convert';

List<Promo> promoFromJson(String str) =>
    List<Promo>.from(json.decode(str).map((x) => Promo.fromJson(x)));

String promoToJson(List<Promo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Promo {
  String id;
  String promoTitle;
  String restaurantName;
  String promoDescription;
  DateTime? batasPenggunaan;

  Promo({
    required this.id,
    required this.promoTitle,
    required this.restaurantName,
    required this.promoDescription,
    required this.batasPenggunaan,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        id: json["id"],
        promoTitle: json["promo_title"],
        restaurantName: json["restaurant_name"],
        promoDescription: json["promo_description"],
        batasPenggunaan: json["batas_penggunaan"] == null
            ? null
            : DateTime.parse(json["batas_penggunaan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "promo_title": promoTitle,
        "restaurant_name": restaurantName,
        "promo_description": promoDescription,
        "batas_penggunaan":
            "${batasPenggunaan!.year.toString().padLeft(4, '0')}-${batasPenggunaan!.month.toString().padLeft(2, '0')}-${batasPenggunaan!.day.toString().padLeft(2, '0')}",
      };
}
